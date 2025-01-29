/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   struct.h                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 14:43:30 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/29 14:36:54 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef STRUCT_H
# define STRUCT_H

typedef struct s_data
{
	int		fd_input;
	int		fd_output;
	int		fd_pipe[2];
	char	**cmd1;
	char	**cmd2;
	char 	*file1;
	char 	*file2;
	char	*paths;
	char	*cmd_path;
	char 	*cmd_path2;
	char	error_code;
	int		status;
	int		status2;
	int		exit_status;
	int		exit_status2;
}	t_data;

typedef enum e_error
{
    SUCCESS = 0,
    ERROR_GENERAL = 1,
    ERROR_SYNTAX = 2,
    ERROR_PERMISSION = 126,
    ERROR_CMD_NOT_FOUND = 127,
    ERROR_INVALID_ARG = 128,
    ERROR_CTRL_C = 130,
    ERROR_OUT_OF_RANGE = 255
} t_error;

typedef struct s_split
{
	char		**words;
	int		word_count;
	int		start;
	int		len;
}	t_split;

#endif