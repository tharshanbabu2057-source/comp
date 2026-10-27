
%{
#include "y.tab.h"
%}

%option noyywrap

%%
"while"             { return WHILE; }
"if"                { return IF; }
"else"   { return ELSE; }

"="                 { return ASSIGN; }
"+"                 { return ADD; }
"-"                 { return MINUS; }
"*"                 { return MUL; }
"/"                 { return DIV; }

"<="|">="|"=="|"!="|"<"|">" {
    yylval.str = strdup(yytext);
    return RELOP;
}

"("                 { return LP; }
")"                 { return RP; }
"{"                 { return LB; }
"}"                 { return RB; }
";"                 { return SEMI; }

[0-9]+              {
                        yylval.str = strdup(yytext);
                        return NUM;
                    }

[a-zA-Z_][a-zA-Z0-9_]* {
                        yylval.str = strdup(yytext);
                        return ID;
                    }

"//".*              ;
[ \t\r\n]+          ;

.                   { printf("Invalid character: %s\n", yytext); }
%%
