/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   noyaux.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphael <raphael@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 23:31:24 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/26 19:31:58 by raphael          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"

void proces(t_data *data)
{
	int		pid;

	pid = fork();
	if (pid == -1)
		ft_exit_error(data, "Fork failed");
	if (pid == 0) // child
	{
		close(data->fd_pipe[0]);
		dup2(data->fd_input, STDIN_FILENO);
		dup2(data->fd_pipe[1], STDOUT_FILENO);
		close(data->fd_input);
		close(data->fd_pipe[1]);
		if(execve(data->cmd_path, data->cmd1, NULL) == -1)
				ft_exit_error(data, "Execve failed");
		printf("This is the child process. (pid: %d)\n", getpid());
	}
	else // parent
	{
		waitpid(pid, NULL, 0);
		find_path(data, data->cmd2[0]);
		if(execve(data->cmd_path, data->cmd2, NULL) == -1)
			ft_exit_error(data, "Execve failed");
		printf("This is the parent process. (pid: %d)\n", getpid());
	}
	//free(cmd_path);
}
