#include "../../include/main/fonction.h"

int main(int argc, char **argv)
{
	if (!arg_verif(argc, argv))
	{
		ft_exit_error(YELLOW, "Wrong number of arguments");
	}

}