/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 21:40:16 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/30 06:51:23 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"
#include <stdio.h>

int	main(int argc, char **argv)
{
	t_data	*data;
	int		final_error;

	data = NULL;
	arg_verif(data, argc, argv);
	data = init_data(data, argv);
	run_pipe(data);
	final_error = data->error_code;
	free_all(data);
	return (final_error);
}
