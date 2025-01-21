#include "../../include/main/fonction.h"
#include "../../include/main/colors.h"

void arg_verif(int argc, char **argv)
{
	(void)argv;
	if (argc != 5)
		ft_exit_error("Wrong number of arguments");
	ft_printf(GREEN BOLD "Arguments are correct\n");
}
void ft_exit_error(char *message)
{
	(void)message;
	ft_printf(RED BOLD"ERROR\n");
	ft_printf(YELLOW "%s\n", message);
	exit(0);
}