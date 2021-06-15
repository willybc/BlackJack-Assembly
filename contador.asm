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
    comp_suma_01 db '0', 0dh, 0ah, 24h

    txt_user_gana db 'User Win!', 0dh, 0ah, 24h
    txt_comp_gana db 'Computer Win!', 0dh, 0ah, 24h
    txt_empate db '                                                           EMPATE :/', 0dh, 0ah, 24h

.code
public Impr_cont_player
public Impr_cont_comp
public user_suma
public computer_suma
public Comparo_ambas_sumas
public Acumulador_user_carta

extrn salto:proc
extrn regascii2:proc
extrn asciiareg:proc

user_suma proc
    push bp
    mov bp, sp

    push ax
    push bx
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
    xor cx,cx
    sePaso?:
    cmp dh, 21
    je ganaste
    jg perdiste
    jmp nosePaso
nosePaso:
    mov cl,0                        ; SI ES MENOR A 21, DEVUELVE 0
    jmp empiezoConvertir 
perdiste:
    mov cl,1                        ; SI ES MAYOR A 21, DEVUELVE 1
    jmp empiezoConvertir
ganaste:
    mov cl, 3                       ; SI ES IGUAL A 21, DEVUELVE 3
    jmp empiezoConvertir
   
empiezoConvertir:
    push cx                         ; GUARDO EN STACK VALOR CL                  
    mov bx, offset user_suma_01
    call regascii2                  ; RECIBE EN DX EL REG Y EN BX OFFSET PARA GUARDARLO

    mov bx, offset user_suma_01
    call Impr_cont_player

    pop cx                          ; PIDO A STACK EL VALOR DE CL
    popf
    pop si
    pop dx
    pop bx
    pop ax
    pop bp
    ret
user_suma endp

Acumulador_user_carta proc
    push bx
    push dx
    pushf    
    mov dx, offset bx
    call asciiareg
    mov dl,cl
    push dx
    
    mov dx, offset user_suma_01
    call asciiareg
    pop dx

    ;REG CL SUMA ANTERIOR
    ;REG DL VALOR DE VALOR RECIBIDO
    add dl, cl
;HAGO COMPARACION SI PERDIO, GANO O SIGUE JUGANDO
    xor cx,cx
    cmp dl, 21
    je ganaste1
    jg perdiste1
    jmp nosePaso1
nosePaso1:
    mov cl,0                        ; SI ES MENOR A 21, DEVUELVE 0
    jmp ConviertoeImprimo 
perdiste1:
    mov cl,1                        ; SI ES MAYOR A 21, DEVUELVE 1
    jmp ConviertoeImprimo
ganaste1:
    mov cl, 3                       ; SI ES IGUAL A 21, DEVUELVE 3
    jmp ConviertoeImprimo
   
ConviertoeImprimo:
    push cx  
    mov bx, offset user_suma_01
    call regascii2

    mov bx, offset user_suma_01
    call Impr_cont_player

    pop cx
    popf
    pop dx
    pop bx
    ret
Acumulador_user_carta endp

computer_suma proc
    push bp
    mov bp, sp

    push ax
    push bx
    push dx
    push si
    pushf

    cmp cx,2
    je Sumoc2

    cmp cx,3
    je Sumoc3

    cmp cx,4
    je Sumoc4

Sumoc2:
    mov dx, ss:[bp+4]                   ;SUMO CARTA 1
    call asciiareg
    mov dl, cl
    push dx

    mov dx, ss:[bp+6]                   ;SUMO CARTA 2
    call asciiareg
    pop dx
    add dl, cl
    mov dh, dl
    jmp ConviertoC

Sumoc3:
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
    jmp ConviertoC

Sumoc4:
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
    jmp ConviertoC

ConviertoC:
    xor cx,cx
sePasoC?:
    cmp dh, 21
    je ganasteC
    jg perdisteC
    jmp nosePasoC
nosePasoC:
    mov cl,0                        ; SI ES MENOR A 21, DEVUELVE 0
    jmp empiezoConvertirC
perdisteC:
    mov cl,1                        ; SI ES MAYOR A 21, DEVUELVE 1
    jmp empiezoConvertirC
ganasteC:
    mov cl, 3                       ; SI ES IGUAL A 21, DEVUELVE 3
    jmp empiezoConvertirC
   
empiezoConvertirC:
    push cx                         ; GUARDO EN STACK VALOR CL                  
    mov bx, offset comp_suma_01
    call regascii2                  ; RECIBE EN DX EL REG Y EN BX OFFSET PARA GUARDARLO

    mov bx, offset comp_suma_01
    call Impr_cont_comp

    pop cx                          ; PIDO A STACK EL VALOR DE CL
    popf
    pop si
    pop dx
    pop bx
    pop ax
    pop bp
    ret
computer_suma endp

Comparo_ambas_sumas proc
    push ax
    push dx
    push cx
    pushf

    mov dx, offset user_suma_01         ;GUARDO EL OFFSET EN DX
    call asciiareg                      ;REG EN CL
    mov dl,cl
    push dx

    mov dx, offset comp_suma_01         ;GUARDO EL OFFSET EN DX
    call asciiareg                      ;REG EN CL
    pop dx
    
    ;VALOR DE USER_SUMA_01 EN DL
    ;VALOR DE COMP_SUMA_01 EN CL
Comparo_sumas:
    cmp dl, cl
    ja usuario_gana             ;SI ES SUPERIOR USUARIO GANA
    je nadie_gana               ;SI SON IGUALES EMPATAN
    jb computadora_gana         ;SI ES INFERIOR COMPUTADORA GANA
    jmp fin_comparacion

usuario_gana:
    mov ah,9
    mov dx, offset txt_user_gana
    int 21h
    jmp fin_comparacion

nadie_gana:
    mov ah,9
    mov dx, offset txt_empate
    int 21h
    jmp fin_comparacion

computadora_gana:
    mov ah,9
    mov dx, offset txt_comp_gana
    int 21h
    jmp fin_comparacion 

fin_comparacion:
    popf
    pop cx
    pop dx
    pop ax
    ret
Comparo_ambas_sumas endp

Impr_cont_player proc
    ;TXT SUMA DE CARTAS DE JUGADOR
    push ax
    push bx
    push dx

    mov ah,9
    mov dx, offset player_txt1
    int 21h

    mov ah,9
    mov dx, offset user_suma_01
    int 21h

    mov ah,9
    mov dx, offset player_txt2
    int 21h

    pop dx
    pop bx
    pop ax
    ;/TXT SUMA DE CARTAS DE JUGADOR
    ret
Impr_cont_player endp

Impr_cont_comp proc
    ;TXT SUMA DE CARTAS DE COMPUTADORA
    push ax
    push dx
    
    mov ah,9
    mov dx, offset comp_txt1
    int 21h

    mov ah,9
    mov dx, offset bx
    int 21h

    mov ah,9
    mov dx, offset comp_txt2
    int 21h

    pop dx
    pop ax
    ;/TXT SUMA DE CARTAS DE COMPUTADORA
    ret
Impr_cont_comp endp

end