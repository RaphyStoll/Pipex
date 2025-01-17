/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/10 22:55:03 by raphaelferr       #+#    #+#             */
/*   Updated: 2024/11/17 18:46:58 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"
/**
*@brief
** supprime un noeud de la liste chainee
*@param current represente le noeud actuel
*@param previous represente le noeud precedent
*@param head represente le debut de la liste chainee
*@param fd represente le file descriptor
*@return 
*$ void
*/
void	remove_fd_node(t_gnl **head, int fd)
{
	t_gnl	*current;
	t_gnl	*previous;

	if (!head || !*head)
		return ;
	current = *head;
	previous = NULL;
	while (current)
	{
		if (current->fd == fd)
		{
			if (previous == NULL)
				*head = current->next;
			else
				previous->next = current->next;
			if (current->remainder)
				free(current->remainder);
			free(current);
			return ;
		}
		previous = current;
		current = current->next;
	}
}

/**
*@brief
** lit et extrait une ligne de la chaine de caractere
*@param node le noeud actuel
*@param buffer la chaine de caractere lu
*@param bytes_read represente le nombre(int) de byte lu
*@param temp represente la chaine de caractere temporaire
*@return
*$ retourne la ligne lu ou NULL si erreur ou rien a lire
*/
char	*read_and_extract_line(t_gnl *node, char *buffer)
{
	ssize_t	bytes_read;
	char	*temp;

	while (1)
	{
		if (ft_strchr_gnl(node->remainder, '\n'))
			return (extract_line(node));
		bytes_read = read(node->fd, buffer, BUFFER_SIZE);
		if (bytes_read <= 0)
		{
			if (bytes_read == 0 && node->remainder && node->remainder[0])
				return ((temp = node->remainder), node->remainder = NULL, temp);
			else
				return (NULL);
		}
		buffer[bytes_read] = '\0';
		temp = ft_strjoin_gnl(node->remainder, buffer);
		if (!temp)
			return (NULL);
		free(node->remainder);
		node->remainder = temp;
	}
}
/**
*@brief
** extrait une ligne de la chaine de caractere
*@param node le noeud actuel
*@param buffer la chain de caractere lu
*@param newline_pos la position du caractere '\n'
*@param line la ligne a retourner avec le ‘\n’ ou NULL si fin de fichier
*@param temp_remainder la chaine de caractere temporaire pour stocker le reste de la ligne
*@param line_len la taille de la ligne
*@return
*$ que return la fonction
*/
char	*extract_line(t_gnl *node)
{
	char	*newline_pos;
	char	*line;
	char	*temp_remainder;
	size_t	line_len;

	newline_pos = ft_strchr_gnl(node->remainder, '\n');
	if (!newline_pos)
		return (NULL);
	line_len = newline_pos - node->remainder + 1;
	line = ft_substr_gnl(node->remainder, 0, line_len);
	if (!line)
		return (NULL);
	if (ft_strlen_gnl(node->remainder + line_len) > 0)
	{
		temp_remainder = ft_substr_gnl(node->remainder, line_len, ft_strlen_gnl(
					node->remainder + line_len));
		free(node->remainder);
		node->remainder = temp_remainder;
	}
	else
	{
		free(node->remainder);
		node->remainder = NULL;
	}
	return (line);
}
/**
*@brief
** cherche un noeud dans la liste chainee
*@param head le debut de la liste chainee
*@param fd le file descriptor
*@param current le noeud actuel
*@param new_node le nouveau noeud
*@return
*$ que return la fonction
*/
t_gnl	*get_fd_node(t_gnl **head, int fd)
{
	t_gnl	*current;
	t_gnl	*new_node;

	current = *head;
	while (current)
	{
		if (current->fd == fd)
			return (current);
		current = current->next;
	}
	new_node = malloc(sizeof(t_gnl));
	if (!new_node)
		return (NULL);
	new_node->fd = fd;
	new_node->remainder = NULL;
	new_node->next = *head;
	*head = new_node;
	return (new_node);
}
/**
*@brief
** fonction principale
*@param fd le file descriptor
*@param buffer la chaine de caractere lu
*@param head le debut de la liste chainee
*@param node le noeud actuel
*@param line la ligne a retourner
*@return
*$ la ligne lu ou NULL si erreur ou fin de fichier donc rien a lire
*/
char	*get_next_line(int fd)
{
	char			*buffer;
	static t_gnl	*head = NULL;
	t_gnl			*node;
	char			*line;

	if (fd < 0 || BUFFER_SIZE <= 0)
		return (NULL);
	buffer = malloc(BUFFER_SIZE + 1);
	if (!buffer)
		return (NULL);
	node = get_fd_node(&head, fd);
	if (!node)
	{
		free(buffer);
		return (NULL);
	}
	line = read_and_extract_line(node, buffer);
	free(buffer);
	if (!line)
	{
		remove_fd_node(&head, fd);
		return (NULL);
	}
	return (line);
}
