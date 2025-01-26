/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   noyaux.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphael <raphael@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 23:31:24 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/26 21:57:52 by raphael          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"

void proces(t_data *data)
{
	int		pid1;
	int 	pid2;

	pid1 = fork();
	if (pid1 == -1)
		ft_exit_error(data, "Fork failed");
	if (pid1 == 0) // child
	{
		close(data->fd_pipe[0]);
		close(data->fd_output);
		if (dup2(data->fd_input, STDIN_FILENO) == -1)
			ft_exit_error(data, "child1 : Dup2 stdin failed");
		if (dup2(data->fd_pipe[1], STDOUT_FILENO) == -1)
			ft_exit_error(data, "child1 : Dup2 stdout failed");
		close(data->fd_input);
		close(data->fd_pipe[1]);
		//printf("This is the child process. (pid: %d)\n", getpid());
		if(execve(data->cmd_path, data->cmd1, NULL) == -1)
				ft_exit_error(data, "Execve failed");
	}
	pid2 = fork();
	if (pid2 == -1)
		ft_exit_error(data, "Fork failed");
	if (pid2 == 0) // child 2
	{
		close(data->fd_pipe[1]);
		close(data->fd_input);
		if (dup2(data->fd_pipe[0], STDIN_FILENO) == -1)
			ft_exit_error(data, "child2 : Dup2 stdin failed");
		if (dup2(data->fd_output, STDOUT_FILENO) == -1)
			ft_exit_error(data, "child2 : Dup2 stdout failed");
		close(data->fd_output);
		close(data->fd_pipe[0]);
		data->cmd_path = find_path(data, data->cmd2[0]);
		//printf("This is the child process. (pid: %d)\n", getpid());
		if(execve(data->cmd_path, data->cmd2, NULL) == -1)
			ft_exit_error(data, "Execve failed");
	}
	else // parent
	{
		close(data->fd_pipe[0]);
		close(data->fd_pipe[1]);
		waitpid(pid1, NULL, 0);
		waitpid(pid2, NULL, 0);
		
	}
	//free(data->cmd_path);
}
