/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_split.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: raphaelferreira <raphaelferreira@studen    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/25 19:13:28 by raphaelferr       #+#    #+#             */
/*   Updated: 2025/01/25 20:43:18 by raphaelferr      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/main/fonction.h"


static int	count_words(const char *str, char c)
{
   int	count;
   int	i;

   count = 0;
   i = 0;
   while (str[i])
   {
   	if (str[i] != c && (i == 0 || str[i - 1] == c))
   		count++;
   	i++;
   }
   return (count);
}

static void	get_word(t_split *sp, const char *str, char c, int i)
{
   sp->start = i;
   while (str[i] && str[i] != c)
   	i++;
   sp->len = i - sp->start;
   sp->words[sp->word_count] = ft_substr(str, sp->start, sp->len);
   if (!sp->words[sp->word_count])
   {
   	while (sp->word_count > 0)
   		free(sp->words[--sp->word_count]);
   	free(sp->words);
   	sp->words = NULL;
   }
   sp->word_count++;
}

char	**ft_split(char const *str, char c)
{
   t_split	sp;
   int		i;

   if (!str)
   	return (NULL);
   sp.words = malloc(sizeof(char *) * (count_words(str, c) + 1));
   if (!sp.words)
   	return (NULL);
   sp.word_count = 0;
   i = 0;
   while (str[i])
   {
   	if (str[i] != c && (i == 0 || str[i - 1] == c))
   		get_word(&sp, str, c, i);
   	if (!sp.words)
   		return (NULL);
   	i++;
   }
   sp.words[sp.word_count] = NULL;
   return (sp.words);
}

