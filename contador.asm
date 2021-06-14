.8086
.model small
.stack 100h
.data
    player_txt1 db " Mano de jugador [ ",24h
    player_total db "00",24h
    player_txt2 db " ] :",0dh, 0ah,24h

    comp_txt1 db " Mano de computadora [ ",24h
    comp_total db "00",24h
    comp_txt2 db " ] :",0dh, 0ah,24h

    user_suma_01 db '0', 0dh, 0ah, 24h
.code
public Impr_cont_player
public Impr_cont_comp
public user_suma_1

extrn salto:proc

extrn regascii2:proc
extrn asciiareg:proc

user_suma_1 proc
    ;RECIBI EN BX USER_CARTA_1
    ;RECIBI EN DI USER_CARTA_2
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push dx
    push si
    pushf

    cmp cx,2
    je Sumo2

    cmp cx,3
    je Sumo3

    cmp cx,4
    je Sumo4

Sumo2:
    mov dx, ss:[bp+4]                   ;SUMO CARTA 1
    call asciiareg
    mov dl, cl
    push dx

    mov dx, ss:[bp+6]                   ;SUMO CARTA 2
    call asciiareg
    pop dx
    add dl, cl
    mov dh, dl
    jmp Convierto

Sumo3:
    mov dx, ss:[bp+4]                   ;SUMO CARTA 1
    call asciiareg
    mov dl, cl
    push dx

    mov dx, ss:[bp+6]                   ;SUMO CARTA 2
    call asciiareg
    pop dx
    add dl, cl
    mov dh, dl
    
    push dx
    mov dx, ss:[bp+8]                   ;SUMO CARTA 3
    call asciiareg
    pop dx
    add dl, cl
    mov dh, dl
    jmp Convierto

Sumo4:
    mov dx, ss:[bp+4]                   ;SUMO CARTA 1
    call asciiareg
    mov dl, cl
    push dx

    mov dx, ss:[bp+6]                   ;SUMO CARTA 2
    call asciiareg
    pop dx
    add dl, cl
    mov dh, dl
    
    push dx
    mov dx, ss:[bp+8]                   ;SUMO CARTA 3
    call asciiareg
    pop dx
    add dl, cl
    mov dh, dl

    push dx         
    mov dx, ss:[bp+10]                  ;SUMO CARTA 4
    call asciiareg
    pop dx
    add dl,cl
    mov dh, dl
    jmp Convierto

Convierto:
    mov bx, offset user_suma_01
    call regascii2                  ;RECIBE EN DX EL REG Y EN BX OFFSET PARA GUARDARLO

    mov bx, offset user_suma_01
    call Impr_cont_player

    popf
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret
user_suma_1 endp

Impr_cont_player proc
    ;TXT MANO DE JUGADOR
    push ax
    push bx
    push dx

    mov ah,9
    mov dx, offset player_txt1
    int 21h

    mov ah,9
    mov dx, offset bx
    int 21h

    mov ah,9
    mov dx, offset player_txt2
    int 21h

    pop dx
    pop bx
    pop ax

    ;/TXT MANO DE JUGADOR
    ret
Impr_cont_player endp

Impr_cont_comp proc
    ;TXT MANO DE COMPUTADORA
    push ax
    push dx
    

    mov ah,9
    mov dx, offset comp_txt1
    int 21h

    mov ah,9
    mov dx, offset comp_total
    int 21h

    mov ah,9
    mov dx, offset comp_txt2
    int 21h

    pop dx
    pop ax

    ;/TXT MANO DE COMPUTADORA
    ret
Impr_cont_comp endp

end