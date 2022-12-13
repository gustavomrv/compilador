.text
    .global _start

_start:

	pushq 	$5

	popq 	%rbx
    movq    $1, %rax
    int     $0x80

