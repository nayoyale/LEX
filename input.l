%{
#include "y.tab.h"
#include <ctype.h>
%}

%%

[ \t]    ; /* Ignorar espacios */
[A-Z]    { yylval.ival = yytext[0] - 'A'; return VREG; }
[a-z]    { yylval.ival = yytext[0] - 'a'; return DREG; }
[0-9]+(\.[0-9]*)?([eE][-+]?[0-9]+)? {
    yylval.dval = atof(yytext);
    return CONST;
}
\n       { return '\n'; }
.        { return yytext[0]; }

%%

int yywrap(void) {
    return 1;
}