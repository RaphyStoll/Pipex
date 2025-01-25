/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   init.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 15:49:56 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/25 19:39:11 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"

void	init_data(t_data *data, char **argv)
{
	data = malloc(sizeof(t_data));
	if (!data)
		ft_exit_error("Malloc failed");
	if (access(argv[1], R_OK))
		ft_exit_error("Input file not accessible");
	data->fd_input = open(argv[1], O_RDONLY);
	if (data->fd_input == -1)
		ft_exit_error("Open failed");
	if (access(argv[4], W_OK))
		ft_exit_error("Output file not accessible");
	data->fd_output = open("argv[4]", O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (data->fd_output == -1)
		ft_exit_error("Open failed");
	if (pipe(data->fd_pipe) == -1)
		ft_exit_error("Pipe failed");
	parse_cmd(data, argv[2], argv[3]);
}

void	parse_cmd(t_data *data, char *cmd1, char *cmd2)
{
	data->cmd1 = ft_split(cmd1, ' ');
	if (!data->cmd1)
		ft_exit_error("Malloc cm1 failed");
	data->cmd2 = ft_split(cmd2, ' ');
	if (!data->cmd2)
	{
		free_array(data->cmd1);
		ft_exit_error("Malloc cm2 failed");
	}
}

void	free_array(char **array)
{
	int	i;

	i = 0;
	while (array[i])
	{
		free(array[i]);
		i++;
	}
	free(array);
}
