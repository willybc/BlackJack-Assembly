.8086
.model small
.stack 100h
.data
    salto_linea db 0dh, 0ah, 24h
.code

public salto

salto proc
    push ax
    push dx

    mov ah,9
    mov dx, offset salto_linea
    int 21h

    pop dx
    pop ax

    ret
salto endp
end