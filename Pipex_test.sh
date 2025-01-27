#!/bin/bash

# Couleurs et styles
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
NC='\033[0m'

# Variables pour le comptage
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
CHECK_LEAKS=false
VERBOSE=false
QUIET=false
CUSTOM_INFILE=""
SPECIFIC_TEST=""
TEST_TIMEOUT=5 #5 secondes par default

# Configuration des chemins
PIPEX="./output/pipex"
TEST_DIR="test"
BASH_DIR="test/bash"
MAIN_DIR="test/main"
INFILE_DIR="${TEST_DIR}/input"
INFILE="${INFILE_DIR}/infile.txt"
LEAKS_DIR="${TEST_DIR}/leaks"

# Définition des tests avec des arrays associatifs multidimensionnels
declare -A BASH_CMD
declare -A CMD1
declare -A CMD2

# Test basique ls
BASH_CMD[test_basique_ls]="ls -l | wc -l"
CMD1[test_basique_ls]="ls -l"
CMD2[test_basique_ls]="wc -l"

# Test grep simple
BASH_CMD[test_grep_simple]="grep test | wc -w"
CMD1[test_grep_simple]="grep test"
CMD2[test_grep_simple]="wc -w"

# Test cat grep
BASH_CMD[test_cat_grep]="cat | grep Hello"
CMD1[test_cat_grep]="cat"
CMD2[test_cat_grep]="grep Hello"

# Test sort uniq
BASH_CMD[test_sort_uniq]="sort | uniq"
CMD1[test_sort_uniq]="sort"
CMD2[test_sort_uniq]="uniq"


# Détection de l'OS et configuration du leak checker
OS=$(uname -s)
case $OS in
    "Darwin")
        if [[ $(sw_vers -productVersion) > "10.13" ]]; then
            LEAKS_CMD="leaks -atExit --"
            LEAKS_CHECK="leaks for"
        else
            LEAKS_CMD="leaks"
            LEAKS_CHECK="Process"
        fi
        ;;
    "Linux")
        LEAKS_CMD="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes"
        LEAKS_CHECK="definitely lost"
        ;;
    *)
        echo -e "${RED}OS non supporté pour la détection de leaks${NC}"
        LEAKS_CMD=""
        LEAKS_CHECK=""
        ;;
esac

#------------------------------------------------------------------------------

# print l'aide
print_help() {
    echo -e "${BOLD}Usage:${NC} $0 [OPTIONS]"
    echo -e "\n${BOLD}Description:${NC}"
    echo "Script de test pour le projet pipex de 42"
    echo -e "\n${BOLD}OS détecté:${NC} ${CYAN}$OS${NC}"
    if [ -n "$LEAKS_CMD" ]; then
        echo -e "${BOLD}Outil de détection de leaks:${NC} ${CYAN}${LEAKS_CMD}${NC}"
    else
        echo -e "${RED}Attention: Détection de leaks non disponible sur cet OS${NC}"
    fi
    echo -e "\n${BOLD}Options:${NC}"
    echo -e "${GREEN}-h, --help${NC}            Affiche cette aide"
    echo -e "${GREEN}-l, --leaks${NC}           Lance les tests avec la vérification des leaks"
    echo -e "${GREEN}-v, --verbose${NC}         Mode verbeux - affiche plus de détails"
    echo -e "${GREEN}-q, --quiet${NC}           Mode silencieux - n'affiche que le résumé"
    echo -e "${GREEN}-f, --file${NC} FILE       Utilise FILE comme fichier d'entrée"
    echo -e "${GREEN}-c, --clean${NC}           Nettoie les fichiers de test avant de commencer"
    echo -e "${GREEN}-s, --specific${NC} TEST   Exécute uniquement le test spécifié"
    echo -e "${GREEN}-t, --timeout${NC} SEC     Définit le timeout des tests (défaut: 5s)"
    echo -e "\n${BOLD}Tests disponibles:${NC}"
    for test_name in "${!BASH_CMD[@]}"; do
        echo -e "${CYAN}$test_name${NC}"
        echo -e "└─ Commande: ${BASH_CMD[$test_name]}"
    done
    exit 0
}

