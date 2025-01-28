# ------------------------------------------------------------------------------
# Configuration principale
# ------------------------------------------------------------------------------

# Nom de l'exécutable principal et bonus
NAME        = output/pipex
NAME_BONUS  = output/pipex_bonus

# Compilateur et flags
CC          = gcc
CFLAGS      = -g -Wall -Wextra -Werror

# Commandes pratiques
MKDIR       = mkdir -p
RM          = rm -f

# Couleurs et styles
BLACK       = \033[0;30m
RED         = \033[0;91m
GREEN       = \033[0;92m
YELLOW      = \033[0;93m
BLUE        = \033[0;94m
MAGENTA     = \033[0;95m
CYAN        = \033[0;96m
WHITE       = \033[0;97m

BOLD        = \033[1m
UNDERLINE   = \033[4m
RESET       = \033[0m

# Répertoires
SRC_DIR     = source
MAIN_DIR    = $(SRC_DIR)/main
BONUS_DIR   = $(SRC_DIR)/bonus

OBJ_DIR     = objects
MAIN_OBJ    = $(OBJ_DIR)/main
BONUS_OBJ   = $(OBJ_DIR)/bonus

OUTPUT_DIR  = output

# Répertoires des bibliothèques tierces
FT_PRINTF_DIR = ft_printf
GNL_DIR       = gnl

# Bibliothèques statiques
FT_PRINTF_LIB = $(FT_PRINTF_DIR)/libftprintf.a
GNL_LIB       = $(GNL_DIR)/libgnl.a

# Regroupe toutes les libs
ALL_LIBS      = $(FT_PRINTF_LIB) $(GNL_LIB)

# ------------------------------------------------------------------------------
# Sources Principales (NOMS SANS EXTENSION)
# ------------------------------------------------------------------------------
MAIN_SRC = \
    main \
    utils \
	ft_split \
	lib \
	init \
	parsing \
	free \
	debbug

# Liste complète des sources principales
MAIN_SRCS = $(addprefix $(MAIN_DIR)/, $(addsuffix .c, $(MAIN_SRC)))
MAIN_OBJS = $(addprefix $(MAIN_OBJ)/, $(addsuffix .o, $(MAIN_SRC)))

# ------------------------------------------------------------------------------
# Sources Bonus (NOMS SANS EXTENSION)
# ------------------------------------------------------------------------------
BONUS_SRC =

# Liste complète des sources bonus
BONUS_SRCS = $(addprefix $(BONUS_DIR)/, $(addsuffix .c, $(BONUS_SRC)))
BONUS_OBJS = $(addprefix $(BONUS_OBJ)/, $(addsuffix .o, $(BONUS_SRC)))

# ------------------------------------------------------------------------------
# Cibles principales
# ------------------------------------------------------------------------------
all: $(FT_PRINTF_LIB) $(GNL_LIB) $(NAME)

bonus: $(FT_PRINTF_LIB) $(GNL_LIB) $(NAME_BONUS)

# ------------------------------------------------------------------------------
# Compilation du binaire principal
# ------------------------------------------------------------------------------
$(NAME): $(MAIN_OBJS) | $(OUTPUT_DIR)
	@echo "$(CYAN)→ Linking objects for the main build...$(RESET)"
	$(CC) $(CFLAGS) $(MAIN_OBJS) $(ALL_LIBS) -o $(NAME)
	@echo "$(BOLD)$(GREEN)✔ Finished building $(NAME)$(RESET)"

# ------------------------------------------------------------------------------
# Compilation du binaire bonus
# ------------------------------------------------------------------------------
$(NAME_BONUS): $(BONUS_OBJS) | $(OUTPUT_DIR)
	@echo "$(CYAN)→ Linking objects for the bonus build...$(RESET)"
	$(CC) $(CFLAGS) $(BONUS_OBJS) $(ALL_LIBS) -o $(NAME_BONUS)
	@echo "$(BOLD)$(GREEN)✔ Finished building $(NAME_BONUS)$(RESET)"

# ------------------------------------------------------------------------------
# Création des répertoires
# ------------------------------------------------------------------------------
$(OUTPUT_DIR):
	@echo "$(YELLOW)Creating output directory '$(OUTPUT_DIR)'$(RESET)"
	@$(MKDIR) $(OUTPUT_DIR)

$(MAIN_OBJ):
	@echo "$(YELLOW)Creating object directory '$(MAIN_OBJ)'$(RESET)"
	@$(MKDIR) $(MAIN_OBJ)

$(BONUS_OBJ):
	@echo "$(YELLOW)Creating object directory '$(BONUS_OBJ)'$(RESET)"
	@$(MKDIR) $(BONUS_OBJ)

# ------------------------------------------------------------------------------
# Règles de compilation pour les sources principales
# ------------------------------------------------------------------------------
$(MAIN_OBJ)/%.o: $(MAIN_DIR)/%.c | $(MAIN_OBJ)
	@echo "$(BLUE)Compiling $< → $@$(RESET)"
	$(CC) $(CFLAGS) -c $< -o $@ $(INCLUDES)

# ------------------------------------------------------------------------------
# Règles de compilation pour les sources bonus
# ------------------------------------------------------------------------------
$(BONUS_OBJ)/%.o: $(BONUS_DIR)/%.c | $(BONUS_OBJ)
	@echo "$(MAGENTA)Compiling $< (bonus) → $@$(RESET)"
	$(CC) $(CFLAGS) -c $< -o $@ $(INCLUDES)

# ------------------------------------------------------------------------------
# Règles pour compiler les bibliothèques tierces
# ------------------------------------------------------------------------------
$(FT_PRINTF_LIB):
	@echo "$(YELLOW)→ Building ft_printf library...$(RESET)"
	@$(MAKE) -C $(FT_PRINTF_DIR)

$(GNL_LIB):
	@echo "$(YELLOW)→ Building gnl library...$(RESET)"
	@$(MAKE) -C $(GNL_DIR)

# ------------------------------------------------------------------------------
# Nettoyage
# ------------------------------------------------------------------------------
clean:
	@echo "$(RED)→ Removing object files...$(RESET)"
	$(RM) $(MAIN_OBJS) $(BONUS_OBJS)
	@echo "$(RED)→ Removing '$(OBJ_DIR)' directory...$(RESET)"
	$(RM) -r $(OBJ_DIR)

fclean: clean
	@echo "$(RED)→ Removing executables...$(RESET)"
	$(RM) $(NAME) $(NAME_BONUS)

cleanall: fclean
	@echo "$(RED)→ Cleaning ft_printf and gnl libraries...$(RESET)"
	@$(MAKE) -C $(FT_PRINTF_DIR) fclean
	@$(MAKE) -C $(GNL_DIR) fclean

re: fclean all

# ------------------------------------------------------------------------------
# Cibles phony
# ------------------------------------------------------------------------------
.PHONY: all clean fclean re bonus cleanall
