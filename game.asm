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
extrn computer_suma:proc
extrn Comparo_ambas_sumas:proc
extrn Acumulador_user_carta:proc
extrn Acumulador_comp_carta:proc 

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

;CARTAS Y COPIAS USER
    user_carta_1_cop db '0', 0dh, 0ah, 24h
    user_carta_2_cop db '0', 0dh, 0ah, 24h
    user_carta_3_cop db '0', 0dh, 0ah, 24h
    user_carta_4_cop db '0', 0dh, 0ah, 24h    
    user_carta_4_cop2 db '0', 0dh, 0ah, 24h
;/CARTAS Y COPIAS USER

    comp_carta_bit_1 db 0, 0dh, 0ah, 24h
    comp_carta_bit_2 db 0, 0dh, 0ah, 24h
    comp_carta_bit_3 db 0, 0dh, 0ah, 24h
    comp_carta_bit_4 db 0, 0dh, 0ah, 24h

    comp_carta_1 db '0', 0dh, 0ah, 24h
    comp_carta_2 db '0', 0dh, 0ah, 24h
    comp_carta_3 db '0', 0dh, 0ah, 24h
    comp_carta_4 db '0', 0dh, 0ah, 24h

;CARTAS Y COPIAS COMPUTER
    comp_carta_1_cop db '0', 0dh, 0ah, 24h
    comp_carta_2_cop db '0', 0dh, 0ah, 24h
    comp_carta_3_cop db '0', 0dh, 0ah, 24h
    comp_carta_4_cop db '0', 0dh, 0ah, 24h
    comp_carta_4_cop2 db '0', 0dh, 0ah, 24h
;/CARTAS Y COPIAS COMPUTER
    variablex db '009', 0dh, 0ah, 24h

    ganaste db  '                                                           GANASTE!', 0dh, 0ah, 24h
    perdiste db '                                                           PERDISTE!', 0dh, 0ah, 24h
    txt_gana_pc db '                                                           GANA PC ;)', 0dh, 0ah, 24h
    txt_pierde_pc db '                                                           PIERDE PC :(',0dh, 0ah, 24h
    txt_Pause db '                                               '
    txt_Pause2 db 'Continue <Spacebar>', 0dh, 0ah, 24h
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

generateRandomNumber3 proc
    push ax
    push bx
    push dx

    mov ah,0        
    int 1ah

    mov ax, dx
    mov dx,1                ;CAMBIE EL DX A 1 para que de distinto a la primera carta
    mov bx,10
    div bx

    mov comp_carta_bit_2, dl   ;agarra el divisor de 'dl' y guarda en la variable randomNum

    pop dx
    pop bx
    pop ax
    ret 
generateRandomNumber3 endp

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
    ;FALTA PROGRAMAR LA OPCION PARA PLANTAR
    ;cmp cl,1
    ;je planta01
    
pideCarta:
    ; G E N E R A C I O N   C A R T A S   PC #1
    ;Antes de que se genere la 3ra carta se tendra que imprimir las 2 cartas de la PC
    
    ;GENERO CARTA NRO 1 COMPUTADORA
    mov di, offset comp_carta_bit_1
    push di
    call Generador_Carta
    pop di

    mov dl, comp_carta_bit_1
    mov bx, offset comp_carta_1
    call regascii2

    call salto
    call generateRandomNumber3

    mov dl, comp_carta_bit_2
    mov bx, offset comp_carta_2
    call regascii2

    ;GUARDO EL VALOR DE LAS CARTAS EN OTRA VARIABLE POR ERROR DE SOBRE ESCRITURA
    ;ERROR DE SOBRE ESCRITURA EN FUNCIÓN USER_SUMA borra el contenido del offset que le pasas
    mov dx, offset comp_carta_1
    mov bx, offset comp_carta_1_cop
    call copioVariable

    mov dx, offset comp_carta_2
    mov bx, offset comp_carta_2_cop
    call copioVariable
    ;PREPARO VARIABLES PARA FUNCION USER_SUMA
    ;NUMERO DE CARTAS DEL JUGADOR QUE VA A SUMAR
    mov cx,2                      
    mov bx, offset comp_carta_1
    push bx
    mov di, offset comp_carta_2
    push di
    call computer_suma
    pop di
    pop bx

    push cx                         ;GUARDO EN STACK EL VALOR QUE DEVUELVE USER_SUMA
    jmp Impresion_cartas_pc

    ;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
    ;NUMERO DE CARTAS DE LA COMPUTADORA
    Impresion_cartas_pc:
    mov bx, 2                       
    mov di, offset comp_carta_1_cop
    mov si, offset comp_carta_2_cop
    push di
    push si
    call Impr_carta
    pop di
    pop si
    ;SE HABRA PASADO?, si se paso cl deberia estar en 1
    pop cx                          ;PIDO AL STACK EL VALOR DE CL

    ;ME FIJO SI GANO, PERDIO O SI CONTINUA JUGANDO LA PC
    cmp cl, 1
    je PierdePC
    cmp cl, 3
    je GanaPC
    jmp ContinuaPC
GanaPC:
    mov ah,9
    mov dx, offset perdiste
    int 21h
    mov ax, 4c00h
    int 21h

