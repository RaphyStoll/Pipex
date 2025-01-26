/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   fonction.h                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 14:43:38 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/26 01:56:13 by raphaelferr      ###   ########.fr       */
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
#include <stdlib.h>
#include <stdio.h>

//!int main
int main(int argc, char **argv);

//! utils
void arg_verif(int argc, char **argv);
void ft_exit_error(char *message);
void printf_struct(t_data *data);
void	free_array(char **array);
char	*ft_strjoin(char const *s1, char const *s2);

//! init
t_data	*init_data(t_data *data, char **argv);
void	parse_cmd(t_data *data, char *cmd1, char *cmd2);

//! split
char	**ft_split(char const *s, char c);
char	**allocate_and_fill(char const *s, char c);
char	*get_next_word(char const *s, char c, int *index);
int		count_words(const char *s, char c);

//! libc
char	*ft_strdup(const char *s1);
int		ft_strlen(const char *s);
char	*ft_substr(char const *s, int start, int len);

//! noyaux
void proces(t_data *data);
char 	*find_path(t_data *data);

//! debug
void	print_struct(t_data *data);
#endif