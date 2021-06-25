.8086
.model small
.stack 100h
.data
    errorOpen db "Error al abrir el archivo", 0dh, 0ah, 24h
    errorRead db "Ha ocurrido un error al leer el archivo", 0dh, 0ah, 24h
    errorPointer db "Error pointer", 0dh, 0ah, 24h
    archivo db 'mazo.txt', '$'
    filehandler db 00h, 00h ; son 4 ceros xq son 2 bytes
.code
public dameMazo
dameMazo proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    ; por si viene el offset de la variable en la que se guardan las cartas
    mov di, 4; posicion inicial del puntero para saltarme los 4 espacios

    
    lea dx, archivo ; hay q pasarle el offset del nombre del archivo
    mov ax, 3d02h
    int 21h
    jc errorO
    mov word ptr[filehandler], ax

    ; muevo el puntero en base a di, para saltarme los 4 espacios en blanco del inicio del txt
    xor dx, dx
    mov cx, 0
    mov dx, di
    mov ax, 4200h
    mov bx, word ptr[filehandler]
    mov cx, 0
    int 21h
    jc errorPoint

    ; pasa el valor del txt a la variable que vino por parametros
    mov cx, 52
    push cx
    nextWord:
        mov ah, 3fh
        mov bx, word ptr[filehandler]
        mov cx, 4
        mov dx, si
        int 21h
        jc errorRe
        add si, 4
        pop cx
        loop nextWord
        jmp elfin

errorO:
    mov ah, 9
    lea dx, errorOpen
    int 21h
    jmp elfin

errorPoint:
    mov ah, 9
    lea dx, errorPointer
    int 21h
    jmp elfin

errorRe:
    mov al, 40
    xor al, al
    mov ah, 9
    lea dx, errorRead
    int 21h
    jmp elfin


elfin:
    xor ax,ax
    mov ah, 3eh
    mov bx, word ptr[filehandler]
    int 21h

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
dameMazo endp
end