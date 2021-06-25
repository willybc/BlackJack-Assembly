.8086
.model small
.stack 100h

.data
    rr db 0,0,0,0,0,0,0,0,0,0,0,0,0
    rr2 db 0,0,0,0,0,0,0,0,0,0,0,0,0
    rr3 db 0,0,0,0,0,0,0,0,0,0,0,0,0
    rr4 db 0,0,0,0,0,0,0,0,0,0,0,0,0, 38h
    cartas db 'a01x', 'a02x', 'a03x', 'a04x', 'a05x', 'a06x', 'a07x', 'a08x', 'a09x', 'a10x', 'a10j', 'a10q', 'a01k'
    cartas2 db 'b01x', 'b02x', 'b03x', 'b04x', 'b05x', 'b06x', 'b07x', 'b08x', 'b09x', 'b10x', 'b10j', 'b10q', 'b01k'
    cartas3 db 'c01x', 'c02x', 'c03x', 'c04x', 'c05x', 'c06x', 'c07x', 'c08x', 'c09x', 'c10x', 'c10j', 'c10q', 'c01k'
    cartas4 db 'd01x', 'd02x', 'd03x', 'd04x', 'd05x', 'd06x', 'd07x', 'd08x', 'd09x', 'd10x', 'd10j', 'd10q', 'd01k', 24h
    ;jeje db "00", 20h, 24h
    filehandler db 00h, 00h ; son 4 ceros xq son 2 bytes
    errorOpen db "Error al abrir el archivo", 0dh, 0ah, 24h
    errorWrite db "Ha ocurrido un error al escribir el archivo", 0dh, 0ah, 24h
    errorPointer db "Error pointer", 0dh, 0ah, 24h
    archivo db 'mazo.txt', '$'
.code
public haceMazo
extrn mezcla:proc
haceMazo proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    lea bx, rr; recibe por bx el offset de los numeros vacios para ordenar el mazo
    ;push bx
    call mezcla

    lea dx, archivo ; hay q pasarle el offset del nombre del archivo
    mov ax, 3d01h
    int 21h
    jc errorO
    mov word ptr[filehandler], ax

    xor ax, ax
    xor dx, dx
    
    ;locacion del puntero
    

    lea si, rr; popea bx en si
    lea di, cartas
muevoPointer:
    cmp byte ptr[si], 38h
    je yasta
    mov ax, 4200h
    mov bx, word ptr[filehandler]
    mov cx, 0
    call multiplica
    int 21h
    jc errorPoint
    jmp proximaCarta

proximaCarta:
    mov cx, 4
sig:    
    push cx


    ;escribe 
    mov ah, 40h
    mov cx, 1
    mov dx, di
    mov bx, word ptr[filehandler]
    int 21h
    jc errorW
    pop cx
    inc di
    loop sig
    jmp resetPointer
    

errorO:
    mov ah, 9
    lea dx, errorOpen
    int 21h
    jmp yasta

errorPoint:
    mov ah, 9
    lea dx, errorPointer
    int 21h
    jmp yasta

errorW:
    mov ah, 9
    lea dx, errorWrite
    int 21h

resetPointer:
    mov ax, 4200h
    mov bx, word ptr[filehandler]
    mov cx, 0
    mov dx, 0
    int 21h
    jmp muevoPointer

yasta:
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
haceMazo endp

multiplica proc
    push ax
    push bx
    push cx

    mov al, byte ptr[si]
    mov dl, 4
    mul dl  
    xor dx, dx      
    mov dl, al
    inc si

    pop cx
    pop bx
    pop ax
    ret
multiplica endp
end
