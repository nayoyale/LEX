%{
    #include <stdio.h>
    #include <ctype.h>  
%}

%%

[A-Z]  { printf("%c", tolower(yytext[0])); }  //Podemos convierte mayúsculas a minúsculas con la palabra reservada tolower
.      { printf("%s", yytext); }  // Permite que los demas caracteres no sean modificados
%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}