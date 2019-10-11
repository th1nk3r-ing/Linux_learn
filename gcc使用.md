# <font color=#0099ff> **GCC 使用** </font>

>> `@think3r` 2017-09-03 20:40:39  

> 参考链接： 
>1. [GCC 基本使用](http://www.cnblogs.com/ggjucheng/archive/2011/12/14/2287738.html)
>2. [GCC命令](http://man.linuxde.net/gcc)
>3. [GCC中-O1 -O2 -O3 优化的原理是什么？](https://www.zhihu.com/question/27090458)

## <font color=#009A000> 零、测试代码: </font>

```c
//test.c
#include <stdio.h>
int main(void)
{
    printf("Hello World!\n");
    return 0;
}
```



## <font color=#009A000> 一、GCC 基本编译指令 </font>

- `gcc (选项) (参数)`
  - 参数: C 源文件
  - 选项如下 :

```shell
-o：      指定生成的输出文件； 
-E：      仅执行编译预处理； 
-S：      将C代码转换为汇编代码； 
-c：      仅执行编译操作，不进行连接操作。
---------------------优化选项-----------------------------------------------
-O0:      不做任何优化，这是默认的编译选项.
-O1 / -O: 在不影响编译速度的前提下，尽量采用一些优化算法降低代码大小和可执行代码的运行速度。
-O2:      牺牲部分编译速度，除了执行-O1所执行的所有优化之外，采用几乎所有的目标配置支持的优化算法,
            提高生成代码的执行效率、运行速度。
-03:      除执行 -O2 所有的优化选项之外，一般都是采取很多向量化算法，提高代码的并行执行程度，
            利用现代 CPU 中的流水线，Cache 等。提高执行代码的大小，降低目标代码的执行时间。
-Os:      在 -O2 的基础之上，尽量的降低目标代码的大小，这对于存储容量很小的设备来说非常重要。
-Og:      精心挑选部分与-g选项不冲突的优化选项，当然就能提供合理的优化水平，
            同时产生较好的可调试信息和对语言标准的遵循程度。
---------------------警告选项-----------------------------------------------
-w:       关闭编译时的警告，也就是编译后不显示任何 warning, 
            因为有时在编译之后编译器会显示一些例如数据转换之类的警告，这些警告是我们平时可以忽略的。
-Wall:    显示编译后所有警告。
-W:       选项类似 -Wall，会显示警告，但是只显示编译器认为会出现错误的警告。

    (在编译一些项目的时候可以 -W 和 -Wall 选项一起使用。)
-std= gnu89 c89 c99 c11 指定 gcc 的版本;
```

- `gcc test.c`
    - 将test.c预处理、汇编、编译并链接形成可执行文件。这里未指定输出文件，默认输出为a.out。 

- 一步到位的编译指令: **`gcc test.c -o test`**
    - 包含了如下四个编译过程：
        1. 预处理 (Preprocess)：
            - `gcc -E test.c -o test.i` 或 `gcc -E test.c`
        2. 编译为汇编代码 (Compilation)：
            - `gcc -S test.i -o test.s`
        3. 汇编 (Assembly):
            - `gcc -c test.s -o test.o`
        4. 连接 (Linking):
            - `gcc test.o -o test`

- **多源文件编译方法**
    1. `gcc testfun.c test.c -o test` 
        - 将 `testfun.c` 和 `test.c` 分别编译后链接成 `test` 可执行文件。   
    2. 分别编译各个源文件，之后对编译后输出的目标文件链接。 
        ```shell
        gcc -c testfun.c #将testfun.c编译成testfun.o 
        gcc -c test.c #将test.c编译成test.o 
        gcc -o testfun.o test.o -o test #将testfun.o和test.o链接成test 
        ```
    3.第一中方法编译时需要所有文件重新编译，而第二种方法可以只重新编译修改的文件，未修改的文件不用重新编译。


## <font color=#009A000> 二、库文件链接编译 </font>

- 开发软件时，完全不使用第三方函数库的情况是比较少见的，通常来讲都需要借助许多函数库的支持才能够完成相应的功能。从程序员的角度看，函数库实际上就是一些头文件（.h）和库文件（so、或lib、dll）的集合。

- 虽然 Linux 下的大多数函数都默认将头文件放到     `/usr/include/` 目录下，而库文件则放到 `/usr/lib/` 目录下；Windows 所使用的库文件主要放在 Visual Stido 的目录下的 include 和 lib，以及系统文件夹下。但也有的时候，我们要用的库不再这些目录下，所以 GCC 在编译时必须用自己的办法来查找所需要的头文件和库文件。

- Linux下的库文件分为两大类分别是**动态链接库**（通常以.so结尾）和 **静态链接库**（通常以.a结尾），二者的区别仅在于程序执行时所需的代码是在运行时动态加载的，还是在编译时静态加载的。

- 例如我们的程序  `test.c` 是在 linux 上使用 c 连接 mysql，这个时候我们需要去 mysql 官网下载 MySQL Connectors的 C库，下载下来解压之后，有一个 include文件夹，里面包含mysql connectors 的头文件，还有一个 lib 文件夹，里面包含二进制 so 文件 `libmysqlclient.so`
    - 其中 inclulde 文件夹的路径是`/usr/dev/mysql/include`, lib 文件夹是`/usr/dev/mysql/lib`
- 编译连接:
    - 首先我们要进行编译test.c为目标文件:
        - `gcc –c –I /usr/dev/mysql/include test.c –o test.o`
    - 把所有目标文件链接成可执行文件:
        - `gcc –L /usr/dev/mysql/lib –lmysqlclient test.o –o test`
    - 强制链接时使用静态链接库:
        - 默认情况下， GCC 在链接时优先使用动态链接库，只有当动态链接库不存在时才考虑使用静态链接库，如果需要的话可以在编译时加上 `-static` 选项，强制使用静态链接库。
        - 在 `/usr/dev/mysql/lib` 目录下有链接时所需要的库文件 `libmysqlclient.so` 和 `libmysqlclient.a` ，为了让GCC在链接时只用到静态链接库，可以使用下面的命令:
            - `gcc –L /usr/dev/mysql/lib –static –lmysqlclient test.o –o test`
- 库文件查找顺序:
    - 静态库链接时搜索路径顺序：          
        1. 先会去找 GCC 命令中的参数 `-L` 指定的目录     
        2. 再找 gcc 的环境变量 LIBRARY_PATH       
        3. 再找内定目录 `/lib` `/usr/lib` `/usr/local/lib` 这是当初 compile gcc 时写在程序内的
        - `LIBRARY_PATH` 环境变量：指定程序静态链接库文件搜索路径
    - 动态链接时、执行时搜索路径顺序:
        1. 编译目标代码时指定的动态库搜索路径
        2. 环境变量 LD_LIBRARY_PATH 指定的动态库搜索路径
        3. 配置文件 `/etc/ld.so.conf` 中指定的动态库搜索路径
        4. 默认的动态库搜索路径 `/lib`
        5. 默认的动态库搜索路径 `/usr/lib`
        - LD_LIBRARY_PATH 环境变量：指定程序动态链接库文件搜索路径

## <font color=#009A000> 三、GCC 进阶 </font>
- **<u>说明:</u>**  
    - 如下内容均来自阅读 `<<深入理解计算机系统>>` 中的查缺补漏~     
    - 其中的引用内容均来自 <<深入理解计算机系统>>

- [GCC编译选项 -m64 -m32 -mx32](https://blog.csdn.net/yyywill/article/details/54426900)
    - 编译 32/64 位程序
- [int, int32_t, int64_t](https://www.cnblogs.com/Free-Thinker/p/7058773.html)
    - > 为了避免由于依赖 "典型" 大小和不同的编译器设置带来的奇怪行为, ISO C99 引入了一类数据类型, 其数据大小是固定的, 不随编译器和机器设置而变化. 其中就有 `int32_t, int64_t` .
    - 尽量使用固定长度数据类型, 可以很方便的进行代码的移植;
- [size_t类型](https://www.cnblogs.com/zzw818/p/6912959.html)
- 指针的大小一般与该计算机的字长相等
    - > 每台计算机都一个字长, 指明指针数据的标称大小. 
    - [指针的大小到底是由谁决定？是多少？](https://www.cnblogs.com/noble/p/4144167.html)

- gcc 分析头文件依赖:
    - `gcc -I ../common/ -I ../common_dsp -M -H dsp.h 2>&1 | grep -v "usr"`
    > 参考链接如下:
    > 1. [open-source-tools-examine-and-adjust-include-dependencies](http://gernotklingler.com/blog/open-source-tools-examine-and-adjust-include-dependencies/)
    > 2. [Linux 重定向：一些重定向问题的解决](http://blog.chinaunix.net/uid-28903506-id-4931889.html)
    > 3. [2>&1使用](https://www.cnblogs.com/yangyongzhi/p/3364939.html)
    > 4. `grep -v`
