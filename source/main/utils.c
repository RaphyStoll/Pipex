/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 21:40:20 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/02/19 15:18:14 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"
#include "../../include/main/colors.h"

void	arg_verif(t_data *data, int argc, char **argv)
{
	int	fd;

	(void)argv;
	if (argc != 5)
		ft_exit_error(data, "Wrong number of arguments", ERROR_GENERAL);
	if (access(argv[1], F_OK) == -1)
		ft_exit_error(data, "Argv[1] error", ERROR_CMD_NOT_FOUND);
	fd = open(data->file2, O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (fd == -1)
		ft_exit_error(data, "Arvg[4] error", ERROR_GENERAL);
	close(fd);
}

void	ft_exit_error(t_data *data, char *message, t_error error_code)
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
