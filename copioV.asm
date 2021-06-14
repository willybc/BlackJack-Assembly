.8086
.model small
.stack 100h
.data
.code
public copioVariable

copioVariable proc
    push ax
    push bx
    push si
    push di

    mov di, dx
cicloCopia:
    mov al, byte ptr [di]

    cmp al, 0dh
    je terminoCopia

    cmp al, 0ah
    je terminoCopia

    mov [bx], al

    inc bx
    inc di
    jmp cicloCopia

terminoCopia:
    pop di
    pop si
    pop bx
    pop ax
    ret
copioVariable endp 
end