bison -d minimo.y
flex minimo.flex
gcc minimo.tab.c lex.yy.c -lfl -o minimo
./minimo < entrada.c
as out.s -o out.o
ld -s -o out out.o
./out
echo $?