.8086
.model small
.stack 150h
;INTERRUPCION 80h
;Antes de ejecutar hay que escribir siguiente codigo en DOS para instalar INTERRUPCIÓN

extrn Start_Menu:proc
extrn salto:proc
extrn Impr_cont_player:proc
extrn user_suma:proc
extrn Impr_cont_comp:proc
extrn Impr_carta:proc
;extrn Generador_Carta:proc          ;al llamar la funcion por 2da vez te da el mismo aleatorio
extrn delay:proc
extrn copioVariable:proc 
extrn HitOrStand:proc
extrn computer_suma:proc
extrn Comparo_ambas_sumas:proc
extrn Acumulador_user_carta:proc
extrn Acumulador_comp_carta:proc 
;nuevas
extrn haceMazo:proc ;te hace el mazo y lo mezcla
extrn dameMazo:proc ;te da el mazo
extrn muevoValor:proc
extrn dameCarta:proc ;te muevo el valor de la carta a una variable, ascii

extrn regascii2:proc
extrn asciiareg:proc
.data
;CARTAS TOTALES JUGADAS Y MAZO DE CARTAS YA MEZCLADO
    carta db 'vvvv', 0dh, 0ah, 24h
    ncar db 0, 24h
    cartas db 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx'
    cartas2 db 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx'
    cartas3 db 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx'
    cartas4 db 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 'xxxx', 24h
;CARTAS Y COPIAS USER


    user_carta_1 db '00', 24h
    user_carta_2 db '00', 24h
    user_carta_3 db '00', 24h
    user_carta_4 db '00', 24h


;/CARTAS Y COPIAS USER

    comp_carta_1 db '00', 24h
    comp_carta_2 db '00', 24h
    comp_carta_3 db '00', 24h
    comp_carta_4 db '00', 24h

;/CARTAS Y COPIAS COMPUTER
    variablex db '009', 0dh, 0ah, 24h

    ganaste db  '                                                           GANASTE!', 0dh, 0ah, 24h
    perdiste db '                                                           PERDISTE!', 0dh, 0ah, 24h
    txt_gana_pc db '                                                           GANA PC ;)', 0dh, 0ah, 24h
    txt_pierde_pc db '                                                           PIERDE PC :(',0dh, 0ah, 24h
    txt_Pause db '                                               '
    txt_Pause2 db 'Continue <Spacebar>', 0dh, 0ah, 24h
.code


main proc
    mov ax, @data
    mov ds, ax
    
    int 80h
    call Start_Menu

    mov ah, 1
    int 21h

    cmp al, 20h     ;Si no presiona SPACE termina ejecución
    je continua
    
    mov ax,4c00h
    int 21h

continua:
    int 80h
;Hago el mazo
    call haceMazo
    lea si, cartas
;Traigo el mazo
    call dameMazo
;----------------------
;pido una carta
    xor dx, dx
    mov dl, ncar
    lea si, cartas
    add si, dx
    lea bx, carta
    call dameCarta
    add ncar, 4

;obtengo el valor de la carta
    lea si, carta
    lea bx, user_carta_1
    call muevoValor



;GENERO CARTA NRO 2
    call salto

    xor dx, dx
    mov dl, ncar
    lea si, cartas
    add si, dx
    lea bx, carta
    call dameCarta
    add ncar, 4

    lea si, carta
    lea bx, user_carta_2
    call muevoValor



    ;call generateRandomNumber2

    ;mov dl, user_carta_bit_2
    ;mov bx, offset user_carta_2
    ;call regascii2


;PREPARO VARIABLES PARA FUNCION USER_SUMA
;NUMERO DE CARTAS DEL JUGADOR QUE VA A SUMAR
    mov cx,2                      
    mov bx, offset user_carta_1
    ;push bx
    mov di, offset user_carta_2
    ;push di
    call user_suma
    ;pop di ;? 
    ;pop bx ;? 

    push cx                         ;GUARDO EN STACK EL VALOR QUE DEVUELVE USER_SUMA
