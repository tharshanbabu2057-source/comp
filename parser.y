
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

int newlabel(void)
{
    return label++;
}
%}

%union {
    char *str;
    int num;
}

%token WHILE IF ELSE ASSIGN MINUS LP RP LB RB SEMI ADD MUL DIV INVALID
%token <str> ID NUM RELOP
%type <str> exp term factor
%type <num> loop_start if_begin if_else

%left ADD MINUS
%left MUL DIV

%%

program
    : statements
      {
          printf("Syntax is valid\n");
      }
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
                 $4, $5, $6, $3 + 1);
      }
      LB statements RB
      {
          printf("goto L%d\n", $3);
          printf("L%d:\n", $3 + 1);
      }
    | IF LP exp RELOP exp RP if_begin LB statements RB
      {
          printf("goto L%d\n", $7 + 1);
          printf("L%d:\n", $7);
      }
      ELSE LB statements RB
      {
          printf("L%d:\n", $7 + 1);
      }
    | IF LP exp RELOP exp RP if_else LB statements RB
      {
          printf("L%d:\n", $7);
      }
    ;

loop_start
    :
      {
          $$ = newlabel();
          printf("L%d:\n", $$);
      }
    ;

if_begin
    :
      {
          $$ = newlabel();
      }
    ;

if_else
    :
      {
          $$ = newlabel();
          printf("ifFalse condition goto L%d\n", $$);
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
    | term { $$ = $1; }
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
    | factor { $$ = $1; }
    ;

factor
    : ID       { $$ = $1; }
    | NUM      { $$ = $1; }
    | LP exp RP { $$ = $2; }
    ;

%%

void yyerror(const char *s)
{
    fprintf(stderr, "Syntax is invalid: %s\n", s);
}

int main(void)
{
    printf("Enter source program (Ctrl+D to finish):\n");
    yyparse();
    return 0;
}
