/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 21:40:16 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/29 15:18:19 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"
#include <stdio.h>

//$ coriger printf il semble bugger a plusieurs moment surtout sur %s

int main(int argc, char **argv, char **envp)
{
	t_data *data;
	int final_error;
	(void)envp;

	data = NULL;
	arg_verif(data, argc, argv);
	data = init_data(data, argv);
	run_pipe(data);
	//proces(data);
	final_error = data->error_code;
	free_all(data);
	//printf("%d\n", final_error);
	return (final_error);
}
