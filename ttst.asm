.8086
.model small
.stack 100h

.data

.code
public dameCarta
dameCarta proc
    push ax
    push bx
    push cx
    push dx
    push si

    ;por si recibe el offset de la carta del mazo que tiene que pasar
    ;por bx el offset donde la tiene que colocar
    mov cx, 4
    proxPalabra:
        mov al, byte ptr[si]
        mov byte ptr[bx], al
        inc si
        inc bx
        loop proxPalabra
        jmp fin

    fin:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
dameCarta endp
end
