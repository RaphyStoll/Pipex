/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphalme <raphalme@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 21:40:16 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/28 17:39:54 by raphalme         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"
#include <stdio.h>

//$ coriger printf il semble bugger a plusieurs moment surtout sur %s

int main(int argc, char **argv, char **envp)
{
	t_data *data;

	data = NULL;
	arg_verif(data, argc, argv);
	data = init_data(data, argv);
	parsing(data);
	//proces(data);
	free_all(data);
	//printf_struct(data);
}
