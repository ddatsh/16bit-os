; 16位引导扇区代码
; 用于加载内核并跳转到内核代码

[org 0x7c00]                    ; BIOS加载引导扇区到0x7c00
[bits 16]                       ; 16位模式

; 初始化段寄存器
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00              ; 设置栈指针

; 显示加载消息
    mov si, loading_msg
    call print_string

; 加载内核到内存
    mov ah, 0x02                ; BIOS读取扇区功能
    mov al, 9                   ; 读取9个扇区（足够加载内核）
    mov ch, 0                   ; 柱面0
    mov cl, 2                   ; 从扇区2开始（扇区1是引导扇区）
    mov dh, 0                   ; 磁头0
    mov dl, 0x00                ; 驱动器0（软盘）
    mov bx, 0x1000              ; 加载到内存地址0x1000
    int 0x13                    ; 调用BIOS中断

    jc disk_error               ; 如果出错则跳转

; 跳转到内核
    jmp 0x100:0x0000

; 打印字符串函数
print_string:
    pusha
    mov ah, 0x0e                ; BIOS tty模式
.loop:
    lodsb                       ; 加载字符到al
    test al, al                 ; 检查是否为0（字符串结束）
    jz .done
    int 0x10                    ; 调用BIOS中断打印字符
    jmp .loop
.done:
    popa
    ret

; 磁盘错误处理
disk_error:
    mov si, disk_error_msg
    call print_string
    jmp $                       ; 无限循环

; 数据
loading_msg db 'Loading kernel...', 13, 10, 0
disk_error_msg db 'Disk read error!', 13, 10, 0

; 填充到510字节，最后两个字节是引导扇区签名
times 510-($-$$) db 0
dw 0xaa55 