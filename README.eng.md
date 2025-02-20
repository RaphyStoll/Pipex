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

## Summary

This project involves implementing a UNIX mechanism for handling pipes in the C programming
language. It is a programming exercise that helps understand and manipulate pipes, processes, and
file redirections in UNIX.

## Table of Contents

- [Pipex](#pipex)
	- [Summary](#summary)
	- [Table of Contents](#table-of-contents)
	- [Preface](#preface)
	- [Common Rules](#common-rules)
	- [Mandatory Part](#mandatory-part)
		- [Examples](#examples)
	- [Bonus Part](#bonus-part)
	- [Submission and Peer Evaluation](#submission-and-peer-evaluation)
	- [Project Structure](#project-structure)
	- [Compilation](#compilation)
	- [Execution](#execution)

## Preface

This project is a detailed exploration of a UNIX mechanism through programming.

## Common Rules

- The project must be written in C.
- The code must follow the specified coding norm.
- Functions should not terminate unexpectedly.
- All allocated memory must be properly freed.
- A Makefile must be provided to compile the project.

## Mandatory Part

The `pipex` program should be executed with the following arguments:

```bash
./pipex file1 cmd1 cmd2 file2
```

- `file1` and `file2` are file names.
- `cmd1` and `cmd2` are shell commands with their parameters.

The program should behave like the following shell command:

```bash
< file1 cmd1 | cmd2 > file2
```

### Examples

1. `./pipex infile "ls -l" "wc -l" outfile`

   - Equivalent to: `< infile ls -l | wc -l > outfile`

2. `./pipex infile "grep ab" "wc -w" outfile`
   - Equivalent to: `< infile grep ab | wc -w > outfile`

## Bonus Part

Bonus features will include handling multiple pipes and `here_doc`. These features will be added
later.

## Submission and Peer Evaluation

Work must be submitted to the assigned Git repository. Only work present in the repository will be
evaluated.

## Project Structure

```
pipex/
│
├── include/
│   └── main/
│       ├── colors.h
│       ├── fonction.h
│       └── struct.h
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
│   └── main/
│       ├── debbug.c
│       ├── free.c
│       ├── ft_split.c
│       ├── init.c
│       ├── lib.c
│       ├── main.c
│       ├── run_pipe.c
│       └── utils.c
│
├── Makefile
├── Pipex_test.sh
├── README.eng.md
└── README.md
```

## Compilation

To compile the project, use the following command:

```sh
make
```

## Execution

To run the program, use the following command:

```
./pipex file1 cmd1 cmd2 file2
```

Replace file1, cmd1, cmd2, and file2 with the appropriate values.
