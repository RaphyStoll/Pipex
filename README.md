# Pipex

<a href="https://github.com/RaphyStoll/Pipex/blob/main/README.md" style="text-decoration:none;">
  <button style="background-color:#e0f7fa; border:none; cursor:pointer;">
    🇫🇷 Français
  </button>
</a>
&nbsp;&nbsp;
<a href="https://github.com/RaphyStoll/Pipex/blob/main/README.eng.md" style="text-decoration:none;">
  <button style="border:none; cursor:pointer;">
    🇬🇧 English
  </button>
</a>

## Résumé

Ce projet consiste à implémenter un mécanisme UNIX de gestion de pipes en langage C. Il s'agit d'un
exercice de programmation qui permet de comprendre et de manipuler les pipes, les processus et les
redirections de fichiers sous UNIX.

## Table des matières

- [Pipex](#pipex)
  - [Résumé](#résumé)
  - [Table des matières](#table-des-matières)
  - [Préambule](#préambule)
  - [Règles communes](#règles-communes)
  - [Partie obligatoire](#partie-obligatoire)
    - [Exemples](#exemples)
  - [Partie bonus](#partie-bonus)
  - [Structure du projet](#structure-du-projet)
  - [Compilation](#compilation)
  - [Exécution](#exécution)

## Préambule

Ce projet est une exploration détaillée d'un mécanisme UNIX par la programmation.

## Règles communes

- Le projet doit être écrit en C.
- Le code doit suivre la norme de codage spécifiée a 42.
- Les fonctions ne doivent pas s'arrêter de manière inattendue.
- Toute mémoire allouée doit être libérée correctement.
- Un Makefile doit être fourni pour compiler le projet.

## Partie obligatoire

Le programme `pipex` doit être exécuté avec les arguments suivants :

```
./pipex file1 cmd1 cmd2 file2
```

- `file1` et `file2` sont des noms de fichiers.
- `cmd1` et `cmd2` sont des commandes shell avec leurs paramètres.

Le programme doit se comporter comme la commande shell suivante :

```
< file1 cmd1 | cmd2 > file2
```

### Exemples

1. `./pipex infile "ls -l" "wc -l" outfile`

   - Équivalent à : `< infile ls -l | wc -l > outfile`

2. `./pipex infile "grep ab" "wc -w" outfile`
   - Équivalent à : `< infile grep ab | wc -w > outfile`

## Partie bonus

Les bonus incluront la gestion de plusieurs pipes et la gestion de `here_doc`. Ces fonctionnalités
seront ajoutées ultérieurement a mon projet.

## Structure du projet

```
pipex/
│
├── include/
│   ├── main/
│   │   ├── colors.h
│   │   ├── fonction.h
│   │   └── struct.h
│
├── lib/
│   └── ft_printf/
│       ├── Makefile
│       ├── ft_printf.c
│       ├── ft_printf.h
│       ├── ft_printf_select1.c
│       ├── ft_printf_select2.c
│       └── ft_printf_utils.c
│
├── source/
│   ├── main/
│   │   ├── debbug.c
│   │   ├── free.c
│   │   ├── ft_split.c
│   │   ├── init.c
│   │   ├── lib.c
│   │   ├── main.c
│   │   ├── run_pipe.c
│   │   └── utils.c
│
├── Makefile
├── Pipex_test.sh
├── README.eng.md
└── README.md
```

## Compilation

Pour compiler le projet, utilisez la commande suivante :

```sh
make
```

## Exécution

Pour exécuter le programme, utilisez la commande suivante :

```
./pipex file1 cmd1 cmd2 file2
```

Remplacez file1, cmd1, cmd2, et file2 par les valeurs appropriées.
