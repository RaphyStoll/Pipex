NAME = libgnl.a
CC = gcc
CFLAGS = -Wall -Wextra -Werror
AR = ar rcs
MKDIR = mkdir -p

OBJDIR = objects

SRC = get_next_line get_next_line_utils

SRCS = $(addsuffix .c, $(SRC))
OBJS = $(addprefix $(OBJDIR)/, $(addsuffix .o, $(SRC)))



$(OBJDIR)/%.o: %.c
	$(MKDIR) $(OBJDIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(NAME): $(OBJS)
	$(AR) $@ $^

all: $(NAME)

clean:
	rm -f $(OBJ)
	rm -rf $(OBJDIR)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re