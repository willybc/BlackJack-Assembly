.8086
.model small
.stack 100h

.data
    seed dw 1
    total dw 0
.code
public mezcla
MAX_RAND = 0fff1h ; constante
mezcla proc
    push ax
    push bx
    push cx
    push dx
    push si

    mov si, bx; muevo a si el offset xq bx lo voy a usar
    mov ah, 0
    int 1ah

    mov word[seed], dx

    ;mov cx, 50
nxt:
    ;basado en linear congruential generator
    ;seed = (seed * MAX_RAND + 1) mod FFFF 
    ;la seed la tomo de los ciclos de reloj 
    mov ax, MAX_RAND
    mov cx, word[seed]
    mul cx
    inc ax
    mov word[seed], ax

    mov ax, dx
    mov cx, 52 ; este es el rango, va a generar numeros del 0 a "n"
    mul cx

    mov bx, MAX_RAND
    div bx

    inc ax

    ;pasar offset de la variable primero
    mov bx, si
    call noR

    cmp di, 1
    je nxt

finmez:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
mezcla endp

noR proc
    push bx
    push cx

    mov cx, 51
    ;verifica que no haya numeros repetidos
    ;a medida q se genera un numero, se fija q no este repetido
    ;en caso de que esté, genera otro, vuelve a chequear y asi
    ;sucesivamente
    verifico:
        cmp [bx], al
        je repetido
        cmp byte ptr[bx], 0
        je noRepetido
        inc bx
        loop verifico
    signoP:
        mov byte ptr[bx], al
        mov di, 2
        jmp finalNor

    noRepetido:
        mov byte ptr[bx], al
        mov di, 1
        jmp finalNor
    
    repetido:
        mov di, 1

    finalNor:
        pop cx
        pop bx
        ret
noR endp
end
