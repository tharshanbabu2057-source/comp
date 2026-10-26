#include <stdio.h>
#include <string.h>

int main() {
    int n, i;
    char line[100];
    char a[20], op[5], b[20], c[20];

    printf("Enter number of statements: ");
    scanf("%d", &n);
    getchar();

    for (i = 0; i < n; i++) {
        fgets(line, sizeof(line), stdin);
        line[strcspn(line, "\n")] = '\0';

        if (strchr(line, ':')) {
            printf("%s\n", line);
        }
        else if (sscanf(line, "goto %s", a) == 1) {
            printf("JMP %s\n", a);
        }
        else if (sscanf(line, "if %s %s %s goto %s",
                        a, op, b, c) == 4) {
            printf("CMP %s, %s\n", a, b);

            if (strcmp(op, "<") == 0)
                printf("JLT %s\n", c);
            else if (strcmp(op, ">") == 0)
                printf("JGT %s\n", c);
            else if (strcmp(op, "<=") == 0)
                printf("JLE %s\n", c);
            else if (strcmp(op, ">=") == 0)
                printf("JGE %s\n", c);
            else if (strcmp(op, "==") == 0)
                printf("JE %s\n", c);
            else if (strcmp(op, "!=") == 0)
                printf("JNE %s\n", c);
        }
        else if (sscanf(line, "%s = %s %s %s",
                        a, b, op, c) == 4) {
            printf("MOV R0, %s\n", b);

            if (strcmp(op, "+") == 0)
                printf("ADD R0, %s\n", c);
            else if (strcmp(op, "-") == 0)
                printf("SUB R0, %s\n", c);
            else if (strcmp(op, "*") == 0)
                printf("MUL R0, %s\n", c);
            else if (strcmp(op, "/") == 0)
                printf("DIV R0, %s\n", c);

            printf("MOV %s, R0\n", a);
        }
        else if (sscanf(line, "%s = %s", a, b) == 2) {
            printf("MOV R0, %s\n", b);
            printf("MOV %s, R0\n", a);
        }
      
    }

    return 0;
}