format ELF64 executable 3

entry start
include 'std.inc'

segment readable executable

start:
    open path, 65536, 0
    cmp rax, 0
    jl error_exit
    mov r15, rax

read_loop:
    mov rax, sys_getdents64
    mov rdi, r15
    mov rsi, buffer
    mov rdx, 1024
    syscall

    cmp rax, 0
    je success_cleanup_exit
    jl error_cleanup_exit

    mov r14, rax
    xor r13, r13

parse_loop:
    movzx r12, word [buffer + r13 + 16]
    lea rsi, [buffer + r13 + 19]
    count_len rsi, rcx
    write 1, rsi, rcx
    write 1, newline, 1
    add r13, r12
    cmp r13, r14
    jb parse_loop
    jmp read_loop

error_cleanup_exit:
    mov rax, sys_close
    mov rdi, r15
    syscall

error_exit:
    exit 1

success_cleanup_exit:
    mov rax, sys_close
    mov rdi, r15
    syscall
    exit 0

segment readable writeable
    path db '.', 0
    newline db 10
    buffer rb 1024
