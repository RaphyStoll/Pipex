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
        LEAKS_CMD="valgrind --leak-check=full"
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
    echo -e "${BOLD}Usage:${NC} $0 [${GREEN}-h${NC}|${GREEN}--help${NC}] [${GREEN}-l${NC}|${GREEN}--leaks${NC}]"
    echo -e "\n${BOLD}Description:${NC}"
    echo "Script de test pour le projet pipex de 42"
    echo -e "\n${BOLD}OS détecté:${NC} ${CYAN}$OS${NC}"
    if [ -n "$LEAKS_CMD" ]; then
        echo -e "${BOLD}Outil de détection de leaks:${NC} ${CYAN}${LEAKS_CMD}${NC}"
    else
        echo -e "${RED}Attention: Détection de leaks non disponible sur cet OS${NC}"
    fi
    echo -e "\n${BOLD}Options:${NC}"
    echo -e "${GREEN}-h, --help${NC}     Affiche cette aide"
    echo -e "${GREEN}-l, --leaks${NC}    Lance les tests avec la vérification des leaks"
    echo -e "\n${BOLD}Tests disponibles:${NC}"
    for test_name in "${!BASH_CMD[@]}"; do
        echo -e "${CYAN}$test_name${NC}"
        echo -e "└─ Commande: ${BASH_CMD[$test_name]}"
    done
    exit 0
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
    echo -e "${YELLOW} ${BOLD}Configuration de l'environnement de test...${NC}"
    mkdir -p "${BASH_DIR}" "${MAIN_DIR}" "${INFILE_DIR}" "${LEAKS_DIR}"
    
    cat > "$INFILE" << EOF
Hello World
This is a test file
42 School is amazing
Testing pipex project
Multiple spaces test
Special chars: !@#$ %^&*
EOF
}



run_test() {
    local test_name="$1"
    local test_num="$2"
    printf "\n%s%s%s\n" "===================" " Test $test_num: $test_name " "==================="
    local bash_out="${BASH_DIR}/test${test_num}.txt"
    local pipex_out="${MAIN_DIR}/test${test_num}.txt"
    local leaks_out="${LEAKS_DIR}/test${test_num}.txt"

    echo -e "${CYAN}Test de: $PIPEX $INFILE \"${CMD1[$test_name]}\" \"${CMD2[$test_name]}\" $pipex_out${NC}"

    # Exécution bash
    eval "< $INFILE ${BASH_CMD[$test_name]} > $bash_out"
    local bash_status=$?

    # Exécution pipex avec ou sans leaks
    if [ "$CHECK_LEAKS" = true ]; then
        if [ -n "$LEAKS_CMD" ]; then
            echo -e "${YELLOW}Vérification des leaks...${NC}"
            $LEAKS_CMD $PIPEX "$INFILE" "${CMD1[$test_name]}" "${CMD2[$test_name]}" "$pipex_out" &> "$leaks_out"
            local pipex_status=$?
            if grep -q "$LEAKS_CHECK" "$leaks_out"; then
                echo -e "${RED}Leaks détectés ! Voir $leaks_out pour plus de détails${NC}"
            else
                echo -e "${GREEN}Aucun leak détecté${NC}"
            fi
        else
            echo -e "${RED}La détection de leaks n'est pas disponible sur cet OS${NC}"
            $PIPEX "$INFILE" "${CMD1[$test_name]}" "${CMD2[$test_name]}" "$pipex_out"
            local pipex_status=$?
        fi
    else
        $PIPEX "$INFILE" "${CMD1[$test_name]}" "${CMD2[$test_name]}" "$pipex_out"
        local pipex_status=$?
    fi

    ((TOTAL_TESTS++))
    if [ -f "$pipex_out" ]; then
        if diff "$bash_out" "$pipex_out" > /dev/null; then
            echo -e "${GREEN}✓ Test réussi${NC}"
            ((PASSED_TESTS++))
            if [ $bash_status -eq $pipex_status ]; then
                echo -e "${GREEN}└─ Status de sortie correct ($pipex_status)${NC}"
            else
                echo -e "${YELLOW}└─ Status de sortie différent (bash: $bash_status, pipex: $pipex_status)${NC}"
            fi
        else
            echo -e "${RED}✗ Test échoué - Sortie différente${NC}"
            ((FAILED_TESTS++))
            echo -e "${YELLOW}Différences :${NC}"
            diff "$bash_out" "$pipex_out"
        fi
    else
        echo -e "${RED}✗ Test échoué - Fichier de sortie non créé${NC}"
        ((FAILED_TESTS++))
    fi
}


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