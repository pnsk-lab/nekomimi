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
	mov bp, 0x7c0
	mov es, bp
	mov bp, bootmsg
	mov cx, 8
	push cx
	mov ah, 3
	int 0x10
	pop cx
	mov bl, 0x7
	mov bh, 0
	mov ax, 0x1301
	int 0x10
	jmp .prompt
.newline:
	call nl
.prompt:
	mov ah, 0x0e
	mov bl, 0x0f
	mov al, ':'
	int 0x10
	xor bp, bp
	mov es, bp
	mov bp, 0x0500
	mov byte [es:bp], 0
.loop:
	mov ah, 0
	int 0x16
	cmp al, 0xd
	je .brk
	cmp al, 0x08
	je .bs
	mov byte [es:bp], al
	inc bp
	mov byte [es:bp], ah
	mov ah, 0x0e
	mov bl, 0x0f
	int 0x10
	jmp .loop
.bs:
	dec bp
	mov byte [es:bp], 0
	mov al, 8
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	mov al, ' '
	int 0x10
	mov al, 8
	int 0x10
	jmp .loop
.brk:
	mov cx, bp
	sub cx, 0x500 ; cx = bootstr length
	cmp cx, 0
	je .empty
	jmp .parse
.empty:
	push cx
	push si
	push di
	push bx
	mov si, default_name
	mov di, 0x0500
	mov cx, 0
	mov bx, 0x7c0
	mov es, bx
.loopempty:
	mov al, [es:si]
	mov [di], al
	inc si
	inc di
	inc cx
	cmp cx, 8
	jne .loopempty
	mov cx, 0
	mov si, default_ext
.loopempty2:
	mov al, [es:si]
	mov [di], al
	inc si
	inc di
	inc cx
	cmp cx, 3
	jne .loopempty2
	pop bx
	pop di
	pop si
	pop cx
	mov cx, 8+3
.parse:
	mov si, 0x500
	mov di, si
.loopparse:
	mov al, [si]
	inc si
	cmp al, '.'
	jne .put
	dec cx
	cmp cx, 0
	jne .loopparse
	jmp .brkparse
.put:
	mov [di], al
	inc di
	dec cx
	cmp cx, 0
	jne .loopparse
.brkparse:
	call nl
	push es
	push bp
	push cx
	mov ah, 0x03
	mov bh, 0
	int 0x10
	pop cx
	xor bp, bp
	mov es, bp
	mov bp, 0x500
	mov cx, 8
	mov bx, 0x0007
	mov ax, 0x1301
	int 0x10
	mov al, '.'
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	push cx
	mov ah, 0x03
	mov bh, 0
	int 0x10
	pop cx
	xor bp, bp
	mov es, bp
	mov bp, 0x500+8
	mov cx, 3
	mov bx, 0x0007
	mov ax, 0x1301
	int 0x10
	pop bp
	pop es
.brk2:
	mov cl, 2
.loopread:
	mov ah, 2
	mov al, 1
	mov dl, [drive]
	mov dh, 0
	mov ch, 0
	xor bx, bx
	mov es, bx
	mov bx, 0x7e00
	int 0x13
	jc .err
	mov si, 0x7e00
	cmp word [si], 0
	je .newline
	mov si, 0x7e02
	mov di, 0x0500
	call compare8
	cmp ax, 1
	jne .brkread
	mov si, 0x7e02+8
	mov di, 0x0500+8
	call compare3
	cmp ax, 1
	jne .brkread
	jmp .read
.brkread:
	mov si, 0x7e00
	mov ax, [si]
	add cl, al
	jmp .loopread
.read:
	inc cl
	mov si, 0x7e00
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

compare3:
	push cx
	push si
	push di
	push bx
	xor cx, cx
	mov ax, 1
.lp:
	mov bl, [si]
	mov bh, [di]
	cmp bl, bh
	jne .no
	inc si
	inc di
	inc cx
	cmp cx, 3
	jne .lp
	jmp .ret
.no:
	mov ax, 0
.ret:
	pop bx
	pop di
	pop si
	pop cx
	ret

compare8:
	push cx
	push si
	push di
	push bx
	xor cx, cx
	mov ax, 1
.lp:
	mov bl, [si]
	mov bh, [di]
	cmp bl, bh
	jne .no
	inc si
	inc di
	inc cx
	cmp cx, 8
	jne .lp
	jmp .ret
.no:
	mov ax, 0
.ret:
	pop bx
	pop di
	pop si
	pop cx
	ret

nl:
	push ax
	push bx
	mov al, 0xd
	mov bl, 0x0f
	mov ah, 0x0e
	int 0x10
	mov al, 0xa
	int 0x10
	pop bx
	pop ax
	ret

drive: db 0

bootmsg: db "86Boot"
	 db 0xd
	 db 0xa

default_name: db "nekomimi"
default_ext:  db "bin"

times (510 - ($ - $$)) db 0
db 0x55
db 0xaa
%endif
