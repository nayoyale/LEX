%option noyywrap

%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
%}

%%

"if"      { return IF; }
"{"       { return LBRACE; }
"}"       { return RBRACE; }
"("       { return LPAREN; }
")"       { return RPAREN; }
"exit"    { exit(0); } 
"//".*    { return COMMENT; }
[a-zA-Z_][a-zA-Z0-9_]* { return ID; } 
[ \t\n]   {  }
.         { return yytext[0]; }  
%%