clean_test_files() {
    echo -e "${YELLOW}Nettoyage des fichiers de test...${NC}"
    rm -rf "${BASH_DIR}"/* "${MAIN_DIR}"/* "${LEAKS_DIR}"/*
}

# Gestion des options
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        -l|--leaks)
            CHECK_LEAKS=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            QUIET=false
            shift
            ;;
        -q|--quiet)
            QUIET=true
            VERBOSE=false
            shift
            ;;
        -f|--file)
            if [ -f "$2" ]; then
                INFILE="$2"
                shift 2
            else
                echo -e "${RED}Erreur: Le fichier $2 n'existe pas${NC}"
                exit 1
            fi
            ;;
        -c|--clean)
            clean_test_files
            shift
            ;;
        -s|--specific)
            if [ -n "${BASH_CMD[$2]}" ]; then
                SPECIFIC_TEST="$2"
                shift 2
            else
                echo -e "${RED}Erreur: Test '$2' non trouvé${NC}"
                exit 1
            fi
            ;;
        -t|--timeout)
            if [[ "$2" =~ ^[0-9]+$ ]]; then
                TEST_TIMEOUT="$2"
                shift 2
            else
                echo -e "${RED}Erreur: Le timeout doit être un nombre${NC}"
                exit 1
            fi
            ;;
        *)
            if [[ $1 == -* ]]; then
                echo -e "${RED}Option invalide: $1${NC}"
                print_help
                exit 1
            fi
            shift
            ;;
    esac
done


setup_test_env() {
    echo -e "${BOLD}Configuration de l'environnement de test...${NC}"
    mkdir -p "${BASH_DIR}" "${MAIN_DIR}" "${INFILE_DIR}"
    
    # Ne créer le fichier par défaut que si aucun fichier personnalisé n'est spécifié
    if [ "$INFILE" = "${INFILE_DIR}/infile.txt" ]; then
        cat > "$INFILE" << EOF
Hello World
This is a test file
42 School is amazing
Testing pipex project
Multiple spaces test
Special chars: !@#$ %^&*
EOF
    fi
}



run_test() {
    local test_name="$1"
    local test_num="$2"
    if [ "$QUIET" = false ]; then
        printf "\n%s%s%s\n" "===================" " Test $test_num: $test_name " "==================="
    fi
    local bash_out="${BASH_DIR}/test${test_num}.txt"
    local pipex_out="${MAIN_DIR}/test${test_num}.txt"
    local leaks_out="${LEAKS_DIR}/test${test_num}.txt"

    if [ "$VERBOSE" = true ]; then
        echo -e "${CYAN}Détails du test:${NC}"
        echo -e "└─ Fichier d'entrée: $INFILE"
        echo -e "└─ Commande bash: ${BASH_CMD[$test_name]}"
        echo -e "└─ Commande 1: ${CMD1[$test_name]}"
        echo -e "└─ Commande 2: ${CMD2[$test_name]}"
        echo -e "└─ Fichier de sortie: $pipex_out"
    elif [ "$QUIET" = false ]; then
        echo -e "${CYAN}Test de: $PIPEX $INFILE \"${CMD1[$test_name]}\" \"${CMD2[$test_name]}\" $pipex_out${NC}"
    fi

    # Exécution bash
    eval "< $INFILE ${BASH_CMD[$test_name]} > $bash_out"
    local bash_status=$?

    # Exécution pipex avec ou sans leaks
    if [ "$CHECK_LEAKS" = true ]; then
        if [ -n "$LEAKS_CMD" ]; then
            if [ "$QUIET" = false ]; then
                echo -e "${YELLOW}Vérification des leaks...${NC}"
            fi
            timeout $TEST_TIMEOUT $LEAKS_CMD $PIPEX "$INFILE" "${CMD1[$test_name]}" "${CMD2[$test_name]}" "$pipex_out" &> "$leaks_out"
            local pipex_status=$?
            if [ $pipex_status -eq 124 ]; then
                echo -e "${RED}✗ Test échoué - Timeout après $TEST_TIMEOUT secondes${NC}"
                ((FAILED_TESTS++))
                return
            fi
            if grep -q "$LEAKS_CHECK" "$leaks_out"; then
                if [ "$QUIET" = false ]; then
                    echo -e "${RED}Leaks détectés ! Voir $leaks_out pour plus de détails${NC}"
                fi
            elif [ "$QUIET" = false ]; then
                echo -e "${GREEN}Aucun leak détecté${NC}"
            fi
        else
            if [ "$QUIET" = false ]; then
                echo -e "${RED}La détection de leaks n'est pas disponible sur cet OS${NC}"
            fi
            timeout $TEST_TIMEOUT $PIPEX "$INFILE" "${CMD1[$test_name]}" "${CMD2[$test_name]}" "$pipex_out"
            local pipex_status=$?
            if [ $pipex_status -eq 124 ]; then
                echo -e "${RED}✗ Test échoué - Timeout après $TEST_TIMEOUT secondes${NC}"
                ((FAILED_TESTS++))
                return
            fi
        fi
    else
        timeout $TEST_TIMEOUT $PIPEX "$INFILE" "${CMD1[$test_name]}" "${CMD2[$test_name]}" "$pipex_out"
        local pipex_status=$?
        if [ $pipex_status -eq 124 ]; then
            echo -e "${RED}✗ Test échoué - Timeout après $TEST_TIMEOUT secondes${NC}"
            ((FAILED_TESTS++))
            return
        fi
    fi

    ((TOTAL_TESTS++))
    if [ -f "$pipex_out" ]; then
        if diff "$bash_out" "$pipex_out" > /dev/null; then
            if [ "$QUIET" = false ]; then
                echo -e "${GREEN}✓ Test réussi${NC}"
            fi
            ((PASSED_TESTS++))
            if [ "$VERBOSE" = true ]; then
                if [ $bash_status -eq $pipex_status ]; then
                    echo -e "${GREEN}└─ Status de sortie correct ($pipex_status)${NC}"
                else
                    echo -e "${YELLOW}└─ Status de sortie différent (bash: $bash_status, pipex: $pipex_status)${NC}"
                fi
            fi
        else
            if [ "$QUIET" = false ]; then
                echo -e "${RED}✗ Test échoué - Sortie différente${NC}"
                if [ "$VERBOSE" = true ]; then
                    echo -e "${YELLOW}Différences :${NC}"
                    diff "$bash_out" "$pipex_out"
                fi
            fi
            ((FAILED_TESTS++))
        fi
    else
        if [ "$QUIET" = false ]; then
            echo -e "${RED}✗ Test échoué - Fichier de sortie non créé${NC}"
        fi
        ((FAILED_TESTS++))
    fi
}

# Dans la boucle principale
if [ -n "$SPECIFIC_TEST" ]; then
    run_test "$SPECIFIC_TEST" "01"
else
    test_num=1
    for test_name in "${!BASH_CMD[@]}"; do
        if [ "$QUIET" = false ]; then
            run_test "$test_name" $(printf "%02d" $test_num)
        else
            run_test "$test_name" $(printf "%02d" $test_num) > /dev/null
        fi
        ((test_num++))
    done
fi



# Vérification de l'existence de pipex
if [ ! -f "$PIPEX" ]; then
    echo -e "${RED}Erreur: pipex non trouvé dans $PIPEX${NC}"
    exit 1
fi

# Initialisation
setup_test_env

# Exécution des tests
test_num=1
for test_name in "${!BASH_CMD[@]}"; do
    run_test "$test_name" $(printf "%02d" $test_num)
    ((test_num++))
done

# Affichage du résumé
echo -e "\n${BOLD}=== Résumé des Tests ===${NC}"
echo -e "${GREEN}Tests réussis: $PASSED_TESTS/$TOTAL_TESTS ${NC}"
echo -e "${RED}Tests échoués: $FAILED_TESTS/$TOTAL_TESTS ${NC}"

if [ $TOTAL_TESTS -eq 0 ]; then
    echo -e "${BLUE}Pourcentage de réussite: 0%${NC}"
else
    echo -e "${BLUE}Pourcentage de réussite: $(( (PASSED_TESTS * 100) / TOTAL_TESTS ))%${NC}"
fi

echo -e "\n${BOLD}Tests terminés${NC}"