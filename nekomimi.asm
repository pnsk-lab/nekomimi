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
	mov al, [si]
	call uppercase
	cmp al, 'C'
	je .CLS
	cmp al, 'D'
	je .DEF
	mov byte [retcode], SYNTAX_ERROR
	jmp .brk
.CLS:
	call clear
	jmp .brk
.DEF:
	call strlen
	cmp ax, 2
	jl .synerr
	inc si
	mov al, [si]
	call uppercase
	call get_variable_address
	mov di, bx
	jmp .brk
.synerr:
	mov byte [retcode], SYNTAX_ERROR
.brk:
	pop dx
	pop cx
	pop bx
	pop ax
	pop si
	mov ax, [retcode]
	ret
.retzero:
	ret

get_variable_address:
	mov bx, START
	push ax
	sub al, 'A'
	mov cl, al
	mov al, VARSIZE + 2
	mul cx
	add bx, ax
	pop ax
	ret
