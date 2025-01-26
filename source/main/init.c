/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   init.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 15:49:56 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/26 16:40:44 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"
#include <stdio.h>

t_data	*init_data(t_data *data, char **argv)
{
	data = malloc(sizeof(t_data));
	if (!data)
		ft_exit_error(data, "Malloc failed");
	if (access(argv[1], R_OK) == -1)
		ft_exit_error(data, "Input file not accessible");
	data->fd_input = open(argv[1], O_RDONLY);
	if (data->fd_input == -1)
		ft_exit_error(data, "Open input failed");
	data->fd_output = open(argv[4], O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (data->fd_output == -1)
		ft_exit_error(data, "Open output failed");
	if (access(argv[4], W_OK) == -1)
		ft_exit_error(data, "Output file not accessible");
	if (pipe(data->fd_pipe) == -1)
		ft_exit_error(data, "Pipe failed");
	data->cmd1 = NULL;
	data->cmd2 = NULL;
	parse_cmd(data, argv[2], argv[3]);
	return (data);
}

void	parse_cmd(t_data *data, char *cmd1, char *cmd2)
{
	data->cmd1 = ft_split(cmd1, ' ');
	if (!data->cmd1)
		ft_exit_error(data, "Malloc cm1 failed");
	data->cmd2 = ft_split(cmd2, ' ');
	if (!data->cmd2)
	{
		free_array(data->cmd1);
		ft_exit_error(data, "Malloc cm2 failed");
	}
	data->paths =
		"/bin/:/usr/bin/:/usr/local/bin/:/sbin/:/usr/sbin/:/usr/local/sbin/";
	data->cmd_path = find_path(data);

	print_struct(data);
}

void print_struct(t_data *data)
{
	int i;

	ft_printf(CYAN"fd_input: %d\n", data->fd_input);
	ft_printf(CYAN"fd_output: %d\n", data->fd_output);
	ft_printf(CYAN"fd_pipe[0]: %d\n", data->fd_pipe[0]);
	ft_printf(CYAN"fd_pipe[1]: %d\n", data->fd_pipe[1]);
	i = 0;
	if (data->cmd1)
		while (data->cmd1[i])
		{
			printf("cmd1[%d]: %s\n", i, data->cmd1[i]);
			i++;
		}
	i = 0;
	if (data->cmd2)
		while (data->cmd2[i])
		{
			printf("cmd2[%d]: %s\n", i, data->cmd2[i]);
			i++;
		}
	printf("cmd_path: %s\n", data->cmd_path);
}

char 	*find_path(t_data *data)
{
	char	**cmd_paths;
	char	*path;
	int		i;
	char	*tmp;

	cmd_paths = ft_split(data->paths, ':');
	if (!cmd_paths)
		ft_exit_error(data, "Malloc cmd_paths failed");
	i = 0;
	 while (cmd_paths[i])
	{
		tmp = ft_strjoin(cmd_paths[i], data->cmd1[0]);
		if (!tmp)
			ft_exit_error(data, "Malloc tmp failed");
		if (access(tmp, X_OK) == 0)
			return (free_array(cmd_paths),tmp);
		free(tmp);
		i++;
	}
	path = ft_strjoin(cmd_paths[i], data->cmd1[0]);
	if (!path)
		ft_exit_error(data, "Malloc path failed");
	free_array(cmd_paths);
	return (path);
}
