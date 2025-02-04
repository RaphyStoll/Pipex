/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 21:40:16 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/02/04 22:08:25 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"
#include <stdio.h>

int	main(int argc, char **argv)
{
	t_data	*data;
	int		final_error;

	data = NULL;
	data = init_data(data, argv);
	arg_verif(data, argc, argv);
	run_pipe(data);
	final_error = data->error_code;
	free_all(data);
	return (final_error);
}
