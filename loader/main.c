// loader/main.c --- Emacs wrapper for shebang
// Licensed under the AGPL v3 or later
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc < 2) return EXIT_FAILURE;

    execlp("emacs", "-Q", "--script", argv[1], NULL);

    perror("error");

    puts("");
    printf("File-Name: %s\n", argv[1]);
    char buf[256];
    getcwd(buf, 256);
    printf("Working-Directory: %s\n", buf);

    return EXIT_FAILURE;
}
