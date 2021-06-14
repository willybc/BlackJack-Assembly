;DEVUELVE EN CL SI PRESIONO ENTER CON 1 O ESPACIO CON 0
.8086
.model small
.stack 100h
.data
;262 ♠
;261 ♣
;260 ♦
;259 ♥
    txt_HitOrStand db '                                               '
    txt_HitOrStan2 db 'HIT <Spacebar>, STAND <Enter>', 0dh, 0ah, 24h
.code
public HitOrStand

HitOrStand proc
    push ax
    push dx
    pushf

    mov ah,9
    mov dx, offset txt_HitOrStand
    int 21h
CicloHitOrStand:    
    mov ah, 1
    int 21h

    cmp al, 20h
    je Espacio

    cmp al, 0dh
    je Enter
    jmp CicloHitOrStand

Espacio:                ;HIT PEDIR CARTA
    mov cl,0
    jmp finHitStand
Enter:                  ;STAND  DEJAR LA MANO
    mov cl,1
    jmp finHitStand

finHitStand:   
    popf
    pop dx
    pop ax
    ret
HitOrStand endp
end