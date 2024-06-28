# $Id$

.PHONY: all run clean

all: basic.img

TARGET=PC_COMPAT

basic.img: boot.bin main.bin
	cat boot.bin main.bin > basic.img

boot.bin: boot.asm
	nasm -D$(TARGET) -fbin -o boot.bin boot.asm

main.bin: main.asm
	nasm -D$(TARGET) -fbin -o main.bin main.asm

run: basic.img
	qemu-system-i386 -fda basic.img

clean:
	rm -f *.bin *.img
