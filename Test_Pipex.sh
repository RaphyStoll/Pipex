#!/bin/bash

# Nettoyage du terminal
clear

# Couleurs et styles
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Chemins par défaut
PIPEX="./output/pipex"
BASH_OUTPUT="txt/test/bash"
MAIN_OUTPUT="txt/test/main"
INPUT_DIR="txt/test"
LEAKS_DIR="txt/leaks_test"
REPORTS_DIR="txt/reports"
HTML_REPORT="$REPORTS_DIR/report.html"

# Variables globales
VERBOSE=0
CHECK_LEAKS=0
TIME_EXEC=0
SAVE_OUTPUT=0
CUSTOM_TEST=0
FOCUS_TEST=""
NORMINETTE=0
BONUS=0
START_TIME=$(date +%s)

# Détection de l'OS
OS=$(uname -s)

# Fonction pour afficher la barre de progression
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    printf "\rProgression: ["
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' ' '
    printf "] %d%%" "$percentage"
}

# Fonction pour mesurer le temps d'exécution
measure_time() {
    local start_time=$1
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    echo "$duration"
}

# Fonction pour vérifier la norme
check_norm() {
    if command -v norminette &> /dev/null; then
        echo -e "\n${BOLD}=== Vérification de la norme ===${NC}"
        local norm_output=$(norminette ../*.{c,h} 2>&1)
        if echo "$norm_output" | grep -q "Error!"; then
            echo -e "${RED}✗ Erreurs de norme détectées${NC}"
            echo "$norm_output"
            return 1
        else
            echo -e "${GREEN}✓ Norme respectée${NC}"
            return 0
        fi
    else
        echo -e "${YELLOW}⚠ Norminette non trouvée${NC}"
        return 0
    fi
}

# Fonction pour vérifier le Makefile
check_makefile() {
    echo -e "\n${BOLD}=== Vérification du Makefile ===${NC}"
    local makefile="../Makefile"
    
    if [ ! -f "$makefile" ]; then
        echo -e "${RED}✗ Makefile non trouvé${NC}"
        return 1
    fi
    
    # Vérification des règles obligatoires
    local required_rules=("all" "clean" "fclean" "re")
    local missing_rules=0
    
    for rule in "${required_rules[@]}"; do
        if ! grep -q "^$rule:" "$makefile"; then
            echo -e "${RED}✗ Règle '$rule' manquante${NC}"
            missing_rules=1
        fi
    done
    
    # Vérification des flags de compilation
    if ! grep -q -- "-Wall" "$makefile" || ! grep -q -- "-Wextra" "$makefile" || ! grep -q -- "-Werror" "$makefile"; then
        echo -e "${RED}✗ Flags de compilation manquants (-Wall -Wextra -Werror)${NC}"
        missing_rules=1
    fi
    
    if [ $missing_rules -eq 0 ]; then
        echo -e "${GREEN}✓ Makefile conforme${NC}"
        return 0
    fi
    return 1
}

# Fonction pour tester here_doc (bonus)
test_here_doc() {
    echo -e "\n${BOLD}=== Tests here_doc ===${NC}"
    local limiter="EOF"
    local test_num=$((total_tests + 1))
    
    # Création du fichier d'entrée temporaire pour here_doc
    echo "ligne 1
ligne 2
ligne test
dernière ligne" > "$INPUT_DIR/here_doc_input"
    
    echo -e "${BLUE}Test here_doc avec grep${NC}"
    echo "ligne 1
ligne 2
ligne test
dernière ligne
$limiter" | $PIPEX "here_doc" "$limiter" "grep ligne" "wc -l" "$MAIN_OUTPUT/test_here_doc"
    
    # Vérification du résultat
    local expected=4
    local result=$(cat "$MAIN_OUTPUT/test_here_doc")
    
    if [ "$result" -eq "$expected" ]; then
        echo -e "${GREEN}✓ Test here_doc réussi${NC}"
        ((passed_tests++))
    else
        echo -e "${RED}✗ Test here_doc échoué${NC}"
    fi
    ((total_tests++))
}

# Menu interactif pour le mode personnalisé
custom_test_menu() {
    echo -e "\n${BOLD}=== Test personnalisé ===${NC}"
    echo -e "Entrez les détails du test :"
    
    read -p "Fichier d'entrée (dans $INPUT_DIR) : " input_file
    read -p "Première commande : " cmd1
    read -p "Deuxième commande : " cmd2
    
    echo -e "\nExécution du test personnalisé..."
    run_test "Test personnalisé" "$input_file" "$cmd1" "$cmd2" "custom"
}

# Fonction pour générer le rapport HTML
generate_html_report() {
    mkdir -p "$REPORTS_DIR"
    
    cat > "$HTML_REPORT" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Rapport de tests Pipex</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 20px auto; }
        .success { color: green; }
        .failure { color: red; }
        .warning { color: orange; }
        .test { margin: 10px 0; padding: 10px; border: 1px solid #ddd; }
    </style>
</head>
<body>
    <h1>Rapport de tests Pipex</h1>
    <p>Date: $(date)</p>
    <h2>Résumé</h2>
    <p>Tests réussis: <span class="success">$passed_tests</span>/$total_tests</p>
    <p>Tests échoués: <span class="failure">$((total_tests - passed_tests))</span>/$total_tests</p>
    <p>Temps total d'exécution: $(measure_time $START_TIME) secondes</p>
EOF

    # Ajout des détails de chaque test
    echo "<h2>Détails des tests</h2>" >> "$HTML_REPORT"
    for test in "${test_results[@]}"; do
        echo "<div class='test'>$test</div>" >> "$HTML_REPORT"
    done

    echo "</body></html>" >> "$HTML_REPORT"
    
    echo -e "\n${BOLD}Rapport HTML généré : $HTML_REPORT${NC}"
}

# Fonction d'aide améliorée
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help         Affiche ce message d'aide"
    echo "  -v, --verbose      Affiche plus de détails sur les tests"
    echo "  -i, --interactive  Mode interactif pour configurer les chemins"
    echo "  -l, --leaks        Active la vérification des fuites mémoire"
    echo "  -t, --time         Mesure le temps d'exécution de chaque test"
    echo "  -f, --focus        Exécute un test spécifique (numéro)"
    echo "  -s, --save-output  Conserve les sorties des tests"
    echo "  -c, --custom       Permet d'entrer ses propres commandes à tester"
    echo "  -n, --norm         Vérifie la norme"
    echo "  -b, --bonus        Active les tests bonus (here_doc)"
    echo ""
    echo "Exemple d'utilisation:"
    echo "  $0 -v -l          # Tests verbeux avec vérification des fuites"
    echo "  $0 -f 5           # Exécute uniquement le test numéro 5"
    echo "  $0 -c             # Lance le mode de test personnalisé"
    exit 0
}

# Traitement des arguments amélioré
while [[ $# -gt 0 ]]; do
    case $1 in
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
        -t|--time)
            TIME_EXEC=1
            ;;
        -f|--focus)
            shift
            FOCUS_TEST="$1"
            ;;
        -s|--save-output)
            SAVE_OUTPUT=1
            ;;
        -c|--custom)
            CUSTOM_TEST=1
            ;;
        -n|--norm)
            NORMINETTE=1
            ;;
        -b|--bonus)
            BONUS=1
            ;;
        *)
            echo "Option invalide: $1"
            show_help
            ;;
    esac
    shift
done

# Vérification initiale
if [ ! -f "$PIPEX" ]; then
    echo -e "${RED}Erreur: Le programme pipex n'existe pas dans $PIPEX${NC}"
    exit 1
fi

# Création des dossiers nécessaires
mkdir -p "$BASH_OUTPUT" "$MAIN_OUTPUT" "$INPUT_DIR" "$LEAKS_DIR" "$REPORTS_DIR"

# Vérification de la norme si demandée
if [ $NORMINETTE -eq 1 ]; then
    check_norm
    check_makefile
fi

# Le reste du script (tests) reste identique, mais avec les nouvelles fonctionnalités activées selon les options

# Génération du rapport HTML à la fin
generate_html_report