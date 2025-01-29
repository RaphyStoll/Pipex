#include "../../include/main/fonction.h"

void run_pipe(t_data *data)
{
	int	pid1;
	int	pid2;
	int	status;

	//print_struct(data);
	pid1 = fork();
	if (pid1 == -1)
		 ft_exit_error(data, "Fork failed");
	if (pid1 == 0)
		child1(data);
	pid2 = fork();
	if (pid2 == -1)
		ft_exit_error(data, "Fork failed");
	if (pid2 == 0)
		child2(data);
	waitpid(pid1, &status, 0);
	waitpid(pid2, &status, 0);
}

void child1(t_data *data)
{
	if (access(&data->file1[0], F_OK) == -1)
		ft_exit_error(data, "File not found or is a directory");
	if (access(&data->file1[0], R_OK) == -1)
		ft_exit_error(data, "File not readable");
	data->fd_input = open(data->file1, O_RDONLY);
	if (data->fd_input == -1)
		ft_exit_error(data, "Open failed");
	close(data->fd_pipe[0]);
	close(data->fd_output);
	if (dup2(data->fd_input, STDIN_FILENO) == -1)
		ft_exit_error(data, "child1 : Dup2 stdin failed");
	if (dup2(data->fd_pipe[1], STDOUT_FILENO) == -1)
		ft_exit_error(data, "child1 : Dup2 stdout failed");
	close(data->fd_input);
	close(data->fd_pipe[1]);
	data->cmd_path = get_cmd_path(data, data->cmd1[0]);
	if (!data->cmd_path)
		ft_exit_error(data, "Command not found");
	//printf("This is the child process. (pid: %d)\n", getpid());
	if (execve(data->cmd_path, data->cmd1, NULL) == -1)
		ft_exit_error(data, "Execve failed");
}

void child2(t_data *data)
{
	if (access(&data->file2[0], F_OK) == -1)
		ft_exit_error(data, "File not found or is a directory");
	if (access(&data->file2[0], R_OK) == -1)
		ft_exit_error(data, "File not readable");
	if (!data->cmd_path2)
		ft_exit_error(data, "Command not found");
	data->fd_output = open(data->file2, O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (data->fd_output == -1)
		ft_exit_error(data, "Open failed");
	close(data->fd_pipe[1]);
	close(data->fd_input);
	if (dup2(data->fd_pipe[0], STDIN_FILENO) == -1)
		ft_exit_error(data, "child2 : Dup2 stdin failed");
	if (dup2(data->fd_output, STDOUT_FILENO) == -1)
		ft_exit_error(data, "child2 : Dup2 stdout failed");
	close(data->fd_output);
	close(data->fd_pipe[0]);
	data->cmd_path = get_cmd_path(data, data->cmd2[0]);
	if (!data->cmd_path)
		ft_exit_error(data, "Command not found");
	//printf("This is the child process. (pid: %d)\n", getpid());
	if (execve(data->cmd_path2, data->cmd2, NULL) == -1)
		ft_exit_error(data, "Execve failed");
}