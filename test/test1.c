#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

void print_process_info(const char *type)
{
    printf("%s PID: %d, Parent PID: %d\n", 
           type, getpid(), getppid());
}

int main()
{
    int pipe1[2];  // Pipe pour communication
    int value = 5;
    
    print_process_info("Parent");
	printf("\n");
    // Crée le pipe
    if (pipe(pipe1) == -1)
    {
        perror("pipe");
        exit(1);
    }

    pid_t child1 = fork();
    if (child1 == 0)  // Premier enfant
    {
        print_process_info("Enfant 1");
        
        value *= 2;  // Modifie la valeur
        printf("Enfant 1: value = %d\n", value);
		printf("\n");
        
        write(pipe1[1], &value, sizeof(int));
        close(pipe1[1]);
        exit(0);
    }
    pid_t child2 = fork();
    if (child2 == 0)  // Deuxième enfant
    {
        print_process_info("Enfant 2");
        
        int received_value;
        read(pipe1[0], &received_value, sizeof(int));
        printf("Enfant 2: Reçu value = %d\n", received_value);
        
        close(pipe1[0]);
        exit(0);
    }

    close(pipe1[0]);
    close(pipe1[1]);
    
    // Attend les enfants
    waitpid(child1, NULL, 0);
    waitpid(child2, NULL, 0);

    printf("Parent: value finale = %d\n", value);
    return 0;
}