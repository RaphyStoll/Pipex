/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   init.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 15:49:56 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/29 14:05:11 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"


t_data	*init_data(t_data *data, char **argv)
{
	data = malloc(sizeof(t_data));
	if (!data)
		ft_exit_error(data, "Malloc failed", ERROR_GENERAL);
	default_init(data);
	if (pipe(data->fd_pipe) == -1)
		ft_exit_error(data, "Pipe failed", ERROR_GENERAL);
	data->file1 = argv[1];
	data->file2 = argv[4];
	data = parse_cmd(data, argv[2], argv[3]);
	return (data);
}

t_data	*parse_cmd(t_data *data, char *cmd1, char *cmd2)
{
	data->cmd1 = ft_split(cmd1, ' ');
	if (!data->cmd1)
		ft_exit_error(data, "Malloc cm1 failed", ERROR_GENERAL);
	data->cmd2 = ft_split(cmd2, ' ');
	if (!data->cmd2)
	{
		free_array(data->cmd1);
		ft_exit_error(data, "Malloc cm2 failed", ERROR_GENERAL);
	}
	data->paths = \
	"/bin/:/usr/bin/:/usr/local/bin/:/sbin/:/usr/sbin/:/usr/local/sbin/";
	
	
	//data->cmd_path = find_path(data, data->cmd1[0]);
	//print_struct(data);
	return (data);
}


char *get_cmd_path(t_data *data, char *cmd)
{
	char	**cmd_paths;
	int		i;
	char	*tmp;
	if (access(data->cmd1[0], X_OK) == 0)
			return (ft_strdup(cmd));
	cmd_paths = ft_split(data->paths, ':');
	if (!cmd_paths)
		ft_exit_error(data, "Malloc cmd_paths failed", ERROR_GENERAL);
	i = 0;
	while (cmd_paths[i])
	{
		tmp = ft_strjoin(cmd_paths[i], cmd);
		if (!tmp)
		{
			free_array(cmd_paths);
			ft_exit_error(data, "Malloc tmp failed", ERROR_GENERAL);
		}
		if (access(tmp, X_OK) == 0)
			return (free_array(cmd_paths), tmp);
		free(tmp);
		i++;
	}
	free_array(cmd_paths);
	return (NULL);
}

int open_files(t_data *data, char *infile, char *outfile)
{
	data->fd_input = open(infile, O_RDONLY);
	if (data->fd_input == -1)
		perror("Error"); // On continue même si erreur
	data->fd_output = open(outfile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (data->fd_output == -1)
	{
		perror("Error");
		return (-1); // Erreur critique pour le fichier de sortie
	}
	return (0);
}

void	default_init(t_data *data)
{
	data->fd_input = 0;
	data->fd_output = 0;
	data->fd_pipe[0] = 0;
	data->fd_pipe[1] = 0;
	data->cmd1 = NULL;
	data->cmd2 = NULL;
	data->paths = NULL;
	data->cmd_path = NULL;
	data->cmd_path2 = NULL;
	data->error_code = 0;
}

