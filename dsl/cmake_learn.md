# <font color=#0099ff> **Cmake 学习** </font>

> `@think3r` 2019-10-14 22:48:12
> 1. [CMake offical Documentation](https://cmake.org/cmake/help/v3.15/)
> 2. [CMake 入门实战 -- hahack](https://www.hahack.com/codes/cmake/#stq=&stp=0)
> 3. [https://github.com/Campanula/CMake-tutorial](https://github.com/Campanula/CMake-tutorial)
> 4. [CMake 完全教程 lolimay/CMake-Tutorial](https://github.com/lolimay/CMake-Tutorial)
> 5. [CMake output/build directory](https://stackoverflow.com/questions/18826789/cmake-output-build-directory)
> 6. [CMake文档](https://mubu.com/doc/t1VDCEn4O0)
> 7. [CMake编译中target_link_libraries中属性PRIVATE、PUBLIC、INTERFACE含义](https://blog.csdn.net/turbock/article/details/90034787)
> 8. [target_compile_definitions和target_compile_options中第二个参数的含义](https://stackoverflow.com/questions/30546677/cmake-how-to-set-multiple-compile-definitions-for-target-executable)

## <font color=#009A000> 0x00 </font>

`cmake` 是一个构建工具, 其为 `DSL`, 用来生成 `makefile`, 最终编译还是使用的 `make`;

```sh
# 外部构建(推荐使用)
cd /path/to/my/build/folder     # 进入想要存储成果物的文件夹
cmake /path/to/my/source/folder # cmake srcDir
```

## <font color=#009A000> 0x01 example </font>

```cmake
# cmake 内置命令支持大写、小写或者混合使用; 而内置变量是区分大小写的，或者干脆就说，cmake的所有变量都是区分大小写的
# cmake最低版本需求，不加入此行会受到警告信息
cmake_minimum_required(VERSION 3.0.0)

#====================================================================================================================
project(Osd_Neon_Draw_Project C CXX ASM)  #项目名称和支持的语言, 默认省略语言(支持全部)
set(Library_OutPutName "neonOsd")
set(My_Target "neonOsdDemo")	#可执行文件名称

# 是否导出编译过程到 compile_commands.json 文件中
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 配置交叉编译工具链
set(CMAKE_SYSTEM_NAME Linux)
set(ndk_path "/mnt/d/Documents/Desktop/android/android-ndk-r10e")
set(ndk_toolchains_prefix "${ndk_path}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-")
set(CMAKE_C_COMPILER "${ndk_toolchains_prefix}gcc")
set(CMAKE_CXX_COMPILER "${ndk_toolchains_prefix}g++")
set(CMAKE_SYSROOT "${ndk_path}/platforms/android-14/arch-arm") # --sysroot 选项

message(STATUS  "----------------------------------------->")
message(STATUS "project name: " ${PROJECT_NAME})
message(STATUS  "PROJECT_BINARY_DIR:" ${PROJECT_BINARY_DIR})
message(STATUS  "PROJECT_SOURCE_DIR:" ${PROJECT_SOURCE_DIR})
message(STATUS  "CMAKE_C_COMPILER:" ${CMAKE_C_COMPILER})
message(STATUS  "CMAKE_CXX_COMPILER:" ${CMAKE_CXX_COMPILER})
message(STATUS  "CMAKE_SYSROOT:" ${CMAKE_SYSROOT})
message(STATUS  "<-----------------------------------------")

#message(SEND_ERROR "test apoidjacposidjcapsoidj")
#message(FATAL_ERROR "test apoidjacposidjcapsoidj")


# 配置编译的宏
set(gnu_flags " -Wall -Wno-unused -Wconversion -Wno-uninitialized -Wno-sign-conversion ")
set(neno_flags "-mfloat-abi=softfp -mfpu=neon-vfpv4 ")
set(android_5_flags "-fPIE -pie ")
set(CMAKE_CXX_FLAGS " ${gnu_flags} ${neno_flags} ${android_5_flags} ")
set(CMAKE_C_FLAGS " ${gnu_flags} ${neno_flags} ${android_5_flags} ")

#======================================== 库的生成 =================================================================
# 头文件/源文件包含路径
include_directories(./osd_Draw)
aux_source_directory(./osd_Draw src_base_List)

#  libneonOsd.so 和 libneonOsd.a
add_library(${Library_OutPutName}_shared SHARED ${src_base_List}) # add_library 模块名字不能一样;
add_library(${Library_OutPutName}_static STATIC ${src_base_List})
# 重命名 add_library 中的模块名字,
set_target_properties(${Library_OutPutName}_shared PROPERTIES
						OUTPUT_NAME ${Library_OutPutName}
						COMPILE_FLAGS " -O2 ")
set_target_properties(${Library_OutPutName}_static PROPERTIES
						OUTPUT_NAME ${Library_OutPutName}
						COMPILE_FLAGS " -O2 ")

# 设置动态库版本号, 主要是为了解决 linux 上的 dll-hell 问题;
#  [LINUX下动态库及版本号控制](https://blog.csdn.net/David_xtd/article/details/7045792)
# {libname.so.x.y.z (real name) ->  x是主版本号(Major Version Number)，y是次版本号(Minor Version Number)，z是发布版本号(Release Version Number) }
set_target_properties(${Library_OutPutName}_shared PROPERTIES VERSION 1.2.3 SOVERSION 1) 

# 安装共享库和头文件:
# 设置库文件文件输出目录
#set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/install/lib) 
install(TARGETS ${Library_OutPutName}_shared ${Library_OutPutName}_static
		LIBRARY DESTINATION ${PROJECT_SOURCE_DIR}/install/lib
		ARCHIVE DESTINATION ${PROJECT_SOURCE_DIR}/install/lib)
file(GLOB lib_include_files ./osd_Draw/*.h)
install(FILES ${lib_include_files} 
		DESTINATION ${PROJECT_SOURCE_DIR}/install/include)

#========================================== 测试 demo 的生成 =======================================================
# 头文件/源文件包含路径
include_directories(./demo/inc/)
include_directories(${PROJECT_SOURCE_DIR}/osd_Draw/)

# 把当前 src下所有源代码文件和头文件加入变量中
aux_source_directory(./demo/src/ src_demo_List)

# 链接文件夹路径 (使用绝对路径可避免报错)
link_directories(${PROJECT_BINARY_DIR}/)
# link_libraries -> Link libraries to all targets added later. 
# 静态库 (add_executable 之前指定) 
#link_libraries(lib${Library_OutPutName}.a)
add_executable(${My_Target} ${src_demo_List})
target_link_libraries(${My_Target} -lstdc++ -lm -ldl )
target_link_libraries(${My_Target} -l${PROJECT_BINARY_DIR}/lib${Library_OutPutName}.a )

# make install
install(TARGETS ${My_Target} DESTINATION ${PROJECT_SOURCE_DIR}/install
		PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_EXECUTE GROUP_READ WORLD_EXECUTE)

# 配置依赖关系;
add_dependencies(${My_Target}  ${Library_OutPutName}_shared ${Library_OutPutName}_static )
```

## <font color=#009A000> 0x02 总结 </font>

- cmake 内置命令支持大写、小写或者混合使用; 而内置变量是区分大小写的，或者干脆就说，cmake 的所有变量都是区分大小写的;
- 如果要产生其他编译器的 makefile, 则可使用 `-G <generator-name>` 选项;
  - 如 `cmake .. -G Ninja` 等;
  - 注 : 不同平台支持的 `-G` 选项不大一样, 只有 windows 平台的 cmake 支持 vs 工程文件输出;
- 当 cmake 第一次运行一个空的构建的时候，他就会创建一个 `CMakeCache.txt` 文件，文件里面存放了一些可以用来制定工程的设置，比如：变量、选项等
  - 添加变量到 Cache 文件中：`-D` , 如 : `cmake -DCMAKE_BUILD_TYPE:STRING=Debug`
  - `-U` 此选项和 `-D` 功能相反，从 Cache 文件中删除变量，支持使用 `*` 和 `?` 通配符
- CMake 命令行模式：`-E`
  - CMake 提供了很多和平台无关的命令，在任何平台都可以使用：chdir, copy, copy_if_different 等;
- 打印运行的每一行 CMake : `--trace`
- 常用指令 :
  - 成果物 :
    - 可执行文件 : `add_executable(exename srcname)`;
    - lib 库 : `add_library(libname  [SHARED|STATIC|MODULE]  [EXCLUDE_FROM_ALL]  source1 source2 ... sourceN)`;
    - 自定义目标 : `add_custom_target`
  - 头文件路径 :
    - `target_include_directories( <target>  [SYSTEM]  [BEFORE]   <INTERFACE|PUBLIC|PRIVATE>  [items1...]    [<INTERFACE|PUBLIC|PRIVATE>  [items2...] ...])`
    - `include_directories( [AFTER|BEFORE]  [SYSTEM]  dir1 [dir2 …])`
      - ​`[AFTER|BEFORE]` ：指定了要添加路径是添加到原有列表之前还是之后
      - `[SYSTEM]`  ：若指定了system参数，则把被包含的路径当做系统包含路径来处理
  - 库文件 :
    - 添加需要链接的库文件目录 : `link_directories(directory1 directory2 ...)`;
    - 为给定的目标设置链接时使用的库（设置要链接的库文件的名称） : `target_link_libraries( <target> [item1 [item2 [...]]]  [[debug|optimized|general] <item>] ...)`
      - `target_link_libraries` 里的库文件的顺序符合 gcc/g++ 链接顺序规则，即：被依赖的库放在依赖他的库的后面，如果顺序有错，链接将会报错
      - `debug` 对应于调试配置; `optimized` 对应于所有其他的配置类型; `general` 对应于所有的配置（该属性是默认值）;
    - 给当前工程链接需要的库文件（全路径） : `link_libraries` ;
      - 如 : `link_libraries(("/opt/MATLAB/R2012a/bin/glnxa64/libeng.so")` //必须添加带名字的全路径
    - 区别：
      - `target_link_libraries` 可以给工程或者库文件设置其需要链接的库文件，而且不需要填写全路径;
      - 但是 `link_libraries` 只能给工程添加依赖的库，而且必须添加全路径, 因而不常用;
  - 编译选项 :
    - 通过命令行定义的宏变量 :
      - `target_compile_definitions( <target> <INTERFACE|PUBLIC|PRIVATE> [items1...][<INTERFACE|PUBLIC|PRIVATE> [items2...] ...] )`
    - gcc其他的一些编译选项指定，比如 `-fPIC` :
      - `target_compile_options(<target> [BEFORE] <INTERFACE|PUBLIC|PRIVATE> [items1...] [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...]`
    - 
- 变量与缓存 :
  - 局部变量 : `CMakeLists.txt` 相当于一个函数，第一个执行的 `CMakeLists.txt` 相当于主函数，正常设置的变量不能跨越 `CMakeLists.tx` t文件，相当于局部变量只在当前函数域里面作用一样;
  - 缓存变量 : 缓存变量就是 cache 变量，相当于全局变量，都是在第一个执行的 `CMakeLists.txt` 里面被设置的，不过在子项目的 `CMakeLists.txt` 文件里面也是可以修改这个变量的，此时会影响父目录的 `CMakeLists.txt`，这些变量用来配置整个工程，配置好之后对整个工程使用。
    - 如 : `set(MY_CACHE_VALUE "cache_value" CACHE INTERNAL "THIS IS MY CACHE VALUE")
  - 环境变量 :
    - `set(ENV{variable_name} value)`
    - `$ENV{variable_name}`
  - 内置变量 (CMake 里面包含大量的内置变量，和自定义的变量相同，常用的有以下：) :
    - `CMAKE_C_COMPILER` ：指定 `C` 编译器
    - `CMAKE_CXX_COMPILER` ：指定 `C++` 编译器
    - `EXECUTABLE_OUTPUT_PATH` ：指定可执行文件的存放路径
    - `LIBRARY_OUTPUT_PATH` ：指定库文件的放置路径
    - `CMAKE_CURRENT_SOURCE_DIR` ：当前处理的 `CMakeLists.txt` 所在的路径
    - `CMAKE_BUILD_TYPE` ：控制构建的时候是 `Debug` 还是 `Release`, 如 ：`set(CMAKE_BUILD_TYPE Debug)`
    - `CMAKE_SOURCR_DIR` ：无论外部构建还是内部构建，都指的是工程的顶层目录
    - `CMAKE_BINARY_DIR` ：内部构建指的是工程顶层目录，外部构建指的是工程发生编译的目录
    - `CMAKE_CURRENT_LIST_LINE` ：输出这个内置变量所在的行;
