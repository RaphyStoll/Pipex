#include "../../include/main/fonction.h"

void	print_struct(t_data *data)
{
	int	i;

	ft_printf(CYAN"fd_input: %d\n", data->fd_input);
	ft_printf(CYAN"fd_output: %d\n", data->fd_output);
	ft_printf(CYAN"fd_pipe[0]: %d\n", data->fd_pipe[0]);
	ft_printf(CYAN"fd_pipe[1]: %d\n", data->fd_pipe[1]);
	i = 0;
	if (data->cmd1)
	{
		while (data->cmd1[i])
		{
			printf("cmd1[%d]: %s\n", i, data->cmd1[i]);
			i++;
		}
	}
	i = 0;
	if (data->cmd2)
	{
		while (data->cmd2[i])
		{
			printf("cmd2[%d]: %s\n", i, data->cmd2[i]);
			i++;
		}
	}
	printf("cmd_path: %s\n", data->cmd_path);
}