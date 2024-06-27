; $Id$

%define VERSION "0.0"

org 0x7e00
main:
	call clear 
	mov si, tline
	call print_str
	mov si, newline
	call print_str
	mov si, version
	call center_print
	mov si, newline
	call print_str
	mov si, svnid
	call center_print
	mov si, newline
	call print_str
	mov si, copyright
	call center_print
	mov si, newline
	call print_str
	mov si, bline
	call print_str
	jmp $

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
	mov bh, 0x07
	mov al, 0
	mov ch, 0
	mov cl, 0
	mov dh, 24
	mov dl, 80
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
.loop:
	mov ch, [si]
	inc ax
	inc si
	mov ch, [si]
	cmp ch, 0
	jne .loop
	pop cx
	pop si
	ret

print_str:
	push ax
	push bx
	push si
	push cx
	xor ax, ax
.loop:
	mov al, [si]
	mov bl, 0x07
	mov ah, 0x0e
	int 0x10
	inc si
	mov ch, [si]
	cmp ch, 0
	jne .loop
	pop cx
	pop si
	pop bx
	pop ax
	ret

tline:		db "  "
		times 76 db 0xdc
		db "  "
		db 0

bline:		db "  "
		times 76 db 0xdf
		db "  "
		db 0
	
version:	db "DISK BASIC FOR PC COMPATIBLES"
		db 0

copyright:	db "Copyright (C) 2024 by Nishi"
		db 0

newline:	db 0xd
		db 0xa
		db 0

svnid:		db "$Id$"
		db 0

times ((16 * 512) - ($ - $$)) db 0
