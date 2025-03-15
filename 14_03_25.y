%{

#include<stdio.h>

int yylex(void);

int yywrap();

int yyerror(char* s);

%}
%start program



%union { int inum; }



/* parte 1: definir tipostoken */

%token NUMERO OPERADOR



/* ---- parte 2: reglas gramaticales ---- */



%%



/* program rule(s) */



program:
	program expression
	| expression
	;
expression:
	NUMERO OPERADOR NUMERO

    {

        printf("Se procesa la entrada \"OPERACION\" y es correcta de acuerdo con las reglas.\n");

    }

    ;



/* ---- parte 3: Programa ---- */



%%



/* begin parsing */

int main() {

   printf("beginning\n");

   int res = yyparse();

   printf("ending, %d\n", res);

   return(res);

}

