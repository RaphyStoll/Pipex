#!/bin/bash

# Couleurs pour l'affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

# Création du dossier de test s'il n'existe pas
mkdir -p test_files

# Fonction pour nettoyer les fichiers de test
cleanup() {
    rm -f test_files/infile test_files/outfile1 test_files/outfile2
}

# Fonction pour exécuter un test et comparer les résultats
run_test() {
    local test_name=$1
    local input_file=$2
    local cmd1=$3
    local cmd2=$4
    
    echo -e "\n${BOLD}Test: $test_name${NC}"
    echo "Commandes: $cmd1 | $cmd2"
    
    # Exécution avec bash
    < test_files/infile $cmd1 | $cmd2 > test_files/outfile1
    
    # Exécution avec pipex
    ./pipex test_files/infile "$cmd1" "$cmd2" test_files/outfile2
    
    # Comparaison des résultats
    if diff test_files/outfile1 test_files/outfile2 >/dev/null ; then
        echo -e "${GREEN}✓ Test réussi${NC}"
        return 0
    else
        echo -e "${RED}✗ Test échoué${NC}"
        echo "Différences trouvées:"
        diff test_files/outfile1 test_files/outfile2
        return 1
    fi
}

# Initialisation du compteur de tests
total_tests=0
passed_tests=0

# Création des fichiers de test
echo -e "Hello World\nTest ligne 2\n42 école\nBonjour le monde\nTest\n42\nÉcole 42\n" > test_files/infile

# Liste des tests
echo -e "${BOLD}=== Début des tests ===${NC}"

# Test 1: ls et wc
((total_tests++))
run_test "ls et wc" "infile" "ls -l" "wc -l" && ((passed_tests++))

# Test 2: grep et wc
((total_tests++))
run_test "grep et wc" "infile" "grep Test" "wc -l" && ((passed_tests++))

# Test 3: cat et grep
((total_tests++))
run_test "cat et grep" "infile" "cat" "grep 42" && ((passed_tests++))

# Test 4: sort et uniq
((total_tests++))
run_test "sort et uniq" "infile" "sort" "uniq" && ((passed_tests++))

# Test 5: grep avec des quotes
((total_tests++))
run_test "grep avec quotes" "infile" "grep 'école'" "wc -w" && ((passed_tests++))

# Test 6: commandes complexes
((total_tests++))
run_test "commandes complexes" "infile" "cat -e" "grep -v 42" && ((passed_tests++))

# Affichage du résumé
echo -e "\n${BOLD}=== Résumé des tests ===${NC}"
echo -e "Tests réussis: ${GREEN}$passed_tests${NC}"
echo -e "Tests échoués: ${RED}$((total_tests - passed_tests))${NC}"
echo -e "Total des tests: $total_tests"

# Nettoyage final
cleanup

exit $((total_tests - passed_tests))