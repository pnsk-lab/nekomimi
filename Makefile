# $Id$

.PHONY: all clean

all: basic.img

basic.img: boot.bin main.bin
	cat boot.bin main.bin > basic.img

boot.bin: boot.asm
	nasm -fbin -o boot.bin boot.asm

main.bin: main.asm
	nasm -fbin -o main.bin main.asm

clean:
	rm -f *.bin *.img
