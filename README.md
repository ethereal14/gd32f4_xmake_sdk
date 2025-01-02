# GD32F4单片机模板工程

## 模板工程详细构建过程

参考：[gd32f427zg系列一：环境搭建与点亮led灯_gd32f427zgt6开发环境-CSDN博客](https://blog.csdn.net/qq_42913442/article/details/141833205)

## 开发环境简介

- 编译链：gcc-arm-none-eabi-10.3
- 构建工具：xmake
- 编辑工具：VSCode
- 语言服务器：Clangd

## 待办

- [x] 库函数构建为静态库
- [x] 支持多项目构建
- [ ] 导入components，例如RTOS、协议栈、文件系统、驱动框架等等
- [ ] 搭建bsp层，兼容不同单板
- [ ] 搭建通用业务层：升级、配置保存、httpd、dhcp client、dns client等

 