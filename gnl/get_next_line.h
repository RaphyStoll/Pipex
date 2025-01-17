/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.h                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/10 22:56:45 by raphaelferr       #+#    #+#             */
/*   Updated: 2024/11/17 18:21:46 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef GET_NEXT_LINE_H
# define GET_NEXT_LINE_H

# include <unistd.h>
# include <stdlib.h>

# ifndef BUFFER_SIZE
#  define BUFFER_SIZE 5
# endif

typedef struct s_gnl
{
	int				fd;
	char			*remainder;
	struct s_gnl	*next;
}	t_gnl;

char	*get_next_line(int fd);
char	*read_and_extract_line(t_gnl *node, char *buffer);
char	*extract_line(t_gnl *node);
t_gnl	*get_fd_node(t_gnl **head, int fd);
void	remove_fd_node(t_gnl **head, int fd);
char	*ft_strjoin_gnl(char const *s1, char const *s2);
char	*ft_substr_gnl(char const *s, unsigned int start, size_t len);
char	*ft_strchr_gnl(const char *s, int c);
size_t	ft_strlen_gnl(const char *s);
char	*ft_substr_gnl(char const *s, unsigned int start, size_t len);
#endif