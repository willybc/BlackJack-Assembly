;ASCII A REG
;Funcion que recibe el offset de una variable por DX con contenido en valores ascii
;Recorre la variable, suma los valores y los deja en CX con formato numerico para poder trabajarlo

.8086
.model small
.stack 100h
.data

.code

public asciiareg

asciiareg proc
    push ax
    push bx
    ;push dx
    pushf

    mov cx, 0
    ;sub [bx], 30h
    mov bx, dx
    mov al, [bx]
    sub al, 30h
    mov dl, 10
    mul dl
    add cl, al

    inc bx
    ;sub [bx], 30h
    mov al, [bx]
    sub al, 30h
    add cl, al;[bx]

    popf
    ;pop dx
    pop bx
    pop ax
    ret

    asciiareg endp
    
end