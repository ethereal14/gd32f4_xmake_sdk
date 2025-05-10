set_project("gd32f427xx")
set_xmakever("2.3.2")
set_version("0.0.0", {build = "%Y%m%d%H%M"})

add_rules("plugin.compile_commands.autoupdate", {outputdir = ".vscode"})

-- set common flags
-- 设置工具链
toolchain("arm-none-eabi")
    set_kind("standalone")
    set_sdkdir("D:/gcc-arm-none-eabi-10.3")
toolchain_end()
-- 设置编译链
set_toolchains("arm-none-eabi")
-- 启用所有警告
set_warnings("all", "error")
set_languages("c99")
-- 禁用优化
set_optimize("none")
-- 设置编译文件的目录
set_targetdir("build")
-- 添加宏定义
add_defines(
    "USE_STDPERIPH_DRIVER",
    "GD32F427",
    "GD32F4xx"
)
-- 设置C编译参数
add_cflags(
    "-mcpu=cortex-m4",
    "-mthumb",
    "-mfloat-abi=hard -mfpu=fpv4-sp-d16",
    "-fdata-sections -ffunction-sections",
    "-g -gdwarf-2",
    "--specs=nano.specs --specs=nosys.specs",
    { force = true }
)
-- 设置汇编编译参数
add_asflags(
    "-mcpu=cortex-m4",
    "-mthumb",
    "-mfloat-abi=hard -mfpu=fpv4-sp-d16",
    "-fdata-sections -ffunction-sections",
    { force = true }
)
-- 设置链接参数
add_ldflags(
    "-mcpu=cortex-m4",
    "-mthumb",
    "-mfloat-abi=hard -mfpu=fpv4-sp-d16",
    "-specs=nano.specs",
    "-Tlink.ld",
    "-Wl,--gc-sections",
    "-u _printf_float",
    "-lc -lm -lnosys",
    "-Wl,-Map=target.map,--cref",
    { force = true }
)

target("gd32f427")
    set_prefixname("lib")
    set_kind("static")
    set_extension(".a")
    set_targetdir("lib")
    add_files(
        "./libraries/CMSIS/GD/GD32F4xx/Source/GCC/startup_gd32f4xx.s",
        "./libraries/CMSIS/GD/GD32F4xx/Source/*.c",
        "./libraries/GD32F4xx_standard_peripheral/Source/*.c"
    )
    -- 设置头文件搜索路径
    add_includedirs(
        "./include",
        "./libraries/GD32F4xx_standard_peripheral/Include",
        "./libraries/CMSIS/GD/GD32F4xx/Include",
        "./libraries/CMSIS/GD/GD32F4xx",
        "./libraries/CMSIS",
        { public = true }
    )
target_end()

-- includes sub-projects
includes("app")

rule("dump")
    after_build(function(target)
        os.exec("arm-none-eabi-objcopy -O ihex ./build/%s.elf ./build/%s.hex", target:name(), target:name())
        os.exec("arm-none-eabi-objcopy -O binary ./build/%s.elf ./build/%s.bin", target:name(), target:name())
        print("生成已完成!")
        print("********************储存空间占用情况*****************************")
        os.exec("arm-none-eabi-size -Bd ./build/%s.elf", target:name())
        print("****************************************************************")
    end)


rule("install")
    after_install(function (target) 
        local str = string.format("\"reset halt; wait_halt; flash write_image erase %s 0x08000000\"", target:targetfile())
        os.exec("openocd -f cmsis-dap.cfg -f gd32f4xx.cfg -c init -c %s   -c reset -c shutdown", str)
    end)

on_clean(function()
    os.rm("build")
end)