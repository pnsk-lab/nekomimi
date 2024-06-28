; $Id$

%define VERSION "0.0-beta"

org 0x7e00
main:
	mov ah, 0
	mov al, 0xe
	int 0x10
	mov si, dx
	mov dl, [si]
	mov [drive], dl
	call clear
	mov si, tline
	call print_str
	mov si, newline
	call print_str
	mov si, version
	call center_print
	mov si, newline
	call print_str
	mov si, copyright
	call center_print
	mov si, newline
	call print_str
	mov si, bline
	call print_str
	int 0x12
	call number_to_string
	call print_str
	mov si, kb
	call print_str
	mov si, booted_from
	call print_str
	mov ax, [drive]
	call number_to_hex_string
	call print_str
	mov si, newline
	call print_str
	xor cx, cx
.loop:
	mov ah, 0
	int 0x16
	mov [keyb], al
	cmp al, 0xd
	je .enter
	cmp al, 0x8
	je .backspace
	jmp .print
.enter:
	mov si, newline
	call print_str
	mov si, line
	call print_str
	mov si, newline
	call print_str
	mov si, line
	mov byte [si], 0
	xor cx, cx
	jmp .brk
.backspace:
	mov si, bs
	call print_str
	mov si, line
	call strlen
	add si, ax
	dec si
	mov byte [si], 0
	jmp .brk
.print:
	mov si, line
	add si, cx
	inc cx
	mov byte [si], al
	inc si
	mov byte [si], 0
	mov bl, [bgcolor]
	shl bl, 4
	or bl, [fgcolor]
	mov ah, 0x0e
	int 0x10
.brk:
	jmp .loop

%include "basic.asm"
%include "util.asm"
%include "var.asm"

times ((16 * 512) - ($ - $$)) db 0
times ((SECTORS * 1024 - 512) - ($ - $$)) db 0
