include 'lin64.inc'

macro write fd, buf, len {
    mov rax, sys_write
    mov rdi, fd
    mov rsi, buf
    mov rdx, len
    syscall

}

macro read fd, buf, len {
    mov rax, sys_read
    mov rdi, fd
    mov rsi, buf
    mov rdx, len
    syscall
}


macro open nm, fg, rg {
    mov rax, sys_open
    mov rdi, nm
    mov rsi, fg
    mov rdx, rg
    syscall

}
macro exit code {
    mov rax, sys_exit
    mov rdi, code
    syscall
}
macro if_error_exit {
    cmp rax, 0
    jl .fatal_error   
    jmp .skip_error   

.fatal_error:
    mov rax, sys_exit
    mov rdi, 1       
    syscall

.skip_error:
}


macro count_len str_ptr, out_reg
{
    local .loop, .done

    xor out_reg, out_reg

.loop:
    cmp byte [str_ptr + out_reg], 0
    je .done

    inc out_reg
    jmp .loop

.done:
}


macro count_len_print str_ptr
{
    local .loop,.done,.convert

    xor rcx, rcx

.loop:
    cmp byte [str_ptr + rcx], 0
    je .done
    inc rcx
    jmp .loop

.done:

    mov rax, rcx
    mov rdi, buf+31
    mov byte [rdi],10

.convert:
    dec rdi
    xor rdx, rdx
    mov rbx, 10
    div rbx

    add dl, '0'
    mov [rdi], dl

    test rax,rax
    jnz .convert

    mov rax, sys_write
    mov rsi, rdi
    mov rdx, buf+32
    sub rdx, rdi
    mov rdi, 1
    syscall
}
macro count_lenadr ptr, out_reg
{
    local .loop,.done

    xor out_reg, out_reg

.loop:
    cmp byte [ptr + out_reg], 0
    je .done

    inc out_reg
    jmp .loop

.done:
}