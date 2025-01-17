#ifndef FONCTION_H
#define FONCTION_H

#include "colors.h"
#include "macro.h"
#include "../../ft_printf/ft_printf.h"
#include "../../gnl/get_next_line.h"

//!int main
int main(int argc, char **argv);

//! utils
int arg_verif(int argc, char **argv);
void ft_exit_error(char *color, char *message);

#endif