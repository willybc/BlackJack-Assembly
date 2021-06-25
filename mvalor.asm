.8086
.model small
.stack 100h
.data
.code
public muevoValor
muevoValor proc
    push ax
    push bx
    push cx
    push si

    ;por si el offset de variable que tiene la carta
    inc si
    ;por bx offset de variable q almacena el valor en ascii
    mov cx, 2
    mV:
        ;b10x
        ;10
        mov al, byte ptr[si]
        mov byte ptr[bx], al
        inc bx
        inc si
        loop mV


    pop si
    pop cx
    pop bx
    pop ax
    ret
muevoValor endp
end