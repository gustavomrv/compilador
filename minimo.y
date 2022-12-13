
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int lin;
extern int col;
extern int yyleng;
extern char *yytext;
FILE *f;

int i, j;
int cont = 0;
char texto_das_variaveis[10][10];
int  valor_das_variaveis[10];

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

void montar_add(){
	fprintf(f, "	popq 	%%rax\n");
	fprintf(f, "	popq 	%%rbx\n");
	fprintf(f, "	addq 	%%rbx, %%rax\n");
	fprintf(f, "	pushq 	%%rax\n\n");
}

void montar_sub(){
	fprintf(f, "	popq 	%%rbx\n");
	fprintf(f, "	popq 	%%rax\n");
	fprintf(f, "	subq 	%%rbx, %%rax\n");
	fprintf(f, "	pushq 	%%rax\n\n");
}

void montar_mult(){
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

void declarar_variavel(char variavel[] ){
	// printf("%s\n", variavel);
	for(i = 0; i < strlen(variavel); i++) {
		texto_das_variaveis[cont][i] = variavel[i];
	}
	valor_das_variaveis[cont] = -999;
	cont++;
	
	/* for(i=0; i<5; i++) {
        printf("Variavel %s com valor %d\n",texto_das_variaveis[i], valor_das_variaveis[i]);
    }
	printf("\n\n"); */
	
}

void atribuir_num_variavel(char variavel[] , int num){
	for(i=0; i < 10; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			valor_das_variaveis[i] = num;
		}
    }
}

void atribuir_id_variavel(char variavel_que_recebe[] , char variavel_que_da[]){
	for(i=0; i < 10; i++) {
		if (strcmp(variavel_que_recebe, texto_das_variaveis[i]) == 0){
			for(j=0; j < 10; j++) {
				if (strcmp(variavel_que_da, texto_das_variaveis[j]) == 0){
					valor_das_variaveis[i] = valor_das_variaveis[j];
				}
			}
		}
    }
}

void empilhar_variavel(char variavel[]){
	int num = -999;
	for(i=0; i < 10; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			num = valor_das_variaveis[i];
		}
    }
	fprintf(f, "	pushq 	$%i\n\n", num);
}
%}

%union { 
  	char *string; 
  	int inteiro; 
} 

%token INT MAIN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES RETURN PONTO_E_VIRGULA FECHA_CHAVES DESCONHECIDO
%token MAIS MENOS MULT IGUAL

%token <string> ID
%token <inteiro> NUM


%left MAIS MENOS
%left MULT
%%
programa	: INT MAIN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES {montar_codigo_inicial();} corpo FECHA_CHAVES {montar_codigo_final();} ;
corpo		: RETURN exp PONTO_E_VIRGULA   			{printar_res();        } corpo
			| INT ID PONTO_E_VIRGULA	   			{declarar_variavel($2);} corpo
			| decvar corpo
			|
			;
decvar      : ID IGUAL NUM PONTO_E_VIRGULA 		    {atribuir_num_variavel($1, $3);} 
			| ID IGUAL ID PONTO_E_VIRGULA 		    {atribuir_id_variavel($1, $3); } 
			;
exp         : exp MAIS exp 						    {montar_add(); } 
			| exp MENOS exp 					    {montar_sub(); } 
			| exp MULT exp 						    {montar_mult();} 
			| ABRE_PARENTESES exp FECHA_PARENTESES
			| NUM								    {montar_empilhar($1);  }
			| ID								    {empilhar_variavel($1);}
			|
			;

%%
int main(){
	yyparse();
	printf("Programa OK.\n");
}