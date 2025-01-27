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

# Configuration des chemins
PIPEX="./output/pipex"
TEST_DIR="test"
BASH_DIR="test/bash"
MAIN_DIR="test/main"
INFILE_DIR="${TEST_DIR}/input"
INFILE="${INFILE_DIR}/infile.txt"

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

setup_test_env() {
    echo -e "${BOLD}Configuration de l'environnement de test...${NC}"
    mkdir -p "${BASH_DIR}" "${MAIN_DIR}" "${INFILE_DIR}"
    
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
    
    echo -e "${CYAN}Test de: $PIPEX $INFILE \"${CMD1[$test_name]}\" \"${CMD2[$test_name]}\" $pipex_out${NC}"
    
    # Exécution bash
    eval "< $INFILE ${BASH_CMD[$test_name]} > $bash_out"
    local bash_status=$?
    
    # Exécution pipex
    $PIPEX "$INFILE" "${CMD1[$test_name]}" "${CMD2[$test_name]}" "$pipex_out"
    local pipex_status=$?
    
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