
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define N_MAXIMO_DE_VARIAVEIS 10

extern int lin;
extern int col;
extern int yyleng;
extern char *yytext;
FILE *f;

int i, j;
int cont = 0;
char texto_das_variaveis[N_MAXIMO_DE_VARIAVEIS][N_MAXIMO_DE_VARIAVEIS];
int  valor_das_variaveis[N_MAXIMO_DE_VARIAVEIS];

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

void empilhar_numero(int a){
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
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			valor_das_variaveis[i] = num;
		}
    }
}

void atribuir_id_variavel(char variavel_que_recebe[] , char variavel_que_da[]){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel_que_recebe, texto_das_variaveis[i]) == 0){
			for(j=0; j < N_MAXIMO_DE_VARIAVEIS; j++) {
				if (strcmp(variavel_que_da, texto_das_variaveis[j]) == 0){
					valor_das_variaveis[i] = valor_das_variaveis[j];
				}
			}
		}
    }
}

void empilhar_variavel(char variavel[]){
	int num = -999;
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			num = valor_das_variaveis[i];
		}
    }
	fprintf(f, "	pushq 	$%i\n\n", num);
}
//======================= COMPARAÇÕES ===============================//
void igualdade_nums(int a, int b){
	if (a == b) fprintf(f, "	pushq 	$1\n\n");
		else 	fprintf(f, "	pushq 	$0\n\n");
}

void igualdade_id_num(char variavel[], int b){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			if (valor_das_variaveis[i] == b) fprintf(f, "	pushq 	$1\n\n");
				else 						 fprintf(f, "	pushq 	$0\n\n");
		}
    }		
}

void igualdade_ids(char variavel_a[] , char variavel_b[]){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel_a, texto_das_variaveis[i]) == 0){
			for(j=0; j < N_MAXIMO_DE_VARIAVEIS; j++) {
				if (strcmp(variavel_b, texto_das_variaveis[j]) == 0){
					if (valor_das_variaveis[i] == valor_das_variaveis[j]) fprintf(f, "	pushq 	$1\n\n");
					else 												  fprintf(f, "	pushq 	$0\n\n");
				}
			}
		}
    }
}

void diferente_nums(int a, int b){
	if (a == b) fprintf(f, "	pushq 	$0\n\n");
		else 	fprintf(f, "	pushq 	$1\n\n");
}

void diferente_id_num(char variavel[], int b){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			if (valor_das_variaveis[i] == b) fprintf(f, "	pushq 	$0\n\n");
				else 						 fprintf(f, "	pushq 	$1\n\n");
		}
    }		
}

void diferente_ids(char variavel_a[] , char variavel_b[]){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel_a, texto_das_variaveis[i]) == 0){
			for(j=0; j < N_MAXIMO_DE_VARIAVEIS; j++) {
				if (strcmp(variavel_b, texto_das_variaveis[j]) == 0){
					if (valor_das_variaveis[i] == valor_das_variaveis[j]) fprintf(f, "	pushq 	$0\n\n");
					else 												  fprintf(f, "	pushq 	$1\n\n");
				}
			}
		}
    }
}

void maior_nums(int a, int b){
	if (a > b) fprintf(f, "	pushq 	$1\n\n");
		else   fprintf(f, "	pushq 	$0\n\n");
}

void maior_id_num(char variavel[], int b){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			if (valor_das_variaveis[i] > b) fprintf(f, "	pushq 	$1\n\n");
				else 						fprintf(f, "	pushq 	$0\n\n");
		}
    }		
}

void maior_num_id(int a, char variavel[]){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			if (a > valor_das_variaveis[i]) fprintf(f, "	pushq 	$1\n\n");
				else 						fprintf(f, "	pushq 	$0\n\n");
		}
    }		
}

void maior_ids(char variavel_a[] , char variavel_b[]){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel_a, texto_das_variaveis[i]) == 0){
			for(j=0; j < N_MAXIMO_DE_VARIAVEIS; j++) {
				if (strcmp(variavel_b, texto_das_variaveis[j]) == 0){
					if (valor_das_variaveis[i] > valor_das_variaveis[j]) fprintf(f, "	pushq 	$1\n\n");
					else 												  fprintf(f, "	pushq 	$0\n\n");
				}
			}
		}
    }
}

void maior_igual_nums(int a, int b){
	if (a >= b) fprintf(f, "	pushq 	$1\n\n");
		else    fprintf(f, "	pushq 	$0\n\n");
}

void maior_igual_id_num(char variavel[], int b){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			if (valor_das_variaveis[i] >= b) fprintf(f, "	pushq 	$1\n\n");
				else 						 fprintf(f, "	pushq 	$0\n\n");
		}
    }		
}

void maior_igual_num_id(int a, char variavel[]){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			if (a >= valor_das_variaveis[i]) fprintf(f, "	pushq 	$1\n\n");
				else 						 fprintf(f, "	pushq 	$0\n\n");
		}
    }		
}

void maior_igual_ids(char variavel_a[] , char variavel_b[]){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel_a, texto_das_variaveis[i]) == 0){
			for(j=0; j < N_MAXIMO_DE_VARIAVEIS; j++) {
				if (strcmp(variavel_b, texto_das_variaveis[j]) == 0){
					if (valor_das_variaveis[i] >= valor_das_variaveis[j]) fprintf(f, "	pushq 	$1\n\n");
					else 												  fprintf(f, "	pushq 	$0\n\n");
				}
			}
		}
    }
}

