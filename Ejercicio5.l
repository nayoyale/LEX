/*Palabras con emociones positivas y negativas */
/*Cuantas veces se repite los nombres de los personajes principales*/
%option noyywrap
%{
	#include<stdio.h>
	int happy1=0;
	int happy2=0;
	int happy3=0;
	int happy4=0;
	int bad1=0;
	int bad2=0;
	int bad3=0;
	int bad4=0;
	int neutro=0;
%}

%%
querer|amar|cari�o|ternura|admiraci�n|afecto   { happy1++; }
feliz|contento|entusiasmo|risa|euforia|placer  { happy2++; }
optimismo|confianza|ilusi�n|motivaci�n|inspirador  { happy3++; }
logro|triunfo|superaci�n|avance|ganar|orgullo  { happy4++; }
llanto|soledad|vac�o|desesperanza|p�rdida|dolor  { bad1++; }
temor|angustia|inseguridad|p�nico|horror|amenaza  { bad2++; }
ira|odio|rabia|resentimiento|frustraci�n|venganza  { bad3++; }
fracaso|decepci�n|p�rdida|humillaci�n|rendirse  { bad4++; }
cambio|duda|destino|misterio|sorpresa  { neutro++; }

%%
int main()
{
	
	yylex();
	printf("Las palabras positivas de AMOR se repiten: %d\n", happy1);
	printf("Las palabras positivas de ALEGRIA se repiten: %d\n", happy2);
	printf("Las palabras positivas de ESPERANZA se repiten: %d\n", happy3);
	printf("Las palabras positivas de EXITO se repiten: %d\n", happy4);
	printf("Las palabras negativas de TRISTEZA se repiten: %d\n", bad1);
	printf("Las palabras negativas de MIEDO se repiten: %d\n", bad2);
	printf("Las palabras negativas de ENOJO se repiten: %d\n", bad3);
	printf("Las palabras negativas de FRACASO se repiten: %d\n", bad4);
	printf("Las palabras neutras se repiten: %d\n", neutro);
	
	return 0;
}