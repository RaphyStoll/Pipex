/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   struct.h                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 14:43:30 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/26 01:39:53 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef STRUCT_H
# define STRUCT_H

typedef struct s_data
{
	int     fd_input;
	int     fd_output;
	int     fd_pipe[2];
	char    **cmd1;
	char    **cmd2;
	char	*paths;
}   t_data;

typedef struct s_split
{
   char	**words;
   int		word_count;
   int		start;
   int		len;
}	t_split;

#endif