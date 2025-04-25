%{
#include <stdio.h>
#include <ctype.h>

int regs[26];
int base;

// Define YYSTYPE y yylval correctamente
#define YYSTYPE int
extern YYSTYPE yylval;
%}

%token DIGIT LETTER

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS

%%

list: /* vacío */
    | list stat '\n'
    | list error '\n' { yyerrok; }
    ;

stat: expr          { printf("%d\n", $1); }
    | LETTER '=' expr { regs[$1] = $3; }
    ;

expr: '(' expr ')'  { $$ = $2; }
    | expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { $$ = $1 / $3; }
    | expr '%' expr { $$ = $1 % $3; }
    | expr '&' expr { $$ = $1 & $3; }
    | expr '|' expr { $$ = $1 | $3; }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | LETTER        { $$ = regs[$1]; }
    | number
    ;

number: DIGIT       { $$ = $1; base = ($1 == 0) ? 8 : 10; }
      | number DIGIT { $$ = base * $1 + $2; }
      ;

%%

int main() {
    return yyparse();
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}