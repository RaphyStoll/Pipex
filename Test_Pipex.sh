#!/bin/bash

# Nettoyage du terminal
clear

# Couleurs pour l'affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'
BOLD='\033[1m'

# Chemins par défaut
PIPEX="./output/pipex"
BASH_OUTPUT="txt/test/bash"
MAIN_OUTPUT="txt/test/main"
INPUT_DIR="txt/test"
LEAKS_DIR="txt/leaks_test"

# Variables globales
VERBOSE=0
CHECK_LEAKS=0

# Détection de l'OS
OS=$(uname -s)

# Fonction pour nettoyer les fichiers de test
cleanup() {
    rm -f "$INPUT_DIR/infile"
    rm -f "$INPUT_DIR/numbers"
    rm -f "$INPUT_DIR/case_test"
    rm -f "$INPUT_DIR/whitespace"
}

# Fonction d'aide
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help         Affiche ce message d'aide"
    echo "  -v, --verbose      Affiche plus de détails sur les tests"
    echo "  -i, --interactive  Mode interactif pour configurer les chemins"
    echo "  -l, --leaks        Active la vérification des fuites mémoire"
    echo ""
    echo "Description:"
    echo "  Script de test pour le projet pipex qui compare les sorties"
    echo "  entre l'exécution bash standard et le programme pipex."
    echo ""
    echo "Chemins par défaut:"
    echo "  Programme pipex: $PIPEX"
    echo "  Sorties bash: $BASH_OUTPUT"
    echo "  Sorties pipex: $MAIN_OUTPUT"
    echo "  Fichiers d'entrée: $INPUT_DIR"
    echo "  Rapports de fuites: $LEAKS_DIR"
    exit 0
}

# Fonction pour le mode interactif
configure_paths() {
    echo -e "${BLUE}${BOLD}Configuration des chemins${NC}"
    echo -e "${BOLD}Appuyez sur Entrée pour garder la valeur par défaut${NC}\n"

    echo -e "Chemin actuel du programme pipex: ${BOLD}$PIPEX${NC}"
    read -p "Nouveau chemin: " new_pipex
    PIPEX=${new_pipex:-$PIPEX}

    echo -e "\nChemin actuel des sorties bash: ${BOLD}$BASH_OUTPUT${NC}"
    read -p "Nouveau chemin: " new_bash
    BASH_OUTPUT=${new_bash:-$BASH_OUTPUT}

    echo -e "\nChemin actuel des sorties pipex: ${BOLD}$MAIN_OUTPUT${NC}"
    read -p "Nouveau chemin: " new_main
    MAIN_OUTPUT=${new_main:-$MAIN_OUTPUT}

    echo -e "\nChemin actuel des fichiers d'entrée: ${BOLD}$INPUT_DIR${NC}"
    read -p "Nouveau chemin: " new_input
    INPUT_DIR=${new_input:-$INPUT_DIR}

    echo -e "\nChemin actuel des rapports de fuites: ${BOLD}$LEAKS_DIR${NC}"
    read -p "Nouveau chemin: " new_leaks
    LEAKS_DIR=${new_leaks:-$LEAKS_DIR}

    echo -e "\n${BOLD}Configuration finale:${NC}"
    echo "Programme pipex: $PIPEX"
    echo "Sorties bash: $BASH_OUTPUT"
    echo "Sorties pipex: $MAIN_OUTPUT"
    echo "Fichiers d'entrée: $INPUT_DIR"
    echo "Rapports de fuites: $LEAKS_DIR"

    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction pour tester les leaks selon l'OS
check_memory_leaks() {
    local test_name=$1
    local input_file="$INPUT_DIR/infile"
    local cmd1=$2
    local cmd2=$3
    
    mkdir -p "$LEAKS_DIR"
    
    echo -e "\n${BOLD}Test de fuites mémoire pour: $test_name${NC}"
    
    case $OS in
        "Darwin") # macOS
            echo -e "${BLUE}Utilisation de 'leaks' sur macOS${NC}"
            leaks --atExit -- $PIPEX "$input_file" "$cmd1" "$cmd2" "$MAIN_OUTPUT/leak_test" &> "$LEAKS_DIR/${test_name// /_}_leaks.txt"
            if grep -q "leaks Report Version:" "$LEAKS_DIR/${test_name// /_}_leaks.txt"; then
                if grep -q "0 leaks for 0 total leaked bytes" "$LEAKS_DIR/${test_name// /_}_leaks.txt"; then
                    echo -e "${GREEN}✓ Aucune fuite mémoire détectée${NC}"
                else
                    echo -e "${RED}✗ Fuites mémoire détectées${NC}"
                    echo "Voir le rapport détaillé dans: $LEAKS_DIR/${test_name// /_}_leaks.txt"
                fi
            else
                echo -e "${YELLOW}⚠ Impossible d'analyser les fuites mémoire${NC}"
            fi
            ;;
            
        "Linux")
            echo -e "${BLUE}Utilisation de 'valgrind' sur Linux${NC}"
            valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes \
                    --verbose --log-file="$LEAKS_DIR/${test_name// /_}_valgrind.txt" \
                    $PIPEX "$input_file" "$cmd1" "$cmd2" "$MAIN_OUTPUT/leak_test" &>/dev/null
            
            if grep -q "no leaks are possible" "$LEAKS_DIR/${test_name// /_}_valgrind.txt"; then
                echo -e "${GREEN}✓ Aucune fuite mémoire détectée${NC}"
            else
                echo -e "${RED}✗ Fuites mémoire potentielles détectées${NC}"
                echo "Voir le rapport détaillé dans: $LEAKS_DIR/${test_name// /_}_valgrind.txt"
            fi
            ;;
            
        *)
            echo -e "${RED}Système d'exploitation non supporté pour le test de fuites mémoire${NC}"
            return 1
            ;;
    esac
}