;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
;NUMERO DE CARTAS DEL JUGADOR
    mov bx, 2                       
    mov di, offset user_carta_1; aca iba cop
    mov si, offset user_carta_2; aca iba cop
    push di
    push si
    call Impr_carta
    ;pop si
    ;pop di
;SE HABRA PASADO?, si se paso cl deberia estar en 1
    pop cx                          ;PIDO AL STACK EL VALOR DE CL
    cmp cl,1
    je Pierdo ;; nunca se pasa en la primera xq lo maximo q puede sumar es 21, si tocaran 2 ases seria 12
    cmp cl,3
    je Gano
    jmp Opc_Hit_Stand
Gano:
    mov ah,9
    mov dx, offset ganaste
    int 21h

    mov ax, 4c00h
    int 21h
Pierdo:
    mov ah,9
    mov dx, offset perdiste
    int 21h

    mov ax, 4c00h
    int 21h

;OPCION HIT OR STAND PARA PASAR AL SEGUNDO TURNO O AL TURNO DE LA COMPUTADORA
Opc_Hit_Stand:
    call HitOrStand
    cmp cl, 0
    je pideCarta
    ;                                           #  FALTA PROGRAMAR LA OPCION PARA PLANTAR #
    ;cmp cl,1
    ;je planta1

pideCarta:
    ; G E N E R A C I O N   C A R T A S   PC #1
    ;Antes de que se genere la 3ra carta se tendra que imprimir las 2 cartas de la PC
    
    ;GENERO CARTA NRO 1 COMPUTADORA
    xor dx, dx
    mov dl, ncar
    lea si, cartas
    add si, dx
    lea bx, carta
    call dameCarta
    add ncar, 4

    lea si, carta
    lea bx, comp_carta_1
    call muevoValor

    ;GENERO CARTA NRO 2 COMPUTADORA
    call salto

    xor dx, dx
    mov dl, ncar
    lea si, cartas
    add si, dx
    lea bx, carta
    call dameCarta
    add ncar, 4

    lea si, carta
    lea bx, comp_carta_2
    call muevoValor
    
    ;NUMERO DE CARTAS DE LA PC QUE VA A SUMAR
    mov cx,2                      
    mov bx, offset comp_carta_1
    push bx
    mov di, offset comp_carta_2
    push di
    call computer_suma
    pop di
    pop bx

    push cx                         ;GUARDO EN STACK EL VALOR QUE DEVUELVE USER_SUMA

;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
;NUMERO DE CARTAS DE LA COMPUTADORA
    mov bx, 2                       
    mov di, offset comp_carta_1
    mov si, offset comp_carta_2
    push di
    push si
    call Impr_carta
    pop di
    pop si
;SE HABRA PASADO?, si se paso cl deberia estar en 1
    pop cx                          ;PIDO AL STACK EL VALOR DE CL
    cmp cl,1
    je PierdePC
    cmp cl,3
    je GanaPC
    jmp ContinuaPC
GanaPC:
    mov ah,9
    mov dx, offset perdiste
    int 21h

    mov ax, 4c00h
    int 21h
PierdePC:
    mov ah,9
    mov dx, offset ganaste
    int 21h

    mov ax, 4c00h
    int 21h
