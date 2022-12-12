bison -d minimo.y
flex minimo.flex
gcc minimo.tab.c lex.yy.c -lfl -o minimo
./minimo < entrada.c