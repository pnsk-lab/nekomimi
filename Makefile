# $Id$

.PHONY: all run clean get-version

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

get-version:
	@cat main.asm | grep "define VERSION" | grep -Eo "[0-9]+\.[0-9]+"

clean:
	rm -f *.bin *.img
