# $Id$

.PHONY: all run clean get-version

all: basic.img

TARGET=PC_COMPAT
KB=1440
MODE=GRAPHIC

basic.img: boot.bin main.bin
	cat boot.bin main.bin > basic.img

boot.bin: boot.asm
	nasm -DBASIC_SIZE=8 -D$(TARGET) -D$(MODE) -DKB=$(KB) -fbin -o boot.bin boot.asm

main.bin: main.asm var.asm util.asm basic.asm
	nasm -DBASIC_SIZE=8 -D$(TARGET) -D$(MODE) -DKB=$(KB) -fbin -o main.bin main.asm

run: basic.img
	qemu-system-i386 -fda basic.img

get-version:
	@cat main.asm | grep "define VERSION" | grep -Eo "[0-9]+\.[0-9]+(-[a-z\-]+)?"

clean:
	rm -f *.bin *.img
