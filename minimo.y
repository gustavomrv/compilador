
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

void montar_add(int a, int b){
	fprintf(f, "	popq 	%%rax\n");
	fprintf(f, "	popq 	%%rbx\n");
	fprintf(f, "	addq 	%%rbx, %%rax\n");
	fprintf(f, "	pushq 	%%rax\n\n");
}

void montar_sub(int a, int b){
	fprintf(f, "	popq 	%%rbx\n");
	fprintf(f, "	popq 	%%rax\n");
	fprintf(f, "	subq 	%%rbx, %%rax\n");
	fprintf(f, "	pushq 	%%rax\n\n");
}

void montar_mult(int a, int b){
	fprintf(f, "	popq 	%%rax\n");
	fprintf(f, "	popq 	%%rbx\n");
	fprintf(f, "	mulq 	%%rbx\n");
	fprintf(f, "	pushq 	%%rax\n\n");
}

void montar_empilhar(int a){
	fprintf(f, "	pushq 	$%i\n\n", a);
}

void printar_res() {
	fprintf(f, "	popq 	%%rbx\n");
	fprintf(f, "    movq    $1, %%rax\n");
	fprintf(f, "    int     $0x80\n\n");
}
%}

%token INT MAIN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES RETURN PONTO_E_VIRGULA FECHA_CHAVES ID DESCONHECIDO
%token MAIS MENOS MULT
%token NUM
%left MAIS MENOS
%left MULT
%%
programa	: INT MAIN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES {montar_codigo_inicial();} corpo FECHA_CHAVES {montar_codigo_final();} ;
corpo		: RETURN NUM PONTO_E_VIRGULA {montar_codigo_retorno($2);} corpo
			| RETURN exp PONTO_E_VIRGULA {printar_res();}
			|
			;
exp         : exp MAIS exp 								{montar_add($1,$3);} 
			| exp MENOS exp 							{montar_sub($1,$3);} 
			| exp MULT exp 								{montar_mult($1,$3);} 
			| ABRE_PARENTESES exp FECHA_PARENTESES
			| NUM										{montar_empilhar($1);}
			|
			;

%%
int main(){
	yyparse();
	printf("Programa OK.\n");
}
/*
exp         : NUM MAIS exp 		{montar_add($1,$3);} 
			| NUM MENOS exp 	{montar_sub($1,$3);} 
			| NUM MULT exp 		{montar_mult($1,$3);} 
			| NUM				{}
			;

exp         : NUM MAIS NUM {montar_add($1,$3);} exp
			| NUM MENOS NUM {montar_sub($1,$3);} exp
			| NUM MULT NUM {montar_mult($1,$3);} exp
			|
			;
.text
    .global _start

_start:

    movq    $1, %rax
    movq    $3, %rbx
    addq    %rax, %rbx

    movq    $1, %rax
    subq    $1, %rbx

    movq    $1, %rax
    int     $0x80
*/