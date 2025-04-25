%{
#include "y.tab.h"
#include <ctype.h>

// Declara yylval usando el tipo correcto
extern YYSTYPE yylval;
%}

%%

[ \t]   ;  /* Ignorar espacios */

[a-z]   { 
    yylval = yytext[0] - 'a'; 
    return LETTER; 
}

[0-9]   { 
    yylval = yytext[0] - '0'; 
    return DIGIT; 
}

\n      { return '\n'; }
.       { return yytext[0]; }

%%

int yywrap() { 
    return 1; 
}