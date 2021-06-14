.8086
.model small
.stack 100h
;INTERRUPCION 80h
;Antes de ejecutar hay que escribir siguiente codigo en DOS para instalar INTERRUPCIÓN

extrn Start_Menu:proc
extrn salto:proc
extrn Impr_cont_player:proc
extrn user_suma:proc
extrn Impr_cont_comp:proc
extrn Impr_carta:proc
extrn Generador_Carta:proc          ;al llamar la funcion por 2da vez te da el mismo aleatorio
extrn delay:proc
extrn copioVariable:proc 
extrn HitOrStand:proc

extrn regascii2:proc
extrn asciiareg:proc
.data
    user_carta_bit_1 db 0, 0dh, 0ah, 24h
    user_carta_bit_2 db 0, 0dh, 0ah, 24h
    user_carta_bit_3 db 0, 0dh, 0ah, 24h
    user_carta_bit_4 db 0, 0dh, 0ah, 24h

    user_carta_1 db '0', 0dh, 0ah, 24h
    user_carta_2 db '0', 0dh, 0ah, 24h
    user_carta_3 db '0', 0dh, 0ah, 24h
    user_carta_4 db '0', 0dh, 0ah, 24h

;CARTAS Y COPIAS
    user_carta_1_cop db '0', 0dh, 0ah, 24h
    user_carta_2_cop db '0', 0dh, 0ah, 24h
    user_carta_3_cop db '0', 0dh, 0ah, 24h
    user_carta_4_cop db '0', 0dh, 0ah, 24h

    user_carta_1_cop2 db '0', 0dh, 0ah, 24h
    user_carta_2_cop2 db '0', 0dh, 0ah, 24h
    user_carta_3_cop2 db '0', 0dh, 0ah, 24h
    user_carta_4_cop2 db '0', 0dh, 0ah, 24h

    user_carta_1_cop3 db '0', 0dh, 0ah, 24h
    user_carta_2_cop3 db '0', 0dh, 0ah, 24h
    user_carta_3_cop3 db '0', 0dh, 0ah, 24h
    user_carta_4_cop3 db '0', 0dh, 0ah, 24h
;/CARTAS Y COPIAS

    comp_carta_bit_1 db 0, 0dh, 0ah, 24h
    comp_carta_bit_2 db 0, 0dh, 0ah, 24h
    comp_carta_bit_3 db 0, 0dh, 0ah, 24h
    comp_carta_bit_4 db 0, 0dh, 0ah, 24h

    comp_carta_1 db '0', 0dh, 0ah, 24h
    comp_carta_2 db '0', 0dh, 0ah, 24h
    comp_carta_3 db '0', 0dh, 0ah, 24h
    comp_carta_4 db '0', 0dh, 0ah, 24h

    comp_carta_1_cop db '0', 0dh, 0ah, 24h
    comp_carta_2_cop db '0', 0dh, 0ah, 24h
    comp_carta_3_cop db '0', 0dh, 0ah, 24h
    comp_carta_4_cop db '0', 0dh, 0ah, 24h

    variablex db '009', 0dh, 0ah, 24h

    ganaste db  '                                                           GANASTE!', 0dh, 0ah, 24h
    perdiste db '                                                           PERDISTE!', 0dh, 0ah, 24h
.code

;FUNCION CREADA POR ERROR AL GENERAR CARTA NRO 2
generateRandomNumber2 proc
    push ax
    push bx
    push dx

    mov ah,0        
    int 1ah

    mov ax, dx
    mov dx,1                ;CAMBIE EL DX A 1 para que de distinto a la primera carta
    mov bx,10
    div bx

    mov user_carta_bit_2, dl   ;agarra el divisor de 'dl' y guarda en la variable randomNum

    pop dx
    pop bx
    pop ax
    ret 
generateRandomNumber2 endp

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
;GENERO CARTA NRO 1
    mov di, offset user_carta_bit_1       ;Paso offset en donde quiero que guarde la carta
    push di
    call Generador_Carta
    pop di

    mov dl, user_carta_bit_1
    mov bx, offset user_carta_1
    call regascii2

;GENERO CARTA NRO 2
    call salto
    call generateRandomNumber2

    mov dl, user_carta_bit_2
    mov bx, offset user_carta_2
    call regascii2

;GUARDO EL VALOR DE LAS CARTAS EN OTRA VARIABLE POR ERROR DE SOBRE ESCRITURA
;ERROR DE SOBRE ESCRITURA EN FUNCIÓN USER_SUMA borra el contenido del offset que le pasas
    mov dx, offset user_carta_1
    mov bx, offset user_carta_1_cop
    call copioVariable

    mov dx, offset user_carta_2
    mov bx, offset user_carta_2_cop
    call copioVariable

;PREPARO VARIABLES PARA FUNCION USER_SUMA
;NUMERO DE CARTAS DEL JUGADOR QUE VA A SUMAR
    mov cx,2                      
    mov bx, offset user_carta_1
    push bx
    mov di, offset user_carta_2
    push di
    call user_suma
    pop di
    pop bx

    push cx                         ;GUARDO EN STACK EL VALOR QUE DEVUELVE USER_SUMA
;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
;NUMERO DE CARTAS DEL JUGADOR
    mov bx, 2                       
    mov di, offset user_carta_1_cop
    mov si, offset user_carta_2_cop
    push di
    push si
    call Impr_carta
    pop di
    pop si
