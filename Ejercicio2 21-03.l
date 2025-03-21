%option noyywrap
%{
    #include <stdio.h>
    #include <string.h>

    int happy1 = 0, happy2 = 0, happy3 = 0, happy4 = 0;
    int bad1 = 0, bad2 = 0, bad3 = 0, bad4 = 0;
    int neutro = 0;
    
    FILE *salida; // Archivo corregido

    // Lista de palabras irrelevantes
    const char *irrelevantes[] = {
        "el", "la", "los", "las", "y", "o", "pero", "porque", "aunque",
        "sin", "con", "sobre", "ante", "bajo", "tras", "de", "a", "en", "para",
        "por", "según", "durante", "mediante", "excepto", "salvo", "hasta",
        "mientras", "cuando", "donde", "quien", "cual", "cuyo", NULL
    };

    // Lista de nombres propios (personajes de Harry Potter)
    const char *nombres_propios[] = {
        "Harry", "Ron", "Hermione", "Draco", "Malfoy", "Sirius", "Lupin", 
        "Snape", "Dumbledore", "Voldemort", "Hagrid", "Ginny", "Neville", 
        "Fred", "George", "Percy", "Luna", "Bellatrix", "Lucius", "Riddle", NULL
    };

    // Función para verificar si una palabra es irrelevante o un nombre propio
    int esIrrelevante(const char *palabra) {
        int i;
        // Verificar si es una palabra irrelevante
        for (i = 0; irrelevantes[i] != NULL; i++) {
            if (strcmp(palabra, irrelevantes[i]) == 0) {
                return 1;
            }
        }
        // Verificar si es un nombre propio
        for (i = 0; nombres_propios[i] != NULL; i++) {
            if (strcmp(palabra, nombres_propios[i]) == 0) {
                return 1;
            }
        }
        return 0;
    }

    // Estructura para almacenar emociones y su conteo
    typedef struct {
        char nombre[20];
        int cantidad;
    } Emocion;

    // Función para ordenar el TOP 10 de emociones en orden descendente
    void ordenarEmociones(Emocion emociones[], int n) {
        int i, j;
        Emocion temp;
        for (i = 0; i < n - 1; i++) {
            for (j = i + 1; j < n; j++) {
                if (emociones[j].cantidad > emociones[i].cantidad) {
                    temp = emociones[i];
                    emociones[i] = emociones[j];
                    emociones[j] = temp;
                }
            }
        }
    }

%}

%%

querer|amar|cariño|ternura|admiración|afecto { happy1++; }
feliz|contento|entusiasmo|risa|euforia|placer { happy2++; }
optimismo|confianza|ilusión|motivación|inspirador { happy3++; }
logro|triunfo|superación|avance|ganar|orgullo { happy4++; }
llanto|soledad|vacío|desesperanza|pérdida|dolor { bad1++; }
temor|angustia|inseguridad|pánico|horror|amenaza { bad2++; }
ira|odio|rabia|resentimiento|frustración|venganza { bad3++; }
fracaso|decepción|pérdida|humillación|rendirse { bad4++; }
cambio|duda|destino|misterio|sorpresa { neutro++; }

[a-zA-Z]+ {
    if (!esIrrelevante(yytext)) {
        fprintf(salida, "%s ", yytext); // Guardar palabra en archivo corregido
    }
}

%%

int main() {
    // Abrir archivo de salida
    salida = fopen("corregido.txt", "w");
    if (salida == NULL) {
        printf("Error al crear el archivo corregido.txt\n");
        return 1;
    }

    yylex(); // Ejecutar el analizador léxico

    // Guardar emociones en un arreglo
    Emocion emociones[] = {
        {"AMOR", happy1}, {"ALEGRIA", happy2}, {"ESPERANZA", happy3}, {"EXITO", happy4},
        {"TRISTEZA", bad1}, {"MIEDO", bad2}, {"ENOJO", bad3}, {"FRACASO", bad4},
        {"NEUTRAS", neutro}
    };

    // Ordenar emociones en orden descendente
    ordenarEmociones(emociones, 9);

    // Mostrar el TOP 10
    printf("\nTOP 10 de emociones en el texto:\n");
    int i;
    for (i = 0; i < 9; i++) { // Hay 9 categorías en total
        if (emociones[i].cantidad > 0) {
            printf("%s: %d veces\n", emociones[i].nombre, emociones[i].cantidad);
        }
    }

    printf("\nArchivo corregido guardado como 'corregido.txt'\n");

    // Cerrar el archivo de salida
    fclose(salida);

    return 0;
}
