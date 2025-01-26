/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 21:40:16 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/26 02:16:27 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"
#include <stdio.h>

//$TODO: voir pour mettre les arguments dans la structure et mettre find_path dans le parsing(init)
//$ coriger printf il semble bugger a plusieurs moment surtout sur %s

int main(int argc, char **argv)
{
	t_data *data;

	data = NULL;
	arg_verif(argc, argv);
	data = init_data(data, argv);
	proces(data);
	//printf_struct(data);
}