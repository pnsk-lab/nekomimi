; $Id$

%include "common.asm"

%ifndef NO_LOADER
org 0:0x7c00
bits 16
boot:
	mov [drive], dl
	mov ah, 0
	int 0x13
	jc .err
	mov cl, 3
	mov al, BASIC_SIZE
	mov ax, [si]
	mov ah, 2
	mov dl, [drive]
	mov dh, 0
	mov ch, 0
	xor bx, bx
	mov es, bx
	mov bx, LOAD_AT
	int 0x13
	mov dx, drive
	jmp 0:LOAD_AT
.err:
	mov al, '!'
.out:
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	jmp $

drive: db 0

times (510 - ($ - $$)) db 0
db 0x55
db 0xaa
%endif
