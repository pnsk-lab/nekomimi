; $Id$

org 0x7c00
boot:
	mov [drive], dl
	mov al, 'B'
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	mov al, 0xd
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	mov al, 0xa
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	mov ah, 0
	mov dl, [drive]
	int 0x13
	mov ah, 2
	mov al, 16
	mov dl, [drive]
	mov dh, 0
	mov ch, 0
	mov cl, 2
	xor bx, bx
	mov es, bx
	mov bx, 0x7e00
	int 0x13
	jmp 0:0x7e00

drive: db 0

times (510 - ($ - $$)) db 0
db 0x55
db 0xaa