PierdePC:
    mov ah, 9
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
    je Generacion_3         ;EMPIEZO CON EL SEGUNDO TURNO
    jmp cicloPausa

    ;SEGUNDO TURNO, se le dara una carta más y se la sumará.
    ;Si es mayor a 21 pierde
    ;Si es menor a 21 tiene la opción de hit o stand
    Generacion_3:
    ;GENERO CARTA NRO 3
    int 80h                               ;LIMPIO PANTALLA  
    mov di, offset user_carta_bit_3       ;Paso offset en donde quiero que guarde la carta
    push di
    call Generador_Carta
    pop di
    mov dl, user_carta_bit_3
    mov bx, offset user_carta_3
    call regascii2
    ;/GENERO CARTA NRO 3
    ;COPIO VARIABLE PORQUE USER_CARTA_3 SE ROMPE EN ACUMULADOR_USER_CARTA
    call salto
    mov dx, offset user_carta_3
    mov bx, offset user_carta_3_cop
    call copioVariable             

    mov bx, offset user_carta_3
    call Acumulador_user_carta
    push cx
;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
;NUMERO DE CARTAS DEL JUGADOR
    mov bx,3
    mov di, offset user_carta_1_cop
    push di
    mov si, offset user_carta_2_cop
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
;planta1:
    ;je planta2
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
;OPCION HIT OR STAND PARA PASAR AL TERCER TURNO O AL TURNO DE LA COMPUTADORA
Opc_Hit_Stand2:
    call HitOrStand
    cmp cl, 0
    je pideCarta2
;planta2:
    ;cmp cl,1
    ;je planta3

pideCarta2:
    ; G E N E R A C I O N   C A R T A S   PC #2
    ;antes de que se genera la 4ta carta del usuario tendre que mostrar la 3ra carta de la pc
    mov di, offset comp_carta_bit_3       ;Paso offset en donde quiero que guarde la carta
    push di
    call Generador_Carta
    pop di

    mov dl, comp_carta_bit_3
    mov bx, offset comp_carta_3
    call regascii2   
    ;/GENERO CARTA NRO 3 COMPUTADORA
    ;COPIO VARIABLE PORQUE USER_CARTA_3 SE ROMPE EN ACUMULADOR_COMP_CARTA
    call salto
    mov dx, offset comp_carta_3
    mov bx, offset comp_carta_3_cop
    call copioVariable   

    mov bx, offset comp_carta_3
    call Acumulador_comp_carta
    push cx 

;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
;NUMERO DE CARTAS DE LA COMPUTADORA
    mov bx,3
    mov di, offset comp_carta_1_cop
    push di
    mov si, offset comp_carta_2_cop
    push si
    mov dx, offset comp_carta_3_cop
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

ContinuaPC2:
    ;PAUSO HASTA QUE EL USUARIO PRESIONE ESPACIO PARA CONTINUAR EL TURNO DE LA PC
    mov ah,9
    mov dx, offset txt_Pause
    int 21h

    cicloPausa2:
    mov ah, 1
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
    mov di, offset user_carta_bit_4       ;Paso offset en donde quiero que guarde la carta
    push di
    call Generador_Carta
    pop di

    mov dl, user_carta_bit_4
    mov bx, offset user_carta_4
    call regascii2  
    ;/GENERO CARTA NRO 4
;COPIO VARIABLE PORQUE USER_CARTA_4 SE ROMPE EN ACUMULADOR_USER_CARTA        
    mov dx, offset user_carta_4
    mov bx, offset user_carta_4_cop2    ;user_carta_4_cop NO FUNCIONA SE ROMPE PROGRAMA                
    call copioVariable

    mov bx, offset user_carta_4
    call Acumulador_user_carta
    push cx
;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
    mov di, offset user_carta_1_cop
    push di
    mov si, offset user_carta_2_cop
    push si
    mov dx, offset user_carta_3_cop
    push dx
    mov bx, offset user_carta_4_cop2
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
    jmp ContinuaPC3
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

ContinuaPC3:
    ;PAUSO HASTA QUE EL USUARIO PRESIONE ESPACIO PARA CONTINUAR EL TURNO DE LA PC
    mov ah,9
    mov dx, offset txt_Pause
    int 21h

    cicloPausa3:
    mov ah,1
    int 21h

    cmp al, 20h
    je ContinuaPC4         ;EMPIEZO CON EL SEGUNDO TURNO
    jmp cicloPausa3

ContinuaPC4:
    ; G E N E R A C I O N   C A R T A S   PC #4
    call salto
    mov di, offset comp_carta_bit_4       ;Paso offset en donde quiero que guarde la carta
    push di
    call Generador_Carta
    pop di

    mov dl, comp_carta_bit_4
    mov bx, offset comp_carta_4
    call regascii2

    ;GUARDO EL VALOR DE LAS CARTAS EN OTRA VARIABLE POR ERROR DE SOBRE ESCRITURA
    ;ERROR DE SOBRE ESCRITURA EN FUNCIÓN USER_SUMA borra el contenido del offset que le pasas
    mov dx, offset comp_carta_4
    mov bx, offset comp_carta_4_cop2
    call copioVariable

    mov bx, offset comp_carta_4
    call Acumulador_comp_carta
    push cx

;PREPARO VARIABLES DE LAS CARTAS PARA FUNCION IMPR_CARTA
    mov di, offset comp_carta_1_cop
    push di
    mov si, offset comp_carta_2_cop
    push si
    mov dx, offset comp_carta_3_cop
    push dx
    mov bx, offset comp_carta_4_cop2
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