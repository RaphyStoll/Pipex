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

    echo -e "\n${BOLD}Configuration finale:${NC}"
    echo "Programme pipex: $PIPEX"
    echo "Sorties bash: $BASH_OUTPUT"
    echo "Sorties pipex: $MAIN_OUTPUT"
    echo "Fichiers d'entrée: $INPUT_DIR"

    read -p "Appuyez sur Entrée pour continuer..."
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

[Le reste du script reste identique jusqu'à la partie des tests]

# Après chaque test, si CHECK_LEAKS est activé
if [ $CHECK_LEAKS -eq 1 ]; then
    check_memory_leaks "Test basique" "ls -l" "wc -l"
    check_memory_leaks "Test complexe" "grep -i test" "sort -r"
    check_memory_leaks "Test avec quotes" "grep 'école'" "wc -w"
fi

[Le reste du script reste identique]