.text
    .global _start

_start:

	pushq 	$1

	pushq 	$3

	pushq 	$2

	popq 	%rax
	popq 	%rbx
	mulq 	%rbx
	pushq 	%rax

	popq 	%rax
	popq 	%rbx
	mulq 	%rbx
	pushq 	%rax

	popq 	%rbx
    movq    $1, %rax
    int     $0x80

