.text
    .global _start

_start:

	pushq 	$1

	pushq 	$2

	pushq 	$4

	popq 	%rax
	popq 	%rbx
	mulq 	%rbx
	pushq 	%rax

	popq 	%rax
	popq 	%rbx
	addq 	%rbx, %rax
	pushq 	%rax

	pushq 	$4

	popq 	%rbx
	popq 	%rax
	subq 	%rbx, %rax
	pushq 	%rax

	popq 	%rbx
    movq    $1, %rax
    int     $0x80

