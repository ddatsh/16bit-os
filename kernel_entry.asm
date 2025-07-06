; 内核入口点
; 用于调用C语言的内核主函数

[bits 16]                       ; 16位模式
[extern kernel_main]            ; 声明外部C函数

global _start                    ; 全局入口点

_start:
    ; 设置段寄存器
    mov ax, 0x100               ; 内核段地址
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x1000              ; 设置栈指针

    ; 调用C语言内核主函数
    call kernel_main

    ; 如果内核返回，进入无限循环
    jmp $ 