%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();

#define MAX_VARS 100

typedef struct {
    char* nombre;
    int valor;
} variable;

variable tabla[MAX_VARS];
int total_vars = 0;

int buscar_variable(char* nombre) {
    int i;
    for (i = 0; i < total_vars; i++) {
        if (strcmp(tabla[i].nombre, nombre) == 0) return i;
    }
    return -1;
}

void asignar_valor(char* nombre, int valor) {
    int i = buscar_variable(nombre);
    if (i >= 0) {
        tabla[i].valor = valor;
    } else {
        tabla[total_vars].nombre = strdup(nombre);
        tabla[total_vars].valor = valor;
        total_vars++;
    }
}

int obtener_valor(char* nombre) {
    int i = buscar_variable(nombre);
    if (i >= 0) return tabla[i].valor;
    printf("Error: Variable no definida '%s'\n", nombre);
    exit(1);
}
%}

%union {
    int num;
    char* str;
}

%token PRENDER APAGAR FOCO INTENSO VERBA
%token CUANDOZ ENTONCESO LURPO ZORK
%token DECIR LEER
%token <num> NUM
%token <str> ID

%left '+' '-'
%left '*' '/'
%right UMINUS

%type <num> expr

%%

programa:
    programa instruccion
    | instruccion
    ;

instruccion:
      PRENDER FOCO ';'         { printf("Luz encendida.\n"); }
    | APAGAR FOCO ';'           { printf("Luz apagada.\n"); }
    | INTENSO expr ';'          { printf("Nivel de brillo: %d\n", $2); }
    | ID '=' expr ';'           { asignar_valor($1, $3); free($1); }
    | DECIR ID ';'              { printf("Valor de %s: %d\n", $2, obtener_valor($2)); free($2); }
    ;

expr:
      NUM                       { $$ = $1; }
    | ID                        { $$ = obtener_valor($1); free($1); }
    | expr '+' expr             { $$ = $1 + $3; }
    | expr '-' expr             { $$ = $1 - $3; }
    | expr '*' expr             { $$ = $1 * $3; }
    | expr '/' expr             {
                                   if ($3 == 0) {
                                       yyerror("Division entre cero");
                                       YYABORT;
                                   }
                                   $$ = $1 / $3;
                                }
    | '-' expr %prec UMINUS     { $$ = -$2; }
    | '(' expr ')'              { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    return yyparse();
}