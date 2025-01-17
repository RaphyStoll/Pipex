/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line_utils.c                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/10 20:56:46 by raphaelferr       #+#    #+#             */
/*   Updated: 2024/10/11 00:45:36 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"

char	*ft_strdup_gnl(const char *s)
{
	char	*dup;
	size_t	len;
	size_t	i;

	if (!s)
		return (NULL);
	len = ft_strlen_gnl(s);
	dup = malloc(len + 1);
	if (!dup)
		return (NULL);
	i = 0;
	while (i < len)
	{
		dup[i] = s[i];
		i++;
	}
	dup[i] = '\0';
	return (dup);
}

char	*ft_strchr_gnl(const char *s, int c)
{
	if (!s)
		return (NULL);
	while (*s)
	{
		if (*s == c)
			return ((char *)s);
		s++;
	}
	if (c == '\0')
		return ((char *)s);
	return (NULL);
}

size_t	ft_strlen_gnl(const char *s)
{
	size_t	len;

	if (!s)
		return (0);
	len = 0;
	while (s[len])
		len++;
	return (len);
}

char	*ft_strjoin_gnl(char const *s1, char const *s2)
{
	char	*str;
	size_t	i;
	size_t	len1;
	size_t	len2;

	len1 = 0;
	len2 = 0;
	if (s1)
		len1 = ft_strlen_gnl(s1);
	if (s2)
		len2 = ft_strlen_gnl(s2);
	str = malloc(len1 + len2 + 1);
	if (!str)
		return (NULL);
	i = 0;
	while (s1 && *s1)
		str[i++] = *s1++;
	while (s2 && *s2)
		str[i++] = *s2++;
	str[i] = '\0';
	return (str);
}

char	*ft_substr_gnl(char const *s, unsigned int start, size_t len)
{
	char	*substr;
	size_t	s_len;
	size_t	copy_len;
	size_t	i;

	if (!s)
		return (NULL);
	s_len = ft_strlen_gnl(s);
	if (start >= s_len)
		return (ft_strdup_gnl(""));
	if (len > s_len - start)
		copy_len = s_len - start;
	else
		copy_len = len;
	substr = malloc(copy_len + 1);
	if (!substr)
		return (NULL);
	i = 0;
	while (i < copy_len)
	{
		substr[i] = s[start + i];
		i++;
	}
	substr[i] = '\0';
	return (substr);
}
