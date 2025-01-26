/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   free.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/26 15:41:34 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/26 16:41:51 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"

void	free_all(t_data *data)
{
	if (!data)
		return ;
	if (data->cmd1)
		free_array(data->cmd1);
	if (data->cmd2)
		free_array(data->cmd2);
	if (data->cmd_path)
		free(data->cmd_path);
	if (data)
		free(data);
}

void	free_array(char **array)
{
	if (!array)
		return ;
	int	i;

	i = 0;
	while (array[i])
	{
		free(array[i]);
		i++;
	}
	free(array);
}
