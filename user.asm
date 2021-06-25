.8086
.model small
.stack 100h

.data

     inicio db "Ingrese un texto",0dh,0ah,24h
     texto db 255 dup('$'),0dh,0ah,24h
     letraa db "000",0dh,0ah,24h
     letrae db "000",0dh,0ah,24h

.code

	main proc
		mov ax, @data
		mov ds,ax

		mov ah,9
		mov dx, offset inicio
		int 21h

		mov bx,0
carga:
		mov ah,1
		int 21h
		cmp al, 0dh
		je afuera
		mov texto[bx],al
		inc bx
		jmp carga

afuera:

		mov bx,0
compara: 
		cmp texto[bx],'$'
		je imprimir
		cmp texto[bx],'a'
		je vocal 
		cmp texto[bx],'e'
		je vocale 
		inc bx
		jmp compara


vocal:;para a guardo en dl 
		add dl,1
		inc bx
		jmp compara

vocale:;para e guardo en dh
		add dh,1
		inc bx
		jmp compara

;para poder imprimir lo que tengo en las variables tengo que hacer reg to ascii

	xor ax,ax

	mov al,dl
	mov cl,100
	div cl
	add al,30h
	mov letraa[0],al

	

	mov al,ah
	xor ah,ah
	mov cl,10
	div cl
	add al,30h
	mov letraa[1],al

	add ah,30h
	mov letraa[2],ah

xor ax,ax

	mov al,dh
	mov cl,100
	div cl
	add al,30h
	mov letrae[0],al

	

	mov al,ah
	xor ah,ah
	mov cl,10
	div cl
	add al,30h
	mov letrae[1],al

	add ah,30h
	mov letrae[2],ah

imprimir:

		mov ah,9
		mov dx, offset letraa
		int 21h

		mov ah,9
		mov dx, offset letrae
		int 21h


		mov ax,4c00h
		int 21h
	main endp
	end main