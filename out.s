.text
    .global _start

_start:

	pushq 	$4

	pushq 	$7

	pushq 	$4

	popq 	%rax
	popq 	%rbx
	mulq 	%rbx
	pushq 	%rax

	popq 	%rax
	popq 	%rbx
	addq 	%rbx, %rax
	pushq 	%rax

	popq 	%rbx
    movq    $1, %rax
    int     $0x80

