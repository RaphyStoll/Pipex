/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   noyaux.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 23:31:24 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/26 02:04:13 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"

void proces(t_data *data)
{
	(void)data;
	int		pid;
	char	*cmd_path;
	
	cmd_path = find_path(data);
	cmd_path = ft_strjoin(cmd_path, data->cmd1[0]);
	printf("cmd_path: %s\n", cmd_path);
	pid = fork();
	if (pid == -1)
		ft_exit_error("Fork failed");
	if (pid == 0) // child
	{
		(void)cmd_path;
		printf("This is the child process. (pid: %d)\n", getpid());
		//execve(data->cmd1[0], data->cmd1, NULL);
	}
	else // parent
	{
		printf("This is the parent process. (pid: %d)\n", getpid());
	}
	//free(cmd_path);
}

char 	*find_path(t_data *data)
{
	char **cmd_paths;
	int i;

	cmd_paths = ft_split(data->paths, ':');
	i = 0;
	while(cmd_paths[i])
	{
		if (access(cmd_paths[i], X_OK) == 0)
			return (cmd_paths[i]);
		i++;
	}
	return (NULL);
}