/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 21:40:20 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/29 15:35:00 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"
#include "../../include/main/colors.h"

void arg_verif(t_data *data, int argc, char **argv)
{
	(void)argv;
	if (argc != 5)
		ft_exit_error(data, "Wrong number of arguments", ERROR_GENERAL);
	//ft_printf(GREEN BOLD "Arguments are correct\n");
}
void ft_exit_error(t_data *data, char *message, t_error error_code)
{

	free_all(data);
	if (error_code == ERROR_CMD_NOT_FOUND)
        ft_printf(RED BOLD"Error: Command not found\n"NC);
    else if (error_code == ERROR_PERMISSION)
        ft_printf(RED BOLD"Error: Permission denied\n"NC);
    else if (error_code == ERROR_SYNTAX)
        ft_printf(RED BOLD"Error: Syntax error\n"NC);
    else
        perror(RED BOLD"Error"NC);
    ft_printf(YELLOW"%s\n"NC, message);
	data->error_code = error_code;
    exit(error_code);
}

void printf_struct(t_data *data)
{
	int i;
	ft_printf(YELLOW"fd_input: %d\n"NC, data->fd_input);
	ft_printf(YELLOW"fd_output: %d\n"NC, data->fd_output);
	ft_printf(YELLOW"fd_pipe[0]: %d\n"NC, data->fd_pipe[0]);
	ft_printf(YELLOW"fd_pipe[1]: %d\n"NC, data->fd_pipe[1]);
	i = 0;
	while (data->cmd1[i])
	{
		ft_printf(YELLOW"cmd1[%d]: %s\n"NC, i, data->cmd1[i]);
		i++;
	}
	i = 0;
	while (data->cmd2[i])
	{
		ft_printf(YELLOW"cmd2[%d]: %s\n"NC, i, data->cmd2[i]);
		i++;
	}
	ft_printf(YELLOW"file1: %s\n"NC, data->file1);
	ft_printf(YELLOW"file2: %s\n"NC, data->file2);
	ft_printf(YELLOW"paths: %s\n"NC, data->paths);
	ft_printf(YELLOW"cmd_path: %s\n"NC, data->cmd_path);
	ft_printf(YELLOW"cmd_path2: %s\n"NC, data->cmd_path2);
	printf(GREEN"===end printf struct===\n"NC);
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