%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

void yyerror(const char *);
int yylex(void);

extern int yyparse();
extern FILE *yyin;

void imprimir_operacion(const char *op, double a, double b, double resultado) {
    printf("Operacion: %g %s %g = %g\n", a, op, b, resultado);
}

void imprimir_funcion(const char *fn, double a, double resultado) {
    printf("Funcion: %s(%g) = %g\n", fn, a, resultado);
}
%}

%union {
    double dval;
}

%token <dval> NUMERO
%token MAS MENOS POR DIV MOD POT
%token PARIZQ PARDER COMA NUEVALINEA
%token SEN COS TAN LOG SQRT EXP

%type <dval> expresion termino factor exponente atomo llamada_funcion

%left MAS MENOS
%left POR DIV MOD
%right POT
%left UNARIO
%left PARIZQ PARDER

%%

entrada:    /* vacio */
        | entrada linea
        ;

linea:     NUEVALINEA
        | expresion NUEVALINEA { 
            printf("\n>>> Resultado: %g\n", $1); 
            printf(">>> Expresion VALIDA\n\n");
            return 0;
          }
        | error NUEVALINEA { 
            printf("\n>>> Expresion INVALIDA\n\n");
            yyerrok; 
            return 0;
          }
        ;

expresion: termino
          | expresion MAS termino  { $$ = $1 + $3; imprimir_operacion("+", $1, $3, $$); }
          | expresion MENOS termino { $$ = $1 - $3; imprimir_operacion("-", $1, $3, $$); }
          ;

termino:      factor
          | termino POR factor   { $$ = $1 * $3; imprimir_operacion("*", $1, $3, $$); }
          | termino DIV factor { 
              if ($3 == 0) yyerror("division por cero");
              $$ = $1 / $3; 
              imprimir_operacion("/", $1, $3, $$); 
            }
          | termino MOD factor    { 
              if ($3 == 0) yyerror("modulo por cero");
              $$ = fmod($1, $3); 
              imprimir_operacion("%", $1, $3, $$); 
            }
          ;

factor:    exponente
          | MAS factor  %prec UNARIO { $$ = $2; }
          | MENOS factor %prec UNARIO { $$ = -$2; printf("Menos unario: -%g\n", $2); }
          | llamada_funcion
          ;

exponente:  atomo
          | atomo POT exponente { $$ = pow($1, $3); imprimir_operacion("^", $1, $3, $$); }
          ;

atomo:      NUMERO
          | PARIZQ expresion PARDER { $$ = $2; printf("Parentesis: (%g)\n", $$); }
          ;

llamada_funcion:    SEN PARIZQ expresion PARDER { $$ = sin($3); imprimir_funcion("sen", $3, $$); }
          | COS PARIZQ expresion PARDER { $$ = cos($3); imprimir_funcion("cos", $3, $$); }
          | TAN PARIZQ expresion PARDER { $$ = tan($3); imprimir_funcion("tan", $3, $$); }
          | LOG PARIZQ expresion PARDER { 
              if ($3 <= 0) yyerror("log de numero no positivo");
              $$ = log($3); 
              imprimir_funcion("log", $3, $$); 
            }
          | SQRT PARIZQ expresion PARDER { 
              if ($3 < 0) yyerror("raiz de numero negativo");
              $$ = sqrt($3); 
              imprimir_funcion("sqrt", $3, $$); 
            }
          | EXP PARIZQ expresion PARDER { $$ = exp($3); imprimir_funcion("exp", $3, $$); }
          ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("\nCalculadora Avanzada\n");
    printf("Operaciones: + - * / %% ^ ()\n");
    printf("Funciones: sen, cos, tan, log, sqrt, exp\n");
    printf("Ingrese expresiones (Enter para calcular):\n\n");
    
    yyin = stdin;
    int resultado;
    
    do {
        printf("> ");
        fflush(stdout);
        resultado = yyparse();
    } while (!feof(yyin) && resultado == 0);
    
    return 0;
}