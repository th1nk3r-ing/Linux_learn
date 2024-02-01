# <font color=#0099ff> **GCC 使用** </font>

>> `@think3r` 2017-09-03 20:40:39 <br/>
> 参考链接：
> 1. [GCC 基本使用](http://www.cnblogs.com/ggjucheng/archive/2011/12/14/2287738.html)
> 2. [GCC命令](http://man.linuxde.net/gcc)
> 3. [GCC中-O1 -O2 -O3 优化的原理是什么？](https://www.zhihu.com/question/27090458)
> 4. [gcc编译选项--转](https://www.cnblogs.com/fengbeihong/p/3641384.html)
> 5. [Using the GNU Compiler Collection (GCC)](https://gcc.gnu.org/onlinedocs/gcc-10.2.0/gcc/)

## <font color=#009A000> 0x00 测试代码: </font>

```c
//test.c
#include <stdio.h>
int main(void)
{
    printf("Hello World!\n");
    return 0;
}
```

## <font color=#009A000> 0x01 GCC 基本编译指令 </font>

- `gcc (选项) (参数)`
  - 参数: C 源文件
  - 选项如下 :

```shell
-o ：      指定生成的输出文件；
-E ：      仅执行编译预处理；
-S ：      将C代码转换为汇编代码；
-c ：      仅执行编译操作，不进行链接操作。
---------------------优化选项-----------------------------------------------
-O0 :      不做任何优化，这是默认的编译选项.
-O1/-O :  在不影响编译速度的前提下，尽量采用一些优化算法降低代码大小和可执行代码的运行速度。
-O2 :      牺牲部分编译速度，除了执行-O1所执行的所有优化之外，采用几乎所有的目标配置支持的优化算法,
            提高生成代码的执行效率、运行速度。
-03 :      除执行 -O2 所有的优化选项之外，一般都是采取很多向量化算法，提高代码的并行执行程度，
            利用现代 CPU 中的流水线，Cache 等。提高执行代码的大小，降低目标代码的执行时间。
-Os :      在 -O2 的基础之上，尽量的降低目标代码的大小，这对于存储容量很小的设备来说非常重要。
-Og :      精心挑选部分与-g选项不冲突的优化选项，当然就能提供合理的优化水平，
            同时产生较好的可调试信息和对语言标准的遵循程度。
---------------------警告选项-----------------------------------------------
-w :       关闭编译时的警告，也就是编译后不显示任何 warning.
            因为有时在编译之后编译器会显示一些例如数据转换之类的警告，这些警告是我们平时可以忽略的。
-Wall :    显示编译后所有警告。
-W :       选项类似 -Wall，会显示警告，但是只显示编译器认为会出现错误的警告。

    (在编译一些项目的时候可以 -W 和 -Wall 选项一起使用。)
-std= gnu89 c89 c99 c11 指定 gcc 的版本;
-Wl, :    将参数传递给连机器;

---------------------支持的选项-----------------------------------------------
--help    查看帮助文档
--help=?  可为 common|optimizers|params|target|warnings|[^]{joined|separate|undocumented} 等等, 查看具体的支持选项
```

---

```text
-O0, -O1, -O2, -O3, -Ofast, -Os, -Oz, -Og, -O, -O4
    Specify which optimization level to use:
        -O0 Means "no optimization": this level compiles the fastest and generates the most debuggable code.

        -O1 Somewhere between -O0 and -O2.

        -O2 Moderate level of optimization which enables most optimizations.

        -O3 Like -O2, except that it enables optimizations that take longer to perform or that may generate larger code (in an attempt to make the program run faster).

        -Ofast Enables all the optimizations from -O3 along with other aggressive optimizations that may violate strict compliance with language standards.

        -Os Like -O2 with extra optimizations to reduce code size.

        -Oz Like -Os (and thus -O2), but reduces code size further.

        -Og Like -O1. In future versions, this option might disable different optimizations in order to improve debuggability.

        -O Equivalent to -O1.

        -O4 and higher
        Currently equivalent to -O3
```

- `-O0` : None
- `-O1` : Fast
- `-O2` : Faster
- `-O3` : Fastest
- `-Os` : Fastest, Smallest
- `-OFast` : Fastest, Aggressive Optimization
- `-Oz` : Smallest, Aggressive Size Optimization

---

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
        gcc -c testfun.c # 将 testfun.c 编译成 testfun.o
        gcc -c test.c    # 将 test.c 编译成 test.o
        gcc -o testfun.o test.o -o test # 将 testfun.o 和 test.o 链接成 test
        ```

    3. 第一种方法编译时需要所有文件重新编译，而第二种方法可以只重新编译修改的文件，未修改的文件不用重新编译。

## <font color=#009A000> 0x02 库文件链接编译 </font>

- 开发软件时，完全不使用第三方函数库的情况是比较少见的，通常来讲都需要借助许多函数库的支持才能够完成相应的功能。从程序员的角度看，函数库实际上就是一些头文件（.h）和库文件（so、.a、lib、dll）的集合。
- 虽然 Linux 下的大多数函数都默认将头文件放到 `/usr/include/` 目录下，而库文件则放到 `/usr/lib/` 目录下；Windows 所使用的库文件主要放在 Visual Stido 的目录下的 include 和 lib，以及系统文件夹下。但也有的时候，我们要用的库不再这些目录下，所以 GCC 在编译时必须用自己的办法来查找所需要的头文件和库文件。
- Linux下的库文件分为两大类分别是**动态链接库**（通常以.so结尾）和 **静态链接库**（通常以.a结尾），二者的区别仅在于程序执行时所需的代码是在运行时动态加载的，还是在编译时静态加载的。
- 例如我们的程序  `test.c` 是在 Linux 上使用 c 链接 mysql，这个时候我们需要去 mysql 官网下载 MySQL Connectors 的 C 库，下载下来解压之后，有一个 include 文件夹，里面包含 mysql connectors 的头文件，还有一个 lib 文件夹，里面包含二进制 so 文件 `libmysqlclient.so`
  - 其中 inclulde 文件夹的路径是`/usr/dev/mysql/include`, lib 文件夹是`/usr/dev/mysql/lib`
- 编译连接:
  - 首先我们要进行编译 `test.c` 为目标文件:
    - `gcc –c –I /usr/dev/mysql/include test.c –o test.o`
  - 把所有目标文件链接成可执行文件:
    - `gcc –L /usr/dev/mysql/lib –lmysqlclient test.o –o test`
  - 强制链接时使用静态链接库:
    - **默认情况下，GCC 在链接时优先使用动态链接库,** 只有当动态链接库不存在时才考虑使用静态链接库，如果需要的话可以在编译时加上 `-static` 选项，强制使用静态链接库。
    - 在 `/usr/dev/mysql/lib` 目录下有链接时所需要的库文件 `libmysqlclient.so` 和 `libmysqlclient.a` ，为了让GCC在链接时只用到静态链接库，可以使用下面的命令:
      - `gcc –L /usr/dev/mysql/lib –static –lmysqlclient test.o –o test`
- <u>库文件查找顺序 :</u>
  - 静态库链接时搜索路径顺序：
      1. 先会去找 GCC 命令中的参数 `-L` 指定的目录
      2. 再找 gcc 的环境变量 `LIBRARY_PATH`
          - `LIBRARY_PATH` 环境变量：指定程序静态链接库文件搜索路径
      3. 再找内定目录 `/lib` `/usr/lib` `/usr/local/lib` (这是当初 compile gcc 时写在程序内的)
  - 动态链接 & 执行程序时的搜索路径顺序:
      1. 编译目标代码时指定的动态库搜索路径
      2. 环境变量 `LD_LIBRARY_PATH` 指定的动态库搜索路径
          - `LD_LIBRARY_PATH` 环境变量：指定程序动态链接库文件搜索路径
      3. 配置文件 `/etc/ld.so.conf` 中指定的动态库搜索路径
      4. 默认的动态库搜索路径 `/lib`
      5. 默认的动态库搜索路径 `/usr/lib`

## <font color=#009A000> 0x03 GCC 进阶 </font>

- **<u>说明:</u>**
  - 如下内容均来自阅读 `<<深入理解计算机系统>>` 中的查缺补漏;
- [GCC编译选项 `-m64 -m32 -mx32`](https://blog.csdn.net/yyywill/article/details/54426900)
  - 编译 `32/64` 位程序
- [int, int32_t, int64_t, intprt_t](https://www.cnblogs.com/Free-Thinker/p/7058773.html)
  - > 为了避免由于依赖 "典型" 大小和不同的编译器设置带来的奇怪行为, ISO C99 引入了一类数据类型, 其数据大小是固定的, 不随编译器和机器设置而变化. 其中就有 `int32_t, int64_t` .
  - 尽量使用固定长度数据类型, 可以很方便的进行代码的移植;
  - `printf` 时, 请使用格式化字符串 `"%"PRId64`, 避免不同架构下的 warning;
- [ssize_t 和 size_t 详解](https://blog.csdn.net/lplp90908/article/details/50405899)
  - `printf` 64 位数值时, 请使用格式化字符串 `"%zu"`, 避免不同架构下的 warning;
- 指针的大小一般与该计算机的字长相等
  - > 每台计算机都一个字长, 指明指针数据的标称大小.
  - [指针的大小到底是由谁决定？是多少？](https://www.cnblogs.com/noble/p/4144167.html)
    - **<u>指针大小是由当前 CPU 运行模式的寻址位数决定</u>**
- gcc 分析头文件依赖:
  - `gcc -I ../common/ -I ../common_dsp -M -H dsp.h 2>&1 | grep -v "usr"`
  > 参考链接如下:
  > 1. [open-source-tools-examine-and-adjust-include-dependencies](http://gernotklingler.com/blog/open-source-tools-examine-and-adjust-include-dependencies/)
  > 2. [Linux 重定向：一些重定向问题的解决](http://blog.chinaunix.net/uid-28903506-id-4931889.html)
  > 3. [2>&1 使用](https://www.cnblogs.com/yangyongzhi/p/3364939.html)
- <u>编译选项传递 :</u>
  - `-Wl,<options>` 告诉编译器将后面的参数传递给链接器
    > Pass comma-separated <options> on to the linker.
    > if the linker is being invoked indirectly, via a compiler driver (e.g. gcc) then all the linker command line options should be prefixed by -Wl, (or whatever is appropriate for the particular compiler driver) like this: `gcc -Wl,--start-group foo.o bar.o -Wl,--end-group`, This is important, because otherwise the compiler driver program may silently drop the linker options, resulting in a bad link.
    > 翻译 : 如果链接器是通过编译器驱动程序(例如 gcc)间接调用的，那么所有链接器命令行选项都应该像这样以 `-Wl` 作为前缀(或者任何适合特定编译器驱动程序的前缀) `gcc -Wl,--start-group foo.o bar.o -Wl,--end-group` ; 这一点很重要，因为否则编译器驱动程序可能会悄无声息地删除链接器选项，从而导致错误链接。

    - **静态库动态库混合使用** : `-Wl,-Bstatic -ltestlib -Wl,-Bdynamic -lhaha` :
      - `testlib` 使用静态库 后续其他库 `haha` 使用动态库;
      - 最后的 `-Wl,-Bdynamic` 表示将缺省库链接模式恢复成动态链接
  - `-Wa,<options>` 传递给汇编器
    > Pass comma-separated <options> on to the assembler.
  - `-Wp,<options>` 传递给预处理器
    > Pass comma-separated <options> on to the preprocessor.
- [动态库的链接和链接选项-L，-rpath-link，-rpath](https://my.oschina.net/shelllife/blog/115958)
- 编译 so 时启用 BuildID :
  - `-Wl,--build-id`;
  - 可通过 `file` 或者 `readelf -x .note.gnu.build-id libxxx.so` 看出来;

### <font color=#FF4500> TODO :  </font>

1. [这些__attribute__的知识你应该知道](https://www.jianshu.com/p/9ca8ccc7e881)
2. [Java中@Deprecated作用、使用以及引用](https://blog.csdn.net/u013361445/article/details/49777741)
