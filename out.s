.text
    .global _start

_start:

	pushq 	$55

	pushq 	$2

	popq 	%rax
	popq 	%rbx
	addq 	%rbx, %rax
	pushq 	%rax

	popq 	%rbx
    movq    $1, %rax
    int     $0x80

