.8086
.model small
.stack 100h
.data
    ;Impresion Carta #1
    car_ini db " ___________ ", 0dh, 0ah,24h 
    car_mid db "|           |", 0dh, 0ah,24h
    car_fin db "|___________|", 0dh, 0ah,24h 
    
    car_imp1 db "          |", 0dh, 0ah, 24h
    car_imp2 db "|          ", 24h

    car_imp_sym_1 db "|     ",24h
    car_imp_sym_2 db "     |",0dh, 0ah,24h

    ;/Impresion Carta #1

    ;Impresion Carta #2
    car2_ini db "  ________  ________ ",0dh, 0ah, 24h
    car2_mid db " |        |         |",0dh, 0ah, 24h
    car2_fin db " |________| ________|",0dh, 0ah, 24h

    car3_ini db "  ________  ________  ________ ",0dh, 0ah, 24h
    car3_mid db " |        |         |         | ",0dh, 0ah, 24h
    car3_fin db " |________| ________| ________|",0dh, 0ah, 24h

    car4_ini db "  ________  ________  ________ _________ ",0dh, 0ah, 24h
    car4_mid db " |        |         |         |         |",0dh, 0ah, 24h
    car4_fin db " |________| ________| ________|_________|",0dh, 0ah, 24h
    num_player_1 db "001", 24h
    num_player_2 db "002", 24h
    num_player_3 db "003", 24h
    num_player_4 db "004", 24h

    imp_cart_00 db " | ",24h
    imp_cart_01 db "    | ",24h
    imp_cart_02 db "     |",0dh,0ah, 24h

    imp_cart_000 db " | ",24h
    imp_cart_001 db "    | ",24h
    imp_cart_002 db "     |",0dh,0ah, 24h

    imp_cart_0000 db " | ",24h
    imp_cart_0001 db "     | ",24h
    imp_cart_0002 db "     |",0dh,0ah, 24h
    ;/Impresion Carta #2
.code
public Impr_carta

Impr_carta proc
    push bp
    mov bp, sp
    push ax
    push bx
    push dx
    push di
    push si
    pushf

    cmp bx, 2
    je tengo2

    cmp bx, 3
    je tengo3

tengo2:
    mov di, ss:[bp+4]       
    mov si, ss:[bp+6]
    jmp Empiezo

tengo3:
    mov di, ss:[bp+4]       
    push di                 
    mov di, ss:[bp+6]
    mov si, ss:[bp+8]
    jmp Empiezo
    
    
Empiezo:
    mov cx, 7 ;Cantidad de columnas de la carta

    cmp bx, 2
    je cant_2

    cmp bx, 3
    je cant_3

    cmp bx, 4
    je cant_4

cant_2:
    mov ah, 9
    mov dx, offset car2_ini
    int 21h
    jmp ciclo_2

cant_3:
    mov ah,9
    mov dx, offset car3_ini
    int 21h
    jmp ciclo_3

cant_4:
    mov ah,9
    mov dx, offset car4_ini
    int 21h
    jmp ciclo_4

    Imp_num_c2:
        mov ah,9
        mov dx, offset imp_cart_00
        int 21h

        mov ah,9                        ;IMPRIMO NUM 1RA CARTA
        mov dx, offset di
        int 21h

        mov ah,9
        mov dx, offset imp_cart_01
        int 21h

        mov ah,9                        ;IMPRIMO NUM 2DA CARTA
        mov dx, offset si
        int 21h

        mov ah,9 
        mov dx, offset imp_cart_02
        int 21h
    loop ciclo_2

    ciclo_2:
        cmp cx, 6
        je Imp_num_c2

        mov ah, 9
        mov dx, offset car2_mid
        int 21h

        loop ciclo_2

        mov ah, 9
        mov dx, offset car2_fin
        int 21h

        jmp fin_imp
    
    Imp_num_c3:
        mov ah,9
        mov dx, offset imp_cart_000
        int 21h

        mov ah,9                        ;IMPRIMO NUM 1RA CARTA
        mov dx, ss:[bp+6]
        int 21h

        mov ah,9
        mov dx, offset imp_cart_001
        int 21h

        mov ah,9                        ;IMPRIMO NUM 2RA CARTA
        mov dx, ss:[bp+8]
        int 21h

        mov ah,2
        mov dx, ' '
        int 21h

        mov ah,9
        mov dx, offset imp_cart_001
        int 21h

        ;-------------------------------------------------------------
        pop di
        mov ah,9                        ;IMPRIMO NUM 3DA CARTA
        mov dx, offset di
        int 21h

        mov ah,9 
        mov dx, offset imp_cart_002
        int 21h

        loop ciclo_3

    ciclo_3:
        cmp cx, 6 
        je Imp_num_c3

        mov ah, 9
        mov dx, offset car3_mid
        int 21h

        loop ciclo_3

        mov ah, 9
        mov dx, offset car3_fin
        int 21h

        jmp fin_imp

    Imp_num_c4:
        mov ah,9
        mov dx, offset imp_cart_00
        int 21h

        mov ah,9                        ;IMPRIMO NUM 1RA CARTA
        mov dx, offset num_player_1
        int 21h

        mov ah,9
        mov dx, offset imp_cart_01
        int 21h

        mov ah,9                        ;IMPRIMO NUM 2RA CARTA
        mov dx, offset num_player_2
        int 21h

        mov ah,2
        mov dx, ' '
        int 21h

        mov ah,9
        mov dx, offset imp_cart_01
        int 21h

        mov ah,9                        ;IMPRIMO NUM 2RA CARTA
        mov dx, offset num_player_3
        int 21h

        mov ah,2
        mov dx, ' '
        int 21h

        mov ah,9
        mov dx, offset imp_cart_01
        int 21h

        mov ah,9                        ;IMPRIMO NUM 3DA CARTA
        mov dx, offset num_player_4
        int 21h

        mov ah,9 
        mov dx, offset imp_cart_02
        int 21h

    loop ciclo_4

    ciclo_4:
        cmp cx, 7
        je Imp_num_c4

        mov ah, 9
        mov dx, offset car4_mid
        int 21h

        loop ciclo_4

        mov ah, 9
        mov dx, offset car4_fin
        int 21h

        jmp fin_imp

    fin_imp:
        mov ah,2
        mov dx, ' '
        int 21h
    
    popf
    pop si
    pop di
    pop dx
    pop bx
    pop ax
    pop bp
    ret

Impr_carta endp
end