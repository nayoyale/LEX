/* Generar el programa de lex para reconocer los siguientes tokens: */
/* 1. Palabras que contienen cadena ae, ai, ao, au, (Sumatoria) = {a-z} */
/* 2. Palabras formadas con simbolos (Sumatoria) = {0, 1} que inicien o terminen con 00 */
/* 3. Los números enteros y decimales sin signo */
/* 4. 5 palabras reservadas de Java (a eleccion personal) */
/* 5. Palabras que inicien con mayuscula (Nombres propios) */

%option noyywrap
%{
	#include<stdio.h>
%}

LETRA [A-Za-z]*(ae|ai|ao|au)[A-Za-z]*
DOBLECERO (00[01]*|[01]*00)
SINSIGNO [0-9](\.[0-9]+)?
RESERVADA "return"|"while"|"else"|"goto"|"double"
MAYUSCULA [A-Z][a-z]*

%%

{LETRA}		printf("Palabras que contengan ae, ai, ao, au: %s\n", yytext);
{DOBLECERO}	printf("Numeros que inicien o terminen con 00: %s\n", yytext);
{SINSIGNO}	printf("Numeros y decimales sin signo: %s\n", yytext);
{RESERVADA}	printf("5 palabras de Java: %s\n", yytext);
{MAYUSCULA}	printf("Palabras con mayuscula: %s\n", yytext);

%%
int main()
{
	
	yylex();
	return 0;
}