%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

/* Definición completa del tipo INTERVAL */
typedef struct {
    double lo;
    double hi;
} INTERVAL;

/* Variables globales */
double dreg[26];
INTERVAL vreg[26];

/* Prototipos EXPLÍCITOS de funciones */
INTERVAL vadd(INTERVAL a, INTERVAL b);
INTERVAL vsub(INTERVAL a, INTERVAL b);
INTERVAL vmul_scalar(double a, INTERVAL b);
INTERVAL vmul_interval(INTERVAL a, INTERVAL b);
INTERVAL vdiv_scalar(double a, INTERVAL b);
INTERVAL vdiv_interval(INTERVAL a, INTERVAL b);
int dcheck(INTERVAL v);
void print_interval(INTERVAL v);
%}

%union {
    int ival;
    double dval;
    INTERVAL vval;
}

%token <ival> DREG VREG
%token <dval> CONST
%type <dval> dexp
%type <vval> vexp

%left '+' '-'
%left '*' '/'
%left UMINUS

%%

lines: /* empty */
     | lines line
     ;

line: dexp '\n'         { printf("%15.8f\n", $1); }
    | vexp '\n'         { print_interval($1); }
    | DREG '=' dexp '\n' { dreg[$1] = $3; }
    | VREG '=' vexp '\n' { vreg[$1] = $3; }
    | error '\n'        { yyerrok; }
    ;

dexp: CONST
    | DREG              { $$ = dreg[$1]; }
    | dexp '+' dexp     { $$ = $1 + $3; }
    | dexp '-' dexp     { $$ = $1 - $3; }
    | dexp '*' dexp     { $$ = $1 * $3; }
    | dexp '/' dexp     { $$ = $1 / $3; }
    | '-' dexp %prec UMINUS { $$ = -$2; }
    | '(' dexp ')'      { $$ = $2; }
    ;

vexp: dexp              { $$.lo = $$.hi = $1; }
    | '(' dexp ',' dexp ')' {
        if ($2 > $4) {
            printf("Error: intervalo mal definido\n");
            YYERROR;
        }
        $$.lo = $2;
        $$.hi = $4;
      }
    | VREG              { $$ = vreg[$1]; }
    | vexp '+' vexp     { $$ = vadd($1, $3); }
    | dexp '+' vexp     { INTERVAL temp = { $1, $1 }; $$ = vadd(temp, $3); }
    | vexp '-' vexp     { $$ = vsub($1, $3); }
    | dexp '-' vexp     { INTERVAL temp = { $1, $1 }; $$ = vsub(temp, $3); }
    | vexp '*' vexp     { $$ = vmul_interval($1, $3); }
    | dexp '*' vexp     { $$ = vmul_scalar($1, $3); }
    | vexp '/' vexp     { if (dcheck($3)) YYERROR; $$ = vdiv_interval($1, $3); }
    | dexp '/' vexp     { if (dcheck($3)) YYERROR; $$ = vdiv_scalar($1, $3); }
    | '-' vexp %prec UMINUS { $$.lo = -$2.hi; $$.hi = -$2.lo; }
    | '(' vexp ')'      { $$ = $2; }
    ;

%%

/* Implementación de funciones */
INTERVAL vadd(INTERVAL a, INTERVAL b) {
    INTERVAL result;
    result.lo = a.lo + b.lo;
    result.hi = a.hi + b.hi;
    return result;
}

INTERVAL vsub(INTERVAL a, INTERVAL b) {
    INTERVAL result;
    result.lo = a.lo - b.hi;
    result.hi = a.hi - b.lo;
    return result;
}

INTERVAL vmul_scalar(double a, INTERVAL b) {
    INTERVAL result;
    double x = a * b.lo;
    double y = a * b.hi;
    result.lo = x < y ? x : y;
    result.hi = x > y ? x : y;
    return result;
}

INTERVAL vmul_interval(INTERVAL a, INTERVAL b) {
    INTERVAL result;
    double vals[4] = {
        a.lo * b.lo,
        a.lo * b.hi,
        a.hi * b.lo,
        a.hi * b.hi
    };
    int i;
    
    result.lo = result.hi = vals[0];
    for (i = 1; i < 4; i++) {
        if (vals[i] < result.lo) result.lo = vals[i];
        if (vals[i] > result.hi) result.hi = vals[i];
    }
    return result;
}

INTERVAL vdiv_scalar(double a, INTERVAL b) {
    INTERVAL result = {0.0, 0.0};
    if (dcheck(b)) {
        printf("Error: división por intervalo que contiene cero\n");
        return result;
    }
    double x = a / b.lo;
    double y = a / b.hi;
    result.lo = x < y ? x : y;
    result.hi = x > y ? x : y;
    return result;
}

INTERVAL vdiv_interval(INTERVAL a, INTERVAL b) {
    INTERVAL result = {0.0, 0.0};
    if (dcheck(b)) {
        printf("Error: división por intervalo que contiene cero\n");
        return result;
    }
    double vals[4] = {
        a.lo / b.lo,
        a.lo / b.hi,
        a.hi / b.lo,
        a.hi / b.hi
    };
    int i;
    
    result.lo = result.hi = vals[0];
    for (i = 1; i < 4; i++) {
        if (vals[i] < result.lo) result.lo = vals[i];
        if (vals[i] > result.hi) result.hi = vals[i];
    }
    return result;
}

int dcheck(INTERVAL v) {
    return v.lo <= 0 && v.hi >= 0;
}

void print_interval(INTERVAL v) {
    printf("(%15.8f, %15.8f)\n", v.lo, v.hi);
}

int yylex(void);
int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}

int main(void) {
    int i;
    for (i = 0; i < 26; i++) {
        dreg[i] = 0.0;
        vreg[i].lo = vreg[i].hi = 0.0;
    }
    return yyparse();
}