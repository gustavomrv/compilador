.text
    .global _start

_start:

	pushq 	$0

	popq 	%rbx
    movq    $1, %rax
    int     $0x80

