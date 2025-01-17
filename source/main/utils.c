#include "../../include/main/fonction.h"

int arg_verif(int argc, char **argv)
{
	(void)argv;
	if (argc != 5)
		return(FALSE);
	return(TRUE);
}
void ft_exit_error(char *color, char *message)
{
	ft_printf(RED BOLD"ERROR\n%s%s\n" , color, message);
	exit(0);
}