;SE HABRA PASADO?, si se paso cl deberia estar en 1
    pop cx                          ;PIDO AL STACK EL VALOR DE CL
    cmp cl,1
    je Pierdo
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
    cmp cl,1
    je planta1

pideCarta:
    int 80h                                 ;LIMPIO PANTALLA
    ;SEGUNDO TURNO, se le dara una carta más y se la sumará.
    ;Si es mayor a 21 pierde
    ;Si es menor a 21 tiene la opción de hit o stand
    ;GENERO CARTA NRO 3
    mov di, offset user_carta_bit_3       ;Paso offset en donde quiero que guarde la carta
    push di
    call Generador_Carta
    pop di

    mov dl, user_carta_bit_3
    mov bx, offset user_carta_3
    call regascii2             

;GUARDO EL VALOR DE LAS CARTAS EN OTRA VARIABLE POR ERROR DE SOBRE ESCRITURA
;ERROR DE SOBRE ESCRITURA EN FUNCIÓN USER_SUMA borra el contenido del offset que le pasas
    mov dx, offset user_carta_1_cop
    mov bx, offset user_carta_1_cop2
    call copioVariable

    mov dx, offset user_carta_2_cop
    mov bx, offset user_carta_2_cop2
    call copioVariable

    mov dx, offset user_carta_3
    mov bx, offset user_carta_3_cop
    call copioVariable

;PREPARO VARIABLES PARA FUNCION USER_SUMA
;NUMERO DE CARTAS DEL JUGADOR QUE VA A SUMAR
    call salto
    mov cx,3
    mov bx, offset user_carta_1_cop    ;uso variables copia por que las originales estan rotas
    mov di, offset user_carta_2_cop    ;uso variables copia por que las originales estan rotas
    mov si, offset user_carta_3
    push bx
    push di    
    push si
    call user_suma
    pop si
    pop di
    pop bx

    push cx                         ;GUARDO EN STACK EL VALOR QUE DEVUELVE USER_SUMA
;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
;NUMERO DE CARTAS DEL JUGADOR
    mov bx,3
    mov di, offset user_carta_1_cop2
    push di
    mov si, offset user_carta_2_cop2
    push si
    mov dx, offset user_carta_3_cop
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
planta1:
    je planta2
Gano2:
    mov ah,9
    mov dx, offset ganaste
    int 21h

    mov ax, 4c00h
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
planta2:
    cmp cl,1
    je planta3
pideCarta2:
    int 80h
    ;TERCER TURNO se la dara una carta más y se la sumará
    ;Si es mayor a 21 pierde
    ;Si es menor a 21 tiene la opción de hit o stand
    ;GENERO CARTA NRO 4
    mov di, offset user_carta_bit_4       ;Paso offset en donde quiero que guarde la carta
    push di
    call Generador_Carta
    pop di

    mov dl, user_carta_bit_4
    mov bx, offset user_carta_4
    call regascii2  
;GUARDO EL VALOR DE LAS CARTAS EN OTRA VARIABLE POR ERROR DE SOBRE ESCRITURA
;ERROR DE SOBRE ESCRITURA EN FUNCIÓN USER_SUMA borra el contenido del offset que le pasas
    mov dx, offset user_carta_1_cop2
    mov bx, offset user_carta_1_cop3
    call copioVariable

    mov dx, offset user_carta_2_cop2
    mov bx, offset user_carta_2_cop3
    call copioVariable

    mov dx, offset user_carta_3_cop
    mov bx, offset user_carta_3_cop3                ;user_carta_3_cop2 libre
    call copioVariable
    
    mov dx, offset user_carta_4
    mov bx, offset user_carta_4_cop3                ;user_carta_4_cop2 libre
    call copioVariable
;PREPARO VARIABLES PARA FUNCION USER_SUMA
;NUMERO DE CARTAS DEL JUGADOR QUE VA A SUMAR
    call salto
    mov cx,4
    mov bx, offset user_carta_1_cop3    ;uso variables copia por que las originales estan rotas
    push bx
    mov di, offset user_carta_2_cop3    ;uso variables copia por que las originales estan rotas
    push di 
    mov si, offset user_carta_3_cop3
    push si
    mov dx, offset user_carta_4_cop3
    push dx
    call user_suma
    pop dx
    pop si
    pop di
    pop bx
    
    push cx                         ;GUARDO EN STACK EL VALOR QUE DEVUELVE USER_SUMA
;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
    mov di, offset user_carta_1_cop2
    push di
    mov si, offset user_carta_2_cop2
    push si
    mov dx, offset user_carta_3_cop
    push dx
    mov bx, offset user_carta_4
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
planta3:
    jmp planta4
Gano3:
    mov ah,9
    mov dx, offset ganaste
    int 21h
    jmp fin
Pierdo3:
    mov ah,9
    mov dx, offset perdiste
    int 21h

    jmp fin
    
planta4:
    call salto
    ;call Impr_cont_comp
    ;mov bx, offset user_carta_1_cop
    ;mov di, offset user_carta_2_cop
    ;push bx
    ;push di
    ;call Impr_carta
    ;pop di
    ;pop bx

fin:
    mov ax, 4c00h
    int 21h

main endp
end main