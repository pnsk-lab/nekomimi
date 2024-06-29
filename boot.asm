; $Id$

%include "common.asm"

%ifndef NO_LOADER
org 0x7c00:0
bits 16
boot:
	mov [drive], dl
	mov al, 'B'
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	mov ah, 0
	mov dl, [drive]
	int 0x13
	jc .err
	mov al, 'R'
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	mov ah, 2
	mov al, BASIC_SIZE
	mov dl, [drive]
	mov dh, 0
	mov ch, 0
	mov cl, 2
	xor bx, bx
	mov es, bx
	mov bx, LOAD_AT
	int 0x13
	jc .err
	mov al, 'R'
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	mov dx, drive
	mov al, 'J'
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	jmp 0:LOAD_AT
.err:
	mov al, '!'
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	jmp $

drive: db 0

times (510 - ($ - $$)) db 0
db 0x55
db 0xaa
%endif
