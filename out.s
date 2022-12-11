.text
    .global _start

_start:

    movq    $5, %rax
    movq    $3, %rbx
    addq    %rax, %rbx
    movq    $1, %rax
    int     $0x80

