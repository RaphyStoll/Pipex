/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_printf_utils.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/04 16:27:13 by raphaelferr       #+#    #+#             */
/*   Updated: 2024/11/17 18:56:37 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

int	ft_putchar_printf(char c)
{
	return (write(1, &c, 1));
}

int	ft_putstr_printf(char *str)
{
	int	count;

	count = 0;
	if (!str)
	{
		count += write(1, "(null)", 6);
		return (count);
	}
	while (*str)
	{
		count += ft_putchar_printf(*str);
		str++;
	}
	return (count);
}
