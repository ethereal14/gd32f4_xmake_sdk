add_defines("app")

target("uart_test")
    -- 设置生成的文件名称
    set_extension(".elf")
    -- 生成二进制文件
    add_rules("dump")
    set_kind("binary")
    add_deps("gd32f427")
    add_files("uart_test/*.c")
    add_includedirs("uart_test")

target("led_test")
    -- 设置生成的文件名称
    set_extension(".elf")
    -- 生成二进制文件
    add_rules("dump")
    set_kind("binary")
    add_deps("gd32f427")
    add_files("led_test/*.c")
    add_includedirs("led_test")