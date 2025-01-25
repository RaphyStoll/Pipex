#include "../../include/main/fonction.h"

int main(int argc, char **argv)
{
	t_data *data;

	data = NULL;
	arg_verif(argc, argv);
	init_data(data, argv);
}