ContinuaPC:
    ;PAUSO HASTA QUE EL USUARIO PRESIONE ESPACIO PARA CONTINUAR EL TURNO DE LA PC
    mov ah,9
    mov dx, offset txt_Pause
    int 21h

    cicloPausa:
    mov ah,1
    int 21h

    cmp al, 20h
    je Generacion_3             ;EMPIEZO CON EL SEGUNDO TURNO
    jmp cicloPausa
    
    ;SEGUNDO TURNO, se le dara una carta más y se la sumará.
    ;Si es mayor a 21 pierde
    ;Si es menor a 21 tiene la opción de hit o stand
    Generacion_3:
    int 80h
    ;GENERO CARTA NRO 3
    ;753
    xor dx, dx
    mov dl, ncar
    lea si, cartas
    add si, dx
    lea bx, carta
    call dameCarta
    add ncar, 4

    lea si, carta
    lea bx, user_carta_3
    call muevoValor
    ;/GENERO CARTA NRO 3
    ;COPIO VARIABLE PORQUE USER_CARTA_3 SE ROMPE EN ACUMULADOR_USER_CARTA
    call salto          

    mov bx, offset user_carta_3
    call Acumulador_user_carta
    push cx
;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
;NUMERO DE CARTAS DEL JUGADOR
    mov bx,3
    mov di, offset user_carta_1
    push di
    mov si, offset user_carta_2
    push si
    mov dx, offset user_carta_3; _cop
    push dx
    call Impr_carta
    pop dx
    pop si
    pop di
;SE HABRA PASADO?, si se paso cl deberia estar en 1
    pop cx                          ;PIDO AL STACK EL VALOR DE CL
    cmp cl, 1
    je Pierdo2
    cmp cl, 3
    je Gano2
    jmp Opc_Hit_Stand2
;planta1:                           ; # FALTA IMPLEMENTAR STAND
    ;je planta2
Gano2:
    mov ah,9
    mov dx, offset ganaste
    int 21h

    mov ax, 4c00h ;; hay q hacer q salte al fin y no agregar fines a lo loco
    int 21h
Pierdo2:
    mov ah,9
    mov dx, offset perdiste
    int 21h

    mov ax, 4c00h
    int 21h
;OPCION HIT OR STAND PARA PASAR AL SEGUNDO TURNO O AL TURNO DE LA COMPUTADORA
Opc_Hit_Stand2:
    call HitOrStand
    cmp cl, 0
    je pideCarta2
;planta2:                                                   #FALTA IMPLEMENTAR STAND
    ;cmp cl,1
    ;je planta3
pideCarta2:
    ; G E N E R A C I O N   C A R T A S   PC #2
    ;antes de que se genera la 4ta carta del usuario tendre que mostrar la 3ra carta de la pc
    ;GENERO CARTA NRO 3 COMPUTADORA
    xor dx, dx
    mov dl, ncar
    lea si, cartas
    add si, dx
    lea bx, carta
    call dameCarta
    add ncar, 4

    lea si, carta
    lea bx, comp_carta_3
    call muevoValor
    ;/GENERO CARTA NRO 3 COMPUTADORA
    ;COPIO VARIABLE PORQUE USER_CARTA_3 SE ROMPE EN ACUMULADOR_COMP_CARTA
    call salto

    mov bx, offset comp_carta_3
    call Acumulador_comp_carta
    push cx 

;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
;NUMERO DE CARTAS DE LA COMPUTADORA
    mov bx,3
    mov di, offset comp_carta_1;_cop
    push di
    mov si, offset comp_carta_2;_cop
    push si
    mov dx, offset comp_carta_3;_cop
    push dx
    call Impr_carta
    pop dx
    pop si
    pop di
;SE HABRA PASADO?, si se paso cl deberia estar en 1
    pop cx                          ;PIDO AL STACK EL VALOR DE CL
    cmp cl, 1
    je PierdePC2
    cmp cl, 3
    je GanaPC2
    jmp ContinuaPC2
GanaPC2:
    mov ah,9
    mov dx, offset perdiste
    int 21h
    mov ax, 4c00h
    int 21h
PierdePC2:
    mov ah,9
    mov dx, offset ganaste
    int 21h
    mov ax, 4c00h
    int 21h
;---------------- F-I-N-A-L-I-Z-A    S-E-G-U-N-D-O    T-U-R-N-O    PC ---------------- 
ContinuaPC2:
    ;PAUSO HASTA QUE EL USUARIO PRESIONE ESPACIO PARA CONTINUAR EL TURNO DE LA PC
    mov ah,9
    mov dx, offset txt_Pause
    int 21h

    cicloPausa2:
        mov ah,1
        int 21h

        cmp al, 20h
        je Generacion_4
    jmp cicloPausa2

    ;TERCER TURNO se la dara una carta más y se la sumará
    ;Si es mayor a 21 pierde
    ;Si es menor a 21 tiene la opción de hit o stand
    Generacion_4:
    int 80h
    call salto
    ;GENERO CARTA NRO 4
    xor dx, dx
    mov dl, ncar
    lea si, cartas
    add si, dx
    lea bx, carta
    call dameCarta
    add ncar, 4

    lea si, carta
    lea bx, user_carta_4
    call muevoValor
    
    ;/GENERO CARTA NRO 4


    mov bx, offset user_carta_4
    call Acumulador_user_carta
    push cx
;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
    mov di, offset user_carta_1;_cop
    push di
    mov si, offset user_carta_2;_cop
    push si
    mov dx, offset user_carta_3;_cop
    push dx
    mov bx, offset user_carta_4;_cop2
    push bx
    mov bx,4
    call Impr_carta
    pop bx
    pop dx
    pop si
    pop di
;SE HABRA PASADO?, si se paso cl deberia estar en 1
    pop cx                          ;PIDO AL STACK EL VALOR DE CL
    cmp cl,1
    je Pierdo3
    cmp cl,3
    je Gano3
    ;Si no es ninguno de esos 2 valores de arriba entonces ...
    mov ah, 9
    mov dx, offset txt_Pause
    int 21h

    cicloPausa3:
        mov ah, 1
        int 21h

        cmp al, 20h
        je ContinuaPC4           
    jmp cicloPausa3

;planta3:                       ; # FALTA IMPLEMENTAR STAND
;    jmp TurnoPC
;-----------------------------------
Gano3:
    mov ah,9
    mov dx, offset ganaste
    int 21h
    mov ax, 4c00h
    int 21h
Pierdo3:
    mov ah,9
    mov dx, offset perdiste
    int 21h
    mov ax, 4c00h
    int 21h  
;-----------------------------------
ContinuaPC4:
    ; G E N E R A C I O N   C A R T A S   PC #4
    call salto

    xor dx, dx
    mov dl, ncar
    lea si, cartas
    add si, dx
    lea bx, carta
    call dameCarta
    add ncar, 4

    lea si, carta
    lea bx, comp_carta_4
    call muevoValor

    mov bx, offset comp_carta_4
    call Acumulador_comp_carta
    push cx

;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
    mov di, offset comp_carta_1;_cop
    push di
    mov si, offset comp_carta_2;_cop
    push si
    mov dx, offset comp_carta_3;_cop
    push dx
    mov bx, offset comp_carta_4;_cop2
    push bx

    mov bx,4

    call Impr_carta
    pop bx
    pop dx
    pop si
    pop di
;SE HABRA PASADO?, si se paso cl deberia estar en 1
    pop cx                          ;PIDO AL STACK EL VALOR DE CL
    cmp cl,3
    je GanaPC3
    
    cmp cl,1
    je PierdePC3    

    jmp FinalizaPC
GanaPC3:
    ;SI SALTA AQUI ES PORQUE ES IGUAL A 21
    mov ah, 9
    mov dx, offset txt_gana_pc
    int 21h
    
    mov ax, 4c00h
    int 21h
PierdePC3:
    ;SI SALTA AQUI ES POR QUE ES MAYOR A 21
    mov ah, 9
    mov dx, offset txt_pierde_pc
    int 21h

    mov ax, 4c00h
    int 21h

FinalizaPC:
    call Comparo_ambas_sumas
    
    mov ax, 4c00h
    int 21h

main endp
end main