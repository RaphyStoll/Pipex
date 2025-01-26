/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   noyaux.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 23:31:24 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/26 16:00:10 by raphaelferr      ###   ########.fr       */
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
		printf("This is the child process. (pid: %d)\n", getpid());
		if(execve(data->cmd1[0], data->cmd1, NULL) == -1)
				ft_exit_error(data, "Execve failed");
	}
	else // parent
	{
		printf("This is the parent process. (pid: %d)\n", getpid());
	}
	//free(cmd_path);
}
