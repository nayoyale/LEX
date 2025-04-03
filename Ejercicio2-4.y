%{
#include <stdio.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern void yyrestart(FILE*);
%}

%token INSERT INTO VALUES IDENTIFIER STRING NUMBER COMMA SEMICOLON LPAREN RPAREN

%%
statement:
    INSERT INTO IDENTIFIER VALUES LPAREN value_list RPAREN SEMICOLON
    {
        printf("\nInstruccion INSERT valida.\n");
    }
    ;

value_list:
    value
    | value_list COMMA value
    ;

value:
    STRING
    | NUMBER
    ;

%%

int main() {
    char input[256];

    printf("Ingrese una consulta SQL (o escriba 'exit;' para salir):\n");
    
    while (1) {
        printf("> ");
        if (!fgets(input, sizeof(input), stdin)) {
            break;
        }

        if (strncmp(input, "exit;", 5) == 0) {
            printf("Saliendo...\n");
            break;
        }

        FILE* temp = fopen("temp_input.txt", "w");
        if (!temp) {
            perror("Error al crear archivo temporal");
            return 1;
        }
        fprintf(temp, "%s", input);
        fclose(temp);

        temp = fopen("temp_input.txt", "r");
        if (!temp) {
            perror("Error al leer archivo temporal");
            return 1;
        }

        printf("\nLeyendo instruccion: ");
        char c;
	printf("\n");
        while ((c = fgetc(temp)) != EOF){
            putchar(c);
        }
        fclose(temp);

        printf("\n");

        temp = fopen("temp_input.txt", "r");
        if (!temp) {
            perror("Error al leer archivo temporal para el parser");
            return 1;
        }

        yyrestart(temp); 
        yyparse();
        fclose(temp);
    }

    return 0;
}

int yyerror(char* s) {
    printf("\nError: %s\n", s);
    return 1;
}
