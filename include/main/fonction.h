/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   fonction.h                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 14:43:38 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/25 20:47:46 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef FONCTION_H
#define FONCTION_H

#include "colors.h"
#include "macro.h"
#include "struct.h"
#include "../../ft_printf/ft_printf.h"
#include "../../gnl/get_next_line.h"
#include <unistd.h>
#include <fcntl.h>

//!int main
int main(int argc, char **argv);

//! utils
void arg_verif(int argc, char **argv);
void ft_exit_error(char *message);

//! init
void	init_data(t_data *data, char **argv);
void	parse_cmd(t_data *data, char *cmd1, char *cmd2);

//! split
char	**ft_split(char const *str, char c);
void	free_array(char **array);

//! libc
char	*ft_strdup(const char *s1);
int	ft_strlen(const char *s);
char	*ft_substr(char const *s, unsigned int start, size_t len);
#endif