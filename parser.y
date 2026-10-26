
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

int temp = 0;
int label = 0;

char *newtemp(void)
{
    char buf[20];
    sprintf(buf, "t%d", temp++);
    return strdup(buf);
}
%}

%union {
    char *str;
}

%token WHILE IF ASSIGN MINUS LP RP LB RB SEMI ADD MUL DIV INVALID
%token <str> ID NUM RELOP
%type <str> exp term factor

%left ADD MINUS
%left MUL DIV

%%

program
    : statements
    ;

statements
    : statement
    | statements statement
    ;

statement
    : ID ASSIGN exp SEMI
      {
          printf("%s = %s\n", $1, $3);
      }
    | WHILE LP loop_start exp RELOP exp RP
      {
          printf("ifFalse %s %s %s goto L%d\n",
                 $4, $5, $6, label + 1);
      }
      LB statements RB
      {
          printf("goto L%d\n", label);
          printf("L%d:\n", label + 1);
          label += 2;
      }
    | IF LP exp RELOP exp RP
      {
          printf("ifFalse %s %s %s goto L%d\n",
                 $3, $4, $5, label + 1);
      }
      LB statements RB
      {
          printf("L%d:\n", label + 1);
          label += 2;
      }
    ;

loop_start
    :
      {
          printf("L%d:\n", label);
      }
    ;

exp
    : exp ADD term
      {
          char *t = newtemp();
          printf("%s = %s + %s\n", t, $1, $3);
          $$ = t;
      }
    | exp MINUS term
      {
          char *t = newtemp();
          printf("%s = %s - %s\n", t, $1, $3);
          $$ = t;
      }
    | term
      {
          $$ = $1;
      }
    ;

term
    : term MUL factor
      {
          char *t = newtemp();
          printf("%s = %s * %s\n", t, $1, $3);
          $$ = t;
      }
    | term DIV factor
      {
          char *t = newtemp();
          printf("%s = %s / %s\n", t, $1, $3);
          $$ = t;
      }
    | factor
      {
          $$ = $1;
      }
    ;

factor
    : ID
      {
          $$ = $1;
      }
    | NUM
      {
          $$ = $1;
      }
    | LP exp RP
      {
          $$ = $2;
      }
    ;

%%

void yyerror(const char *s)
{
    fprintf(stderr, "Syntax is invalid: %s\n", s);
}

int main(void)
{
    printf("Enter source program (Ctrl+D to finish):\n");

    if (yyparse() == 0)
        printf("Syntax is valid\n");

    return 0;
}
