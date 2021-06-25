.8086
.model small
.stack 100h
.data

.code
public regascii2

regascii2 proc
	;Guarda enm registro (DX), el nro a convertir y en bx el offset de la variable donde almacenara los caracteres
	;que correspondan al nro.
		push ax
		push bx
		push cx
		;push dx
		pushf

		xor cx, cx
		xor ax, ax

		mov al, dl
		mov cl, 10
		div cl
		add al, 30h
		mov byte ptr [bx], al

		add ah, 30h
		mov [bx+1], ah

		popf
		;pop dx
		pop cx
		pop bx
		pop ax
		ret
regascii2 endp
end