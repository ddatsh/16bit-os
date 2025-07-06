#!/bin/bash

# 16位 Hello World 内核运行脚本

echo "=== 16位 Hello World 内核 ==="
echo "正在编译..."

# 检查依赖
if ! command -v nasm &> /dev/null; then
    echo "错误: 未找到 NASM，请安装: sudo apt install nasm"
    exit 1
fi

if ! command -v gcc &> /dev/null; then
    echo "错误: 未找到 GCC，请安装: sudo apt install gcc"
    exit 1
fi

if ! command -v qemu-system-i386 &> /dev/null; then
    echo "错误: 未找到 QEMU，请安装: sudo apt install qemu-system-x86"
    exit 1
fi

# 清理之前的编译文件
echo "清理旧文件..."
make clean

# 编译
echo "编译项目..."
make

if [ $? -eq 0 ]; then
    echo "编译成功！"
    echo "启动QEMU虚拟机..."
    echo "按 Ctrl+C 退出"
    echo ""
    make run
else
    echo "编译失败！"
    exit 1
fi 