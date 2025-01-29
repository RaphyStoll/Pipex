/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   free.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/26 15:41:34 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/28 21:56:09 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"

void	free_all(t_data *data)
{
	if (!data)
		return ;
	if (data->fd_input)
		close(data->fd_input);
	if (data->fd_output)
		close(data->fd_output);
	if (data->fd_pipe[0])
		close(data->fd_pipe[0]);
	if (data->fd_pipe[1])
		close(data->fd_pipe[1]);
	if (data->cmd1)
		free_array(data->cmd1);
	if (data->cmd2)
		free_array(data->cmd2);
	if (data->cmd_path)
		free(data->cmd_path);
	if (data->cmd_path2)
		free(data->cmd_path2);
	if (data)
		free(data);
}

void	free_array(char **array)
{
	int	i;

	if (!array)
		return ;
	i = 0;
	while (array[i])
	{
		free(array[i]);
		i++;
	}
	free(array);
}
