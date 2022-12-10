
%{
#include <stdio.h>
#include <stdlib.h>

extern int lin;
extern int col;
extern int yyleng;
extern char *yytext;
FILE *f;

int yyerror(char *msg){
	printf("%s (%i, %i) token encontrado: \"%s\"\n", msg, lin, col-yyleng, yytext);
	exit(0);
}
int yylex(void);

void montar_codigo_inicial(){
	f = fopen("out.s","w+");
	fprintf(f, ".text\n");
	fprintf(f, "    .global _start\n\n");
    	fprintf(f, "_start:\n\n");
}

void montar_codigo_final(){
	fclose(f);

	printf("Arquivo \"out.s\" gerado.\n\n");
}

void montar_codigo_retorno(int numero){
	fprintf(f, "    movq    $%d, %%rbx\n", numero);
	fprintf(f, "    movq    $1, %%rax\n");
	fprintf(f, "    int     $0x80\n\n");
}

%}
		
%token INT MAIN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES RETURN NUM PONTO_E_VIRGULA FECHA_CHAVES ID DESCONHECIDO MAIS MENOS MULT
%left '+' '-'
%left '*' '/'

%%
programa	: INT MAIN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES {montar_codigo_inicial();} corpo FECHA_CHAVES {montar_codigo_final();} ;
corpo		: RETURN NUM PONTO_E_VIRGULA {montar_codigo_retorno($2);} corpo
			| 
			;
%%
int main(){
	yyparse();
	printf("Programa OK.\n");
}
