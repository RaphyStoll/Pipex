/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 21:40:16 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/26 16:10:51 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"
#include <stdio.h>

//$ coriger printf il semble bugger a plusieurs moment surtout sur %s

int main(int argc, char **argv)
{
	t_data *data;

	data = NULL;
	arg_verif(data, argc, argv);
	data = init_data(data, argv);
	proces(data);
	free_all(data);
	//printf_struct(data);
}
