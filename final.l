%{
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

prender       { return PRENDER; }
apagar        { return APAGAR; }
foco          { return FOCO; }
intenso       { return INTENSO; }
verba         { return VERBA; }
cuandoz       { return CUANDOZ; }
entonceso     { return ENTONCESO; }
lurpo         { return LURPO; }
zork          { return ZORK; }
decir         { return DECIR; }
leer          { return LEER; }

[0-9]+        { yylval.num = atoi(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }

"="           { return '='; }
";"           { return ';'; }
"("           { return '('; }
")"           { return ')'; }
"*"           { return '*'; }
"/"           { return '/'; }
"+"           { return '+'; }
"-"           { return '-'; }

[ \t\n]       ; // Ignora espacios
.             { return *yytext; }

%%

int yywrap() {
    return 1;
}