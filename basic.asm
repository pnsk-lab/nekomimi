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
	push si
	push ax
	push bx
	push cx
	push dx
.until:
	mov al, [si]
	cmp al, ' '
	jne .brk
	inc si
	jmp .until
.brk: ; si is trimmed
	push si
.until2:
	mov al, [si]
	call uppercase
	mov [si], al
	cmp al, ' '
	je .brk2
	inc si
	jmp .until2
.brk2:
	mov byte [si], 0
	pop si
	mov di, CLS
	call strequ
	cmp ax, 1
	je .CLS
	mov byte [retcode], SYNTAX_ERROR
	jmp .ret
.CLS:
	call clear
	jmp .ret
.ret:
	pop dx
	pop cx
	pop bx
	pop ax
	pop si
	mov ax, [retcode]
	ret
