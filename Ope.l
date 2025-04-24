%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include <math.h>

void yyerror(const char *);
extern YYSTYPE yylval;

void imprimir_info_token(const char *texto, const char *tipo) {
    printf("Token: %s (%s) - Valido\n", texto, tipo);
}
%}

%option noyywrap

DIGITO    [0-9]
ENTERO    {DIGITO}+
FLOTANTE  {DIGITO}+"."{DIGITO}*
ESPACIO   [ \t]
ID        [a-zA-Z][a-zA-Z0-9]*

%%

\n        { return NUEVALINEA; }
{ENTERO}|{FLOTANTE}  { 
                    yylval.dval = atof(yytext); 
                    imprimir_info_token(yytext, "numero");
                    return NUMERO; 
                   }

"sin"     { imprimir_info_token("sin", "funcion seno"); return SEN; }
"cos"     { imprimir_info_token("cos", "funcion coseno"); return COS; }
"tan"     { imprimir_info_token("tan", "funcion tangente"); return TAN; }
"log"     { imprimir_info_token("log", "funcion logaritmo"); return LOG; }
"sqrt"    { imprimir_info_token("sqrt", "funcion raiz cuadrada"); return SQRT; }
"exp"     { imprimir_info_token("exp", "funcion exponencial"); return EXP; }

"+"       { imprimir_info_token("+", "operador suma"); return MAS; }
"-"       { imprimir_info_token("-", "operador resta"); return MENOS; }
"*"       { imprimir_info_token("*", "operador multiplicacion"); return POR; }
"/"       { imprimir_info_token("/", "operador division"); return DIV; }
"%"       { imprimir_info_token("%", "operador modulo"); return MOD; }
"^"       { imprimir_info_token("^", "operador potencia"); return POT; }
"("       { imprimir_info_token("(", "parentesis izquierdo"); return PARIZQ; }
")"       { imprimir_info_token(")", "parentesis derecho"); return PARDER; }
","       { imprimir_info_token(",", "separador argumentos"); return COMA; }

{ESPACIO} { /* ignorar espacios */ }
{ID}      { printf("Funcion no valida: '%s'\n", yytext); yyerror("Funcion desconocida"); }

%%