.8086
.model small
.stack 100h
.data
    user_carta_2 db '00', 0dh, 0ah, 24h
.code
public Generador_Carta
public delay

Generador_Carta proc
    push bp
    mov bp, sp
    push ax
    push bx
    push dx
    push di
    pushf

    mov di, ss:[bp+4]

    call delay

    mov ah,0
    int 1ah
    
    mov ax, dx
    mov dx,0
    mov bx, 10
    div bx

    mov [di], dl

    popf
    pop di
    pop dx
    pop bx
    pop ax
    pop bp

    ret
Generador_Carta endp

delay proc
    push cx
    mov cx, 1
    startDelay:
        cmp cx, 30000
        je endDelay
        inc cx
        jmp startDelay
    endDelay:
    pop cx
        ret
delay endp
end