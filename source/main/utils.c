/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphalme <raphalme@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 21:40:20 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/28 16:05:50 by raphalme         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"
#include "../../include/main/colors.h"

void arg_verif(t_data *data, int argc, char **argv)
{
	(void)argv;
	if (argc != 5)
		ft_exit_error(data, "Wrong number of arguments");
	//ft_printf(GREEN BOLD "Arguments are correct\n");
}
void ft_exit_error(t_data *data, char *message)
{
	free_all(data);
	(void)message;
	perror(RED BOLD"Error");
	exit(1);
}

void printf_struct(t_data *data)
{
	int i;
	ft_printf(YELLOW"fd_input: %d\n", data->fd_input);
	ft_printf(YELLOW"fd_output: %d\n", data->fd_output);
	ft_printf(YELLOW"fd_pipe[0]: %d\n", data->fd_pipe[0]);
	ft_printf(YELLOW"fd_pipe[1]: %d\n", data->fd_pipe[1]);
	i = 0;
	while (data->cmd1[i])
	{
		ft_printf(YELLOW"cmd1[%d]: %s\n", i, data->cmd1[i]);
		i++;
	}
	i = 0;
	while (data->cmd2[i])
	{
		ft_printf(YELLOW"cmd2[%d]: %s\n", i, data->cmd2[i]);
		i++;
	}
	printf(GREEN"===end printf struct===\n");
}

char	*ft_strjoin(char const *s1, char const *s2)
{
	char	*dest;
	int		count;
	int		count2;

	count = 0;
	if (!s1 || !s2)
		return (NULL);
	dest = malloc(ft_strlen(s1) + ft_strlen(s2) + 1);
	if (!dest)
		return (NULL);
	while (s1[count])
	{
		dest[count] = s1[count];
		count++;
	}
	count2 = count;
	count = 0;
	while (s2[count])
	{
		dest[count2] = s2[count];
		count++;
		count2++;
	}
	dest[count2] = '\0';
	return (dest);
}