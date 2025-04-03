%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
INSERT              { return INSERT; }
INTO                { return INTO; }
VALUES              { return VALUES; }
[a-zA-Z_][a-zA-Z0-9_]*  { return IDENTIFIER; }
\"[^\"]+\"          { return STRING; }
[0-9]+              { return NUMBER; }
\(                  { return LPAREN; }
\)                  { return RPAREN; }
,                   { return COMMA; }
;                   { return SEMICOLON; }
[ \t\n]             ; /* Ignorar espacios en blanco */
.                   { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
