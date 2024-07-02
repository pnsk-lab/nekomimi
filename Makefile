# $Id$

.PHONY: all run clean get-version nekomimi.com

all: nekomimi.img

TARGET=PC_COMPAT
KB=1440
MODE=GRAPHIC
BASIC_SIZE=8
LOAD_AT=0x0500
GRAPHIC_MODE=0xe

nekomimi.img: floppy.asm boot.bin main.bin
	nasm -fbin -o nekomimi.img -DBASIC_SIZE=$(BASIC_SIZE) -DKB=$(KB) floppy.asm

nekomimi.com:
	$(MAKE) main.bin CUSTOM="-DDOS" MODE="$(MODE)" TARGET="$(TARGET)" BASIC_SIZE="$(BASIC_SIZE)" GRAPHIC_MODE="$(GRAPHIC_MODE)" LOAD_AT=0x0100
	cp main.bin $@

boot.bin: boot.asm
	nasm -DLOAD_AT=$(LOAD_AT) $(CUSTOM) -DSIZE=\"`expr $(BASIC_SIZE) \* 512 / 1024`K\" -DBASIC_SIZE=$(BASIC_SIZE) -D$(TARGET) -D$(MODE) -DKB=$(KB) -DGRAPHIC_MODE=$(GRAPHIC_MODE) -fbin -o boot.bin boot.asm

main.bin: main.asm var.asm util.asm nekomimi.asm
	nasm -DLOAD_AT=$(LOAD_AT) $(CUSTOM) -DSIZE=\"`expr $(BASIC_SIZE) \* 512 / 1024`K\" -DBASIC_SIZE=$(BASIC_SIZE) -D$(TARGET) -D$(MODE) -DKB=$(KB) -DGRAPHIC_MODE=$(GRAPHIC_MODE) -fbin -o main.bin main.asm

run: nekomimi.img
	qemu-system-i386 -fda nekomimi.img -monitor stdio

get-version:
	@cat main.asm | grep "define VERSION" | grep -Eo "[0-9]+\.[0-9]+(-[a-z\-]+)?"

clean:
	rm -f *.bin nekomimi.img *.com
