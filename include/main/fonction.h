#ifndef FONCTION_H
#define FONCTION_H

#include "colors.h"
#include "macro.h"
#include "../../ft_printf/ft_printf.h"
#include "../../gnl/get_next_line.h"
#include <unistd.h>

//!int main
int main(int argc, char **argv);

//! utils
void arg_verif(int argc, char **argv);
void ft_exit_error(char *message);

#endif