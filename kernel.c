// 16位内核C代码
// 简单的hello world内核

// 定义一些常量
#define VIDEO_MEMORY 0xB8000
#define WHITE_ON_BLACK 0x0F
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

// 当前光标位置
static int cursor_x = 0;
static int cursor_y = 0;

// 清屏函数 - 使用BIOS中断
void clear_screen() {
    __asm__ volatile(
        "movb $0x00, %%ah\n"
        "movb $0x00, %%al\n"
        "int $0x10\n"
        : : : "ax"
    );
    cursor_x = 0;
    cursor_y = 0;
}

// 打印单个字符 - 使用BIOS中断
void putchar(char c) {
    if (c == '\n') {
        // 处理换行符
        __asm__ volatile(
            "movb $0x0d, %%al\n"  // 回车符
            "movb $0x0e, %%ah\n"
            "int $0x10\n"
            "movb $0x0a, %%al\n"  // 换行符
            "movb $0x0e, %%ah\n"
            "int $0x10\n"
            : : : "ax"
        );
    } else {
        __asm__ volatile(
            "movb %0, %%al\n"
            "movb $0x0e, %%ah\n"
            "int $0x10\n"
            : : "r"(c) : "ax"
        );
    }
}

// 打印字符串
void print_string(const char* str) {
    while (*str) {
        putchar(*str);
        str++;
    }
}

// 内核主函数
void kernel_main() {
    // 清屏
    clear_screen();
    
    // 打印欢迎消息
    print_string("Hello World from 16-bit Kernel!\n");
    print_string("Welcome to our simple OS!\n");
    print_string("This is written in C and NASM.\n");
    print_string("Enjoy exploring!\n");
    
    // 无限循环
    while (1) {
        // 简单的延迟循环
        for (volatile int i = 0; i < 1000000; i++) {
            // 空循环
        }
    }
} 