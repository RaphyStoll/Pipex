#include "../../include/main/fonction.h"

void run_pipe(t_data *data)
{
	int	pid1;
	int	pid2;


	pid1 = fork();
	if (pid1 == -1)
		 ft_exit_error(data, "Fork failed", ERROR_GENERAL);
	if (pid1 == 0)
		child1(data);
	pid2 = fork();
	if (pid2 == -1)
		ft_exit_error(data, "Fork failed", ERROR_GENERAL);
	if (pid2 == 0)
		child2(data);

	close(data->fd_pipe[0]);
	close(data->fd_pipe[1]);
	waitpid(pid1, &data->status, 0);
	waitpid(pid2, &data->status2, 0);
	if (WIFEXITED(data->status2))
	{
    	data->exit_status2 = WEXITSTATUS(data->status2);
        	data->error_code = data->exit_status2;
	}
}

void child1(t_data *data)
{

	if (access(data->file1, F_OK) == -1)
		ft_exit_error(data, "File not found", ERROR_CMD_NOT_FOUND);
	if (access(data->file1, R_OK) == -1)
		ft_exit_error(data, "File not readable", ERROR_PERMISSION);
	data->fd_input = open(data->file1, O_RDONLY);
	if (data->fd_input == -1)
		ft_exit_error(data, "Open failed", ERROR_GENERAL);
	close(data->fd_pipe[0]);
	close(data->fd_output);
	if (dup2(data->fd_input, STDIN_FILENO) == -1)
		ft_exit_error(data, "child1 : Dup2 stdin failed", ERROR_GENERAL);
	//printf("hello1\n");  //$
	if (dup2(data->fd_pipe[1], STDOUT_FILENO) == -1)
		ft_exit_error(data, "child1 : Dup2 stdout failed", ERROR_GENERAL);
	//printf("hello2\n");  //$
	close(data->fd_input);
	close(data->fd_pipe[1]);
	data->cmd_path = get_cmd_path(data, data->cmd1[0]);
	printf("cmd_path: %s\n", data->cmd_path);
	if (!data->cmd_path)
		ft_exit_error(data, "Command not found", ERROR_CMD_NOT_FOUND);
	printf("This is the child process. (pid: %d)\n", getpid()); //$
	if (execve(data->cmd_path, data->cmd1, NULL) == -1)
		ft_exit_error(data, "Execve failed", ERROR_GENERAL);
}

void child2(t_data *data)
{
	data->fd_output = open(data->file2, O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (data->fd_output == -1)
		ft_exit_error(data, "Open output failed", ERROR_GENERAL);
	close(data->fd_pipe[1]);
	close(data->fd_input);
	if (dup2(data->fd_pipe[0], STDIN_FILENO) == -1)
		ft_exit_error(data, "child2 : Dup2 stdin failed", ERROR_GENERAL);
	if (dup2(data->fd_output, STDOUT_FILENO) == -1)
		ft_exit_error(data, "child2 : Dup2 stdout failed", ERROR_GENERAL);
	close(data->fd_output);
	close(data->fd_pipe[0]);
	data->cmd_path2 = get_cmd_path(data, data->cmd2[0]);
	printf("cmd_path2: %s\n", data->cmd_path2);
	if (!data->cmd_path2)
		ft_exit_error(data, "Command not found", ERROR_CMD_NOT_FOUND);

	printf("This is the child process. (pid: %d)\n", getpid()); //$
	if (execve(data->cmd_path2, data->cmd2, NULL) == -1)
		ft_exit_error(data, "Execve failed", ERROR_GENERAL);
}