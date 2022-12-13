.text
    .global _start

_start:

	pushq 	$4

	popq 	%rbx
    movq    $1, %rax
    int     $0x80