# Fonction pour exécuter un test et comparer les résultats
run_test() {
    local test_name=$1
    local input_file=$2
    local cmd1=$3
    local cmd2=$4
    local test_num=$5
    
    echo -e "\n${BOLD}Test $test_num: $test_name${NC}"
    
    if [ $VERBOSE -eq 1 ]; then
        echo "Commandes: $cmd1 | $cmd2"
    fi
    
    # Exécution avec bash
    < "$INPUT_DIR/$input_file" $cmd1 | $cmd2 > "$BASH_OUTPUT/test${test_num}"
    
    # Exécution avec pipex
    $PIPEX "$INPUT_DIR/$input_file" "$cmd1" "$cmd2" "$MAIN_OUTPUT/test${test_num}"
    
    # Comparaison des résultats
    if diff "$BASH_OUTPUT/test${test_num}" "$MAIN_OUTPUT/test${test_num}" >/dev/null ; then
        echo -e "${GREEN}✓ Test réussi${NC}"
        return 0
    else
        echo -e "${RED}✗ Test échoué${NC}"
        if [ $VERBOSE -eq 1 ]; then
            echo "Différences trouvées:"
            diff "$BASH_OUTPUT/test${test_num}" "$MAIN_OUTPUT/test${test_num}"
        fi
        return 1
    fi
}

# Traitement des arguments
for arg in "$@"; do
    case $arg in
        -h|--help)
            show_help
            ;;
        -v|--verbose)
            VERBOSE=1
            ;;
        -i|--interactive)
            configure_paths
            ;;
        -l|--leaks)
            CHECK_LEAKS=1
            ;;
    esac
done

# Vérification de l'existence du programme
if [ ! -f "$PIPEX" ]; then
    echo -e "${RED}Erreur: Le programme pipex n'existe pas dans $PIPEX${NC}"
    exit 1
fi

# Création des dossiers nécessaires
mkdir -p "$BASH_OUTPUT" "$MAIN_OUTPUT" "$INPUT_DIR"

# Initialisation du compteur de tests
total_tests=0
passed_tests=0

# Création des fichiers de test
echo -e "Hello World\nTest ligne 2\n42 école\nBonjour le monde\nTest\n42\nÉcole 42\n" > "$INPUT_DIR/infile"
echo -e "123\n456\n789\n123\n456\n" > "$INPUT_DIR/numbers"
echo -e "TEST\ntest\nTeSt\nTEST\ntest\n" > "$INPUT_DIR/case_test"
echo -e "   spaces   \ntabs\t\t\nlines\n\n\nend" > "$INPUT_DIR/whitespace"

# Liste des tests
echo -e "${BOLD}=== Tests basiques ===${NC}"

# Test 1: ls et wc
((total_tests++))
run_test "ls et wc" "infile" "ls -l" "wc -l" $total_tests && ((passed_tests++))

# Test 2: grep et wc
((total_tests++))
run_test "grep et wc" "infile" "grep Test" "wc -l" $total_tests && ((passed_tests++))

