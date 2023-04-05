#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Password can be no longer than 21 characters.
#define PASSWORD "password123"





void crypt(char *givenFileName, signed int type)
{
    char c;
    char nc;
    long MIN;
    long MAX;
    char *oldContents;
    long oldFileSize;
    FILE *old = fopen(givenFileName, "r");
    FILE *new = fopen("bastet_new", "w");

    if (old == NULL) {
        printf("File could not be read.");
        exit(1);
    }
    if (new == NULL) {
        printf("New file could not be created.");
        exit(1);
    }

    // Get old file size.
    fseek(old, 0, SEEK_END);
    oldFileSize = ftell(old);
    rewind(old);

    // Allocate memory for buffer oldContents.
    oldContents = (char*) malloc((sizeof(char) * oldFileSize) + 1);
    if (oldContents == NULL) {
        printf("Error allocating memory.");
        exit(1);
    }

    // Write old file contents into buffer.
    fread(oldContents, sizeof(char), oldFileSize, old);
    oldContents[oldFileSize + 1] = '\0';
    fclose(old);

    // Copy data.
    for (int i = 0; (c = oldContents[i]) != '\0'; i++) {
        nc = c + (64303 * type);
        fputc(nc, new);
    }

    fclose(new);
    remove(givenFileName);
    rename("bastet_new", givenFileName);

}


int main(int argc, char **argv)
{
    char id = argv[1][0];
    char pass[20];
    printf("Enter password: ");
    scanf("%s", &pass);

    if (strcmp(pass, PASSWORD) == 0) {
        switch(id) {
            case 'e':
                crypt(argv[2], 1);
                break;
            case 'd':
                crypt(argv[2], -1);
                break;
            default:
                printf("Invalid argument: %c", id);
                break;
        }
    } else {
        printf("Incorrect password.");
        exit(1);
    }

    return 0;
}