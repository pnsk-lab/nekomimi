; $Id$
tline:		db "  "
		times 76 db 0xdc
		db "  "
		db 0

bline:		db "  "
		times 76 db 0xdf
		db "  "
		db 0
	
version:	db "DISK BASIC FOR PC COMPATIBLES V"
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

line:		times 1024 db 0

keyb:		db 0

drive:		db 0

bgcolor:	db 0

fgcolor:	db 0x7
