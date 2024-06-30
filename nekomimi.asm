; $Id$

run:
	push si
	push ax
	push bx
	push cx
	push dx
	xor cx, cx
	push si
.until:
	mov al, [si]
	cmp al, '0'
	jl .brk
	cmp al, '9'
	jg .brk
	inc si
	mov al, [si]
	cmp al, ' '
	je .space
	jmp .until
.space:
	mov cx, 1
.brk:
	cmp cx, 1
	je .nocall
	call rundirective
	mov dx, list
	shl ax, 1
	add dx, ax
	push bx
	mov bx, dx
	push si
	mov si, [bx]
	call print_str
	mov si, newline
	call print_str
	pop si
	pop bx
.nocall:
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop si
	ret

rundirective:
	mov byte [retcode], SUCCESS
	call strlen
	cmp ax, 0
	je .retzero
	push si
	push ax
	push bx
	push cx
	push dx
.until:
	mov al, [si]
	cmp al, 0
	je .brk
	cmp al, ' '
	jne .brk
	inc si
	jmp .until
.brk: ; si is trimmed
	push si
	xor cx, cx
.until2:
	mov al, [si]
	call uppercase
	mov [si], al
	cmp al, ' '
	je .brk3
	cmp al, 0
	je .brk2
	inc si
	jmp .until2
.brk3:
	mov cx, 1
.brk2:
	mov byte [si], 0
	pop si
	mov di, CLS
	call strequ
	cmp ax, 1
	je .CLS
	mov di, LOAD
	call strequ
	cmp ax, 1
	je .LOAD
	mov byte [retcode], SYNTAX_ERROR
	jmp .ret
.CLS:
	call clear
	jmp .ret
.LOAD:
	cmp cx, 0
	je .synerr
	call strlen
	add si, ax
	inc si
	call strlen
	cmp ax, 0
	je .synerr
	jmp .ret
.synerr:
	mov byte [retcode], SYNTAX_ERROR
.ret:
	pop dx
	pop cx
	pop bx
	pop ax
	pop si
	mov ax, [retcode]
	ret
.retzero:
	ret
