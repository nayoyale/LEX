/* Palabras con emociones positivas y negativas */
/* Cuenta cuántas veces se repiten los nombres de los personajes principales */

%{
    #include<stdio.h>

    int potter = 0, hermione = 0, ron = 0, dumbledore=0, hagrid=0, snape=0;
%}

%option noyywrap

%%

Harry[ \t]*Potter|Harry|Potter   { potter++; }
Hermione          { hermione++; }
Ron               { ron++; }
Dumbledore        { dumbledore++; }
Hagrid           { hagrid++; }
Snape            { snape++; }

%%

int main()
{
    yyin = stdin;
    yylex();

    printf("El personaje HARRY se repite: %d\n", potter);
    printf("El personaje HERMIONE se repite: %d\n", hermione);
    printf("El personaje RON se repite: %d\n", ron);
    printf("El personaje DUMBLEDORE se repite: %d\n", dumbledore);
    printf("El personaje HAGRID se repite: %d\n", hagrid);
    printf("El personaje SNAPE se repite: %d\n", snape);

    return 0;
}