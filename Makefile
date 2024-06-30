# $Id$

.PHONY: all run clean get-version atbasic.com

all: basic.img

TARGET=PC_COMPAT
KB=1440
MODE=GRAPHIC
BASIC_SIZE=8
LOAD_AT=0x0500

basic.img: boot.bin main.bin
	cat boot.bin main.bin > basic.img

atbasic.com:
	$(MAKE) basic.img CUSTOM="-DDOS" MODE="$(MODE)" TARGET="$(TARGET)" BASIC_SIZE="$(BASIC_SIZE)"
	cp basic.img $@

boot.bin: boot.asm
	nasm -DLOAD_AT=$(LOAD_AT) $(CUSTOM) -DSIZE=\"`expr $(BASIC_SIZE) \* 512 / 1024`K\" -DBASIC_SIZE=$(BASIC_SIZE) -D$(TARGET) -D$(MODE) -DKB=$(KB) -fbin -o boot.bin boot.asm

main.bin: main.asm var.asm util.asm basic.asm
	nasm -DLOAD_AT=$(LOAD_AT) $(CUSTOM) -DSIZE=\"`expr $(BASIC_SIZE) \* 512 / 1024`K\" -DBASIC_SIZE=$(BASIC_SIZE) -D$(TARGET) -D$(MODE) -DKB=$(KB) -fbin -o main.bin main.asm

run: basic.img
	qemu-system-i386 -fda basic.img

get-version:
	@cat main.asm | grep "define VERSION" | grep -Eo "[0-9]+\.[0-9]+(-[a-z\-]+)?"

clean:
	rm -f *.bin basic.img *.com