# Test 3: cat et grep
((total_tests++))
run_test "cat et grep" "infile" "cat" "grep 42" $total_tests && ((passed_tests++))

echo -e "\n${BOLD}=== Tests de tri et filtrage ===${NC}"

# Test 4: sort et uniq
((total_tests++))
run_test "sort et uniq" "infile" "sort" "uniq" $total_tests && ((passed_tests++))

# Test 5: sort avec options
((total_tests++))
run_test "sort numérique inverse" "numbers" "sort -nr" "uniq -c" $total_tests && ((passed_tests++))

# Test 6: tri et grep
((total_tests++))
run_test "tri et grep" "case_test" "sort" "grep -i test" $total_tests && ((passed_tests++))

echo -e "\n${BOLD}=== Tests avec options ===${NC}"

# Test 7: grep avec options
((total_tests++))
run_test "grep insensible à la casse" "case_test" "grep -i test" "wc -l" $total_tests && ((passed_tests++))

# Test 8: wc avec options
((total_tests++))
run_test "wc complet" "whitespace" "cat" "wc -lwc" $total_tests && ((passed_tests++))

# Test 9: grep inversé
((total_tests++))
run_test "grep inversé" "infile" "grep -v Test" "wc -l" $total_tests && ((passed_tests++))

echo -e "\n${BOLD}=== Tests chemins absolus ===${NC}"

# Test 10: commandes avec chemin absolu
((total_tests++))
run_test "chemins absolus" "infile" "/bin/cat" "/usr/bin/grep test" $total_tests && ((passed_tests++))

# Test 11: chemin absolu avec options
((total_tests++))
run_test "chemin absolu et options" "infile" "/usr/bin/grep -i test" "/usr/bin/wc -l" $total_tests && ((passed_tests++))

echo -e "\n${BOLD}=== Tests caractères spéciaux ===${NC}"

# Test 12: grep avec quotes
((total_tests++))
run_test "grep avec quotes simples" "infile" "grep 'école'" "wc -w" $total_tests && ((passed_tests++))

# Test 13: grep avec quotes doubles
((total_tests++))
run_test "grep avec quotes doubles" "infile" "grep \"42\"" "wc -l" $total_tests && ((passed_tests++))

# Test 14: espaces multiples
((total_tests++))
run_test "gestion des espaces" "whitespace" "grep '   spaces'" "wc -l" $total_tests && ((passed_tests++))

echo -e "\n${BOLD}=== Tests commandes complexes ===${NC}"

# Test 15: cut et sort
((total_tests++))
run_test "cut et sort" "infile" "cut -d' ' -f1" "sort -r" $total_tests && ((passed_tests++))

# Test 16: tr et grep
((total_tests++))
run_test "tr et grep" "case_test" "tr [:lower:] [:upper:]" "grep TEST" $total_tests && ((passed_tests++))

# Test 17: sed et grep
((total_tests++))
run_test "sed et grep" "infile" "sed 's/Test/TEST/g'" "grep TEST" $total_tests && ((passed_tests++))

# Test 18: head et tail
((total_tests++))
run_test "head et tail" "numbers" "head -n 3" "tail -n 2" $total_tests && ((passed_tests++))

echo -e "\n${BOLD}=== Tests erreurs communes ===${NC}"

# Test 19: commande avec options multiples
((total_tests++))
run_test "options multiples" "infile" "grep -i -v Test" "wc -l" $total_tests && ((passed_tests++))

# Test 20: commandes avec path relatif
((total_tests++))
run_test "path relatif" "infile" "./cat" "wc -l" $total_tests && ((passed_tests++))

# Tests de fuites mémoire si activé
if [ $CHECK_LEAKS -eq 1 ]; then
    check_memory_leaks "Test basique" "ls -l" "wc -l"
    check_memory_leaks "Test complexe" "grep -i test" "sort -r"
    check_memory_leaks "Test avec quotes" "grep 'école'" "wc -w"
fi

# Affichage du résumé
echo -e "\n${BOLD}=== Résumé des tests ===${NC}"
echo -e "Tests réussis: ${GREEN}$passed_tests${NC}"
echo -e "Tests échoués: ${RED}$((total_tests - passed_tests))${NC}"
echo -e "Total des tests: $total_tests"

# Nettoyage final
if [ $VERBOSE -eq 0 ]; then
    cleanup
fi

exit $((total_tests - passed_tests))