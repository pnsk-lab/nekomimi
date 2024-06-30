; $Id$

tline:		db "  "
		times 76 db 0xdc
		db "  "
		db 0

bline:		db "  "
		times 76 db 0xdf
		db "  "
		db 0

version:
%ifdef GRAPHIC
		db "(Graphical) "
%endif
		db SIZE
		db " Nekomimi Programming Language V"
		db VERSION
		db 0

copyright:	db "Copyright (C) 2024 by Nishi/pnsk-lab"
		db 0

booted_from:	db "Booted from BIOS drive 0x"
		db 0

newline:	db 0xd
		db 0xa
		db 0

kb:		db "KB real-mode memory present"
		db 0xd
		db 0xa
		db 0

hex:		db "0123456789ABCDEF"

number:		times 32 db 0

db 0

line:		times 1024 db 0

keyb:		db 0

%ifndef NOT_FLOPPY
drive:		db 0
%endif

bgcolor:	db 0

fgcolor:	db 0x7

retcode:	dw 0

bs:		db 0x8
		db " "
		db 0x8
		db 0
	
CLS:		db "CLS"
		db 0

LOAD:		db "LOAD"
		db 0

list:		dw ok_msg
		dw synerr_msg

ok_msg:		db "OK"
		db 0

synerr_msg:	db "Syntax Error"
		db 0