void menor_id_num(char variavel[], int b){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			if (valor_das_variaveis[i] < b) fprintf(f, "	pushq 	$1\n\n");
				else 						fprintf(f, "	pushq 	$0\n\n");
		}
    }		
}

void menor_num_id(int a, char variavel[]){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			if (a < valor_das_variaveis[i]) fprintf(f, "	pushq 	$1\n\n");
				else 						fprintf(f, "	pushq 	$0\n\n");
		}
    }		
}

void menor_igual_nums(int a, int b){
	if (a <= b) fprintf(f, "	pushq 	$1\n\n");
		else    fprintf(f, "	pushq 	$0\n\n");
}

void menor_igual_id_num(char variavel[], int b){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			if (valor_das_variaveis[i] <= b) fprintf(f, "	pushq 	$1\n\n");
				else 						 fprintf(f, "	pushq 	$0\n\n");
		}
    }		
}

void menor_igual_num_id(int a, char variavel[]){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel, texto_das_variaveis[i]) == 0){
			if (a <= valor_das_variaveis[i]) fprintf(f, "	pushq 	$1\n\n");
				else 						 fprintf(f, "	pushq 	$0\n\n");
		}
    }		
}

void menor_igual_ids(char variavel_a[] , char variavel_b[]){
	for(i=0; i < N_MAXIMO_DE_VARIAVEIS; i++) {
		if (strcmp(variavel_a, texto_das_variaveis[i]) == 0){
			for(j=0; j < N_MAXIMO_DE_VARIAVEIS; j++) {
				if (strcmp(variavel_b, texto_das_variaveis[j]) == 0){
					if (valor_das_variaveis[i] <= valor_das_variaveis[j]) fprintf(f, "	pushq 	$1\n\n");
					else 												  fprintf(f, "	pushq 	$0\n\n");
				}
			}
		}
    }
}
//===================================================================//
%}

%union { 
  	char *string; 
  	int inteiro; 
} 

%token INT MAIN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES RETURN PONTO_E_VIRGULA FECHA_CHAVES DESCONHECIDO
%token MAIS MENOS MULT IGUAL MENOR MAIOR EXCLAMACAO

%token <string> ID
%token <inteiro> NUM

%left MAIS MENOS
%left MULT
%%
programa	: INT MAIN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES {montar_codigo_inicial();} corpo FECHA_CHAVES {montar_codigo_final();} ;
corpo		: RETURN exp PONTO_E_VIRGULA   			{printar_res();        } corpo
			| INT ID PONTO_E_VIRGULA	   			{declarar_variavel($2);} corpo
			| decvar 														 corpo
			| RETURN comparar PONTO_E_VIRGULA		{printar_res();        } corpo
			|
			;
comparar	: NUM IGUAL IGUAL NUM					{igualdade_nums($1, $4);  	}
			| ID  IGUAL IGUAL NUM					{igualdade_id_num($1, $4);	}
			| NUM IGUAL IGUAL ID					{igualdade_id_num($4, $1);	}
			| ID IGUAL IGUAL ID						{igualdade_ids($1, $4);   	}
			| NUM MAIOR NUM							{maior_nums($1, $3);      	}
			| ID MAIOR NUM							{maior_id_num($1, $3);    	}
			| NUM MAIOR ID							{maior_num_id($1, $3);    	}
			| ID MAIOR ID							{maior_ids($1, $3);       	}
			| NUM MAIOR IGUAL NUM					{maior_igual_nums($1, $4);  }
			| ID MAIOR IGUAL NUM					{maior_igual_id_num($1, $4);}
			| NUM MAIOR IGUAL ID					{maior_igual_num_id($1, $4);}
			| ID MAIOR IGUAL ID						{maior_igual_ids($1, $4);   }
			| NUM MENOR NUM							{maior_nums($3, $1);      	}
			| ID MENOR NUM							{menor_id_num($1, $3);    	}
			| NUM MENOR ID							{menor_num_id($1, $3);    	}
			| ID MENOR ID							{maior_ids($3, $1);       	}
			| NUM MENOR IGUAL NUM					{menor_igual_nums($1, $4);  }
			| ID MENOR IGUAL NUM					{menor_igual_id_num($1, $4);}
			| NUM MENOR IGUAL ID					{menor_igual_num_id($1, $4);}
			| ID MENOR IGUAL ID						{menor_igual_ids($1, $4);   }
			| NUM EXCLAMACAO IGUAL NUM				{diferente_nums($1, $4);  	}
			| ID EXCLAMACAO IGUAL NUM				{diferente_id_num($1, $4);	}
			| NUM EXCLAMACAO IGUAL ID				{diferente_id_num($4, $1);	}
			| ID EXCLAMACAO IGUAL ID				{diferente_ids($1, $4);   	}
			;
decvar      : ID IGUAL NUM PONTO_E_VIRGULA 		    {atribuir_num_variavel($1, $3);} 
			| ID IGUAL ID PONTO_E_VIRGULA 		    {atribuir_id_variavel($1, $3); } 
			;
exp         : exp MAIS exp 						    {montar_add(); } 
			| exp MENOS exp 					    {montar_sub(); } 
			| exp MULT exp 						    {montar_mult();} 
			| ABRE_PARENTESES exp FECHA_PARENTESES
			| NUM								    {empilhar_numero($1);  }
			| ID								    {empilhar_variavel($1);}
			|
			;
%%
int main(){
	yyparse();
	printf("Programa OK.\n");
}