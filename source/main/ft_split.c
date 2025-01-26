/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_split.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 19:13:28 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/25 22:40:29 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"

int	count_words(const char *s, char c)
{
	int	count;
	int	in_substring;
	int	i;

	count = 0;
	in_substring = 0;
	i = 0;
	while (s[i])
	{
		if (s[i] != c && in_substring == 0)
		{
			in_substring = 1;
			count++;
		}
		else if (s[i] == c)
			in_substring = 0;
		i++;
	}
	return (count);
}

char	*get_next_word(char const *s, char c, int *index)
{
	int	start;
	int	len;

	while (s[*index] && s[*index] == c)
		(*index)++;
	start = *index;
	while (s[*index] && s[*index] != c)
		(*index)++;
	len = *index - start;
	if (len <= 0)
		return  (NULL);
	return (ft_substr(s, start, len));
}

char	**allocate_and_fill(char const *s, char c)
{
	char	**split;
	int		count;
	int		index;
	int		i;
	char	*word;

	count = count_words(s, c);
	split = malloc((count + 1) * sizeof(char *));
	if (!split)
		return (NULL);
	index = 0;
	i = 0;
	while (i < count)
	{
		word = get_next_word(s, c, &index);
		if (!word)
		{
			free_array(split);
			return (NULL);
		}
		split[i] = word;
		i++;
	}
	split[count] = NULL;
	return (split);
}

char	**ft_split(char const *s, char c)
{
	if (!s)
		return (NULL);
	return (allocate_and_fill(s, c));
}