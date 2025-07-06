# Makefile for 16-bit Hello World Kernel

# 编译器设置
NASM = nasm
CC = gcc
LD = ld

# 编译选项
NASMFLAGS = -f bin
CCFLAGS = -m16 -fno-pie -nostdlib -nostdinc -fno-builtin -fno-pic -march=i386 -O0 -fno-stack-protector
LDFLAGS = -m elf_i386 --oformat binary

# 目标文件
BOOT_BIN = boot.bin
KERNEL_BIN = kernel.bin
OS_IMG = os.img

# 默认目标
all: $(OS_IMG)

# 编译引导扇区
$(BOOT_BIN): boot.asm
	$(NASM) $(NASMFLAGS) -o $@ $<

# 编译内核
$(KERNEL_BIN): kernel_entry.asm kernel.c
	$(NASM) -f elf32 -o kernel_entry.o kernel_entry.asm
	$(CC) $(CCFLAGS) -c -o kernel.o kernel.c
	$(LD) $(LDFLAGS) -Ttext 0x0000 -o $@ kernel_entry.o kernel.o

# 创建磁盘镜像
$(OS_IMG): $(BOOT_BIN) $(KERNEL_BIN)
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=$(BOOT_BIN) of=$@ conv=notrunc
	dd if=$(KERNEL_BIN) of=$@ conv=notrunc seek=1

# 清理
clean:
	rm -f *.bin *.o *.img

# 运行（需要QEMU）
run: $(OS_IMG)
	qemu-system-i386 -drive file=$(OS_IMG),format=raw,index=0,if=floppy

# 调试运行
debug: $(OS_IMG)
	qemu-system-i386 -drive file=$(OS_IMG),format=raw,index=0,if=floppy -s -S

.PHONY: all clean run debug 
