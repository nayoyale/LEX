%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int potter = 0; // Contador de "Potter"
int poter = 0;  // Contador de "Poter" corregidos

FILE *salida;

char cad1[] = "Potter";  // Palabra corregida
char cad2[] = "Poter";   // Palabra incorrecta

extern FILE *yyin;

%}

%%

[a-zA-Z]+ {
    if (strcmp(yytext, cad2) == 0) {
        fprintf(salida, "%s ", cad1); // Sustituye "Poter" por "Potter"
        poter++;
    } else {
        fprintf(salida, "%s ", yytext);
        potter++;
    }
}

. { 
    fprintf(salida, "%s", yytext); // Imprime el resto del texto sin cambios
}

%%

int main() {
    // Abrir archivo de entrada
    yyin = fopen("error.txt", "r");
    if (!yyin) {
        printf("Error al abrir el archivo de entrada.\n");
        return 1;
    }
    salida = fopen("Harry_Espanol_Corregido.txt", "w");
    if (!salida) {
        printf("Error al abrir el archivo de salida.\n");
        fclose(yyin);
        return 1;
    }
    yylex();

    printf("\nCantidad de veces repetidas por cada nombre\n");
    printf("Potter: %d veces.\n", potter);
    printf("Poter (corregido): %d veces.\n", poter);
    printf("\nCorrección finalizada. Revisa 'Harry_Espanol_Corregido.txt'.\n");

    fclose(yyin);
    fclose(salida);

    return 0;
}