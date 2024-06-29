; $Id$

center_print:
	push ax
	push bx
	push cx
	push dx
	call strlen
	shr ax, 1
	mov cx, ax
	mov ax, 40
	sub ax, cx
	mov bh, 0
	push ax
	push bx
	push cx
	mov ah, 3
	mov bh, 0
	int 0x10
	pop cx
	pop bx
	pop ax
	mov dl, al
	mov ah, 2
	int 0x10
	call print_str
	push si
	mov si, newline
	call print_str
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret

clear:
	push ax
	push bx
	push cx
	push dx
%ifdef GRAPHIC
	mov bh, [bgcolor]
%endif
%ifdef TEXT
	mov bh, [bgcolor]
	shl bh, 4
	or bh, [fgcolor]
%endif
	mov al, 0
	mov ch, 0
	mov cl, 0
	mov dh, 24
	mov dl, 79
	mov ah, 6
	int 0x10
	mov bh, 0
	mov dh, 0
	mov dl, 0
	mov ah, 2
	int 0x10
	pop dx
	pop cx
	pop bx
	pop ax
	ret

strlen:
	push si
	push cx
	xor ax, ax
	mov ch, [si]
	cmp ch, 0
	je .brk
.loop:
	mov ch, [si]
	inc ax
	inc si
	mov ch, [si]
	cmp ch, 0
	jne .loop
.brk:
	pop cx
	pop si
	ret

print_str:
	push ax
	push bx
	push si
	push cx
	xor ax, ax
	mov al, [si]
	cmp al, 0
	je .brk
.loop:
	mov al, [si]
	mov bh, 0
	mov bl, [bgcolor]
	shl bl, 4
	or bl, [fgcolor]
	mov ah, 0x0e
	int 0x10
	inc si
	mov ch, [si]
	cmp ch, 0
	jne .loop
.brk:
	pop cx
	pop si
	pop bx
	pop ax
	ret

number_to_string:
	mov si, number
	add si, 30
	push ax
	push bx
	push dx
.loop:
	xor dx, dx
	mov bx, 10
	div bx
	add dx, '0'
	mov byte [si], dl	
	dec si
	cmp ax, 0
	jne .loop
	pop dx
	pop bx
	pop ax
	inc si
	ret

number_to_hex_string:
	mov si, number
	add si, 30
	push ax
	push bx
	push dx
.loop:
	xor dx, dx
	mov bx, 16
	div bx
	push si
	mov si, hex
	add si, dx
	mov dx, [si]
	pop si
	mov byte [si], dl	
	dec si
	cmp ax, 0
	jne .loop
	pop dx
	pop bx
	pop ax
	inc si
	ret

strequ:
	push si
	mov si, di
	call strlen
	mov bx, ax
	pop si
	call strlen
	cmp ax, bx
	je .equ
	mov ax, 0
	ret
.equ:
	call strlen
	mov bx, ax
	call strlen
	push si
	push di
	push cx
	mov cl, [si]
	mov ch, [di]
	cmp cl, 0
	je .brk
	cmp cl, ch
	jne .badbrk
	inc si
	inc di
.brk:
	pop cx
	pop di
	pop si
	mov ax, 1
	ret
.badbrk:
	pop cx
	pop di
	pop si
	mov ax, 0
	ret

uppercase:
	cmp al, 'a'
	jl .brk
	cmp al, 'z'
	jg .brk
	sub al, 'a' - 'A'
.brk:
	ret
