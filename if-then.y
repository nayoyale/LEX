%{
#include <stdio.h>
#include <stdlib.h>


void yyerror(const char *s);


int valid_if_count = 0;

extern FILE *yyin;
void printFileContent(const char *filename); 
%}

%token IF LBRACE RBRACE LPAREN RPAREN ID COMMENT

%%

program : stmt { 
               if (valid_if_count == 0) {
                   printf("No se encontro ninguna estructura if-then valida.\n");
               } else {
                   printf("Se encontraron %d estructuras if-then validas.\n", valid_if_count);
               }
           }
        ;

stmt : IF LPAREN condition RPAREN block { 
                 valid_if_count++; 
                 printf("Estructura IF-THEN valida.\n"); 
             }
     ;

condition : ID { }
          ;

block : LBRACE statement RBRACE
      ;

statement : ID { }
          | COMMENT {  }
          ;

%%

void printFileContent(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        fprintf(stderr, "Error: No se pudo abrir el archivo '%s'.\n", filename);
        return;
    }

    printf("\nCodigo que se está analizando:\n---------------------------------\n");

    char c;
    while ((c = fgetc(file)) != EOF) {
        putchar(c);
    }

    printf("\n---------------------------------\n\n");
    fclose(file);
}


int main() {
    const char *filename = "codigo.txt";


    printFileContent(filename);

    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        fprintf(stderr, "Error: No se pudo abrir el archivo '%s'.\n", filename);
        exit(1);
    }

    yyin = file;

    printf("Iniciando analisis...\n");

    while (1) {
        yyparse();
        if (feof(yyin)) break;
    }

    fclose(file);

    return 0;
}

void yyerror(const char *s) {
    if (valid_if_count == 0) {
        fprintf(stderr, "Error de sintaxis: La estructura debe ser: if (condicion) { accion }\n");
    }
}
