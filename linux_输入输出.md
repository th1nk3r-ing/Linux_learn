# <font color=#0099ff> **linux 输入输出** </font>

> `@think3r` 2019-11-24 18:02:19  
> 1. [重定向编程 dup和dup2函数](https://blog.csdn.net/u010006102/article/details/39667875)
> 2. [man-stdin](http://man7.org/linux/man-pages/man3/stdin.3.html)

## <font color=#009A000> 0x00 stdin, stdout, stderr </font>

在 linux 中经常会看到 stdin，stdout 和 stderr，这 3 个可以称为终端（Terminal）的标准输入（standard input），标准输出（ standard out）和标准错误输出（standard error）. 

### <font color=#FF4500> 如下为 stdin 的 manPage 内容及其翻译; </font>

> Under normal circumstances every UNIX program has three streams opened for it when it starts up, one for input, one for output, and one for printing diagnostic or error messages. These are typically attached to the user's terminal (`see tty(4)` but might instead refer to files or other devices, depending on what the parent process chose to set up. (See also the "Redirection" section of `sh(1)`.)
- 在正常情况下，每个UNIX程序在启动时都会打开三个流，一个用于输入，一个用于输出，还有一个用于打印诊断或错误消息。这些通常附加到用户的终端(请参阅 tty(4))，但也可能引用文件或其他设备，这取决于父进程选择设置什么。(参见 sh(1) 的“重定向”部分)。
> Each of these symbols is a stdio(3) macro of type pointer to FILE, and can be used with functions like fprintf(3) or fread(3).
- 这些符号都是指向文件的指针类型的 stdio(3) 宏，可以与 fprintf(3) 或 fread(3) 等函数一起使用。
> On program startup, the integer file descriptors associated with the streams stdin, stdout, and stderr are 0, 1, and 2, respectively. The preprocessor symbols STDIN_FILENO, STDOUT_FILENO, and STDERR_FILENO are defined with these values in <unistd.h>. (Applying freopen(3) to one of these streams can change the file descriptor number associated with the stream.)
  - 在程序启动时，与流 stdin、stdout 和 stderr 关联的整数文件描述符分别为 0、1 和 2。预处理符号 `STDIN FILENO、STDOUT FILENO` 和 `STDERR FILENO` 在 `<unistd.h>` 中使用这些值定义。(对其中一个流应用 freopen(3)可以更改与该流关联的文件描述符号。)
> The stream stderr is unbuffered. The stream stdout is line-buffered when it points to a terminal. Partial lines will not appear until fflush(3) or exit(3) is called, or a newline is printed. This can produce unexpected results, especially with debugging output. The buffering mode of the standard streams (or any other stream) can be changed using the setbuf(3) or setvbuf(3) call. Note that in case stdin is associated with a terminal, there may also be input buffering in the terminal driver, entirely unrelated to stdio buffering. (Indeed, normally terminal input is line buffered in the kernel.)
- 流 stderr 是无缓冲的。 当流 stdout 指向终端时，它是行缓冲的。 在调用 `fflush（3 ` 或 `exit（3）` 或打印换行符之前，不会出现部分行。 这可能会产生意外结果，尤其是调试输出时。 可以使用 `setbuf（3）` 或 `setvbuf（3）` 调用来更改标准流（或任何其他流）的缓冲模式。 注意，在 stdin 与终端相关联的情况下，终端驱动程序中也可能存在输入缓冲，与 stdio 缓冲完全无关。 （实际上，通常终端输入在内核中是行缓冲的。）这个内核输入处理可以使用像 tcsetattr（3）这样的调用来修改。 另见 stty（1）和 termios（3）。

## <font color=#009A000> 0x01 tty 和 终端 到底是什么? </font>

> [辛星浅析tty、pty与pts](https://www.2cto.com/os/201502/378314.html)

- 首先我们还是从概念入手，所谓 `tty`，它是 TeletypeWriter 的缩写，它的中文翻译就是电传打字机，它的主要功能就是打印信息和阅读信息，后来被键盘和显示器所取代。而 tty 现在通俗一点的理解就是终端。
- 终端又是什么呢？它就是一种电子的或者机电的硬件设备，它可以用来向大型主机输入数据并且显示来自主机的数据。在计算机的早期，很多计算机都会连接若干个终端控制台，这些终端的硬件结构都很简单，它们不执行计算的任务，它们只是负责输入用户的命令，并且把计算的结果反馈回来。
- 前面我们的电传打字机就可以理解为最早的计算机终端，当然我们有了键盘、鼠标和显示器之后，这个东西就成了历史。此时的终端的概念也有了稍许的变化，因为之前的一个设备可以完成两个功能，而现在分成了两个设备，也就是现在的显示器不再包含字符生成的功能。
- 后来我们引入了虚拟终端的功能，这就是 `pty`，它是 `pseudo tty` 的简写，也有人称之为伪终端，比如我们使用远程 `telnet` 到主机时就可以理解为一个伪终端。
  - 在我们实现 pty 的过程中，我们又引入了两个概念：
    - 既然我们要做到 pty，那么就需要有的设备是被连接的，它们就可以理解为 ptmx，可以理解为一个 `master`。
    - 而有些设备时需要去主动连接的，它们就可以理解为 pts，可以理解为一个 slave。
  - 而对于 pty 的这两个虚拟设备之间，又有两种命名格式，如下：
    - 对于 BSD 风格的，`slave` 一般使用 `/dev/tty[p-za-e][0-9a-f]` 这种格式，而 `master` 一般使用 `/dev/pty[p-za-e][0-9a-f]` 这种格式。
    - 对于 Unix98 这种风格的，`slave` 一般使用 `/dev/pts/n` , 而 `master` 一般使用的是 `/dev/ptmx` .
- shell 命令 `tty`
    > `print the file name of the terminal connected to standard input`
- `/dev/tty`
  - 控制终端，即当前用户正在使用的终端，是一个映射，指向当前所使用的终端（例如 `/dev/tty1, /dev/pts/0` ）。往 `/dev/tty` 下写数据总是写到当前终端。
  - `echo "test" > /dev/tty`
- `/dev/ttyn` 的 `n` 表示数字
  - 虚拟终端;
  - 切换终端: `Ctrl + Alt + Fn`;
- `/dev/pts/n`
  - 伪终端，这个是终端的发展，为满足现在需求,例如网络登录的 `telnet/ssh` 就是使用伪终端。
  - 这是 UNIX98 的实现风格，slave 为 `/dev/pts/n` 时，master 一般为 `/dev/ptmx`。
- `/dev/ttySn`
  - 串行终端，串口设备对应的终端。
- `/dev/console`
  - 应用层的控制台，一些进程的打印信息会输出到控制台。在用户层和内核都有一个 console，分别对应 `printf` 和 `printk` 的输出。
  - kernel 下的 console 是输入输出设备 driver 中实现的简单的输出 console，只实现 `write` 函数，并且是直接输出到设备。
  - user 空间下的 console，实际就是 tty 的一个特殊实现，大多数操作函数都继承 tty，所以对于 console 的读写，都是由 kernel 的 tty 层来最终发送到设备。

## <font color=#009A000> 0x02 基础 </font>

一般来说，普通输出函数（如：`printf` ），默认是将某信息写入到文件描述符为 1 的文件中，普通输入函数都默认从文件描述符为 0 的文件中读取数据。因此重定向操作实际上是关闭某个标准输入输出设备（文件描述符为 0、1、2），而将另一个打开的普通文件的文件描述符设置为 0、1、2.

- 如果多个进程的 printf 需要定向到一个 telnet 的 haul 那么即使你这样操作了也不行。为什么呢？原因是：
  - linux 中每个进程都有自己的堆栈，那么对于所有的文件描述符啊，`socket` 啊。。。。这些 `fd` 都是只在本身的进程起作用的，当我们用上面的代码进行操作的话那么，你打开的 `fd` 是当前 `printf` 在的进程的重定向. 这样的重定向只会将当前进程的 `printf` 的定向到当前 telnet，而其他的进程的 `printf` 则不会定向到 telnet。
- `int dup(int oldfd)`
  - 函数 `dup` 允许你复制一个 oldfd 文件描述符。存入一个已存在的文件描述符，它就会返回一个与该描述符“相同”的新的文件描述符。即这两个描述符共享相同的内部结构，共享所有的锁定，读写位置和各项权限或 flags 等等。
  - 例如：对一个文件描述符进行了 `lseek` 操作，另一个文件描述符的读写位置也会随之改变。不过，文件描述符之间并不共享 `close-on-exec flags`.
  - 对 `fd` 或 `newfd` 进行读写操作时对同一个文件操作，而且还可以看到 `fd` 关闭后，对 `newfd` 没有影响，使用 `newfd` 还可以操作打开的文件。
- `int dup2(int oldfd, int newfd);`
    > `dup2()` makes `newfd` be the copy of `oldfd`, closing `newf`d first if necessary;  After a successful return from one of these system calls, the old and new file descriptors may be used interchangeably.  They refer to the same open file description (see `open(2)`) and thus share file offset and file status flags; for example, if the file offset is modified by using `lseek(2)` on one of the descriptors, the offset is also changed for the other.
    - `dup2` 用来复制参数 `oldfd` 所指的文件描述符，并将 `oldfd` 拷贝到参数 `newfd` 后 一起返回。若参数 `newfd` 为一个打开的文件描述符，则 `newfd` 所指的文件会先被关闭，若 `newfd` 等于 `oldfd`，则返回 `newfd`, 而不关闭 `newfd` 所指的文件。`dup2` 所复制的文件描述符与原来的文件描述符共享各种文件状态。共享所有的锁定，读写位置和各项权限或 `flags` 等等.

## <font color=#009A000> 0x03 原理 </font>

- 输入 `stdin` 重定向：关闭标准输入设备，打开（或复制）某普通文件，使其文件描述符为 0.
- 输出 `stdout` 重定向：关闭标准输出设备，打开（或复制）某普通文件，使其文件描述符为 1.
- 错误 `stderr` 输出重定向：关闭标准错误输入设备，打开（或复制）某普通文件，使其文件描述符为 2.
- [<u>**测试 demo 源码**</u>](./code/tty_redirect/test_outPut.c)
- 输出重定向实例:

```c 
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

/* 使用方法: 
    开启: echo  `tty` > ./openLog
    关闭: rm -rf ./openLog */

static int stdout_fd = -1;
static int out_fd = -1;

int redirect_StdOut(char * ttyName)
{
    int ret = -1;

    if (ttyName == NULL)
    {
        Cprintf_red("[%s %d]  err! param:[%p].\n", __FUNCTION__, __LINE__, ttyName);
        return -1;
    }

    out_fd = open(ttyName, O_WRONLY);
    if (out_fd < 0)
    {
        Cprintf_red("[%s %d] open tty:[%s] error! %s.\n",
            __FUNCTION__, __LINE__, ttyName, strerror(errno));
        return -1;
    }
    else
    {
        Cprintf_green("[%s %d] open OK!\n", __FUNCTION__, __LINE__);
    }

    /* 复制标准输出描述符, 待后续恢复 */
    if(stdout_fd < 0)
    {
        stdout_fd = dup(STDOUT_FILENO);
        if(stdout_fd < 0)
        {
            Cprintf_red("[%s %d] dup error! %s.\n", 
                __FUNCTION__, __LINE__, strerror(errno));

            close(out_fd);
            out_fd = -1;

            return -1;
        }
        else
        {
            Cprintf_green("[%s %d] dup STDOUT_FILENO OK!\n", __FUNCTION__, __LINE__);
        }
    }

    /* 替换标准输入输出 */
    ret = dup2(out_fd, STDOUT_FILENO);
    if ( ret < 0)
    {
        Cprintf_red("[%s %d] dup2 error! %s.\n", 
            __FUNCTION__, __LINE__, strerror(errno));

        close(stdout_fd);
        stdout_fd = -1;
        close(out_fd);
        out_fd = -1;

        return -1;
    }
    else
    {
        Cprintf_green("[%s %d] dup2 OK!\n", __FUNCTION__, __LINE__);
    }

    return 0;
}


int redirect_StdOut_Reset(void)
{
    int ret = -1;

    /* 没有进行输出重定位, 直接返回 */
    if(out_fd < 0)
    {
        Cprintf_red("[%s %d] error! out_fd:[%d]\n", __FUNCTION__, __LINE__, out_fd);
        return -1;
    }

    /* 替换标准输入输出 */
    ret = dup2(stdout_fd, STDOUT_FILENO);
    if ( ret < 0)
    {
        Cprintf_red("[%s %d] dup2 error! %s.\n", 
            __FUNCTION__, __LINE__, strerror(errno));
        return -1;
    }
    else
    {
        Cprintf_green("[%s %d] dup2 OK!\n", __FUNCTION__, __LINE__);
    }

    /* 关闭之前打开的文件,           释放资源 */
    close(stdout_fd);
    stdout_fd = -1;
    close(out_fd);
    out_fd = -1;

    return 0;
}

#define REDIRECT_SWITCH_FILE          "./openLog"

void redirect(void)
{
    static unsigned int bHaveFile = 0;
    FILE * fp = NULL;
    char ttyName[256];

    if ((access(REDIRECT_SWITCH_FILE, F_OK | R_OK) >= 0) && (bHaveFile == 0))
    {
        fp = fopen(REDIRECT_SWITCH_FILE, "r");
        if( fp == NULL)
        {
            Cprintf_red("[%s %d] dup error! %s.\n", 
                __FUNCTION__, __LINE__, strerror(errno));
            return;
        }
        else
        {
            memset(ttyName, 0x00, sizeof(ttyName) * sizeof(char));
            /* 读取文件第一行的内容 */
            fgets(ttyName, sizeof(ttyName) * sizeof(char), fp );       
            fclose(fp);

            /* 去除字符串末尾换行符 */
            if(ttyName[strlen(ttyName) - 1] == 0xa)
            {
                ttyName[strlen(ttyName) - 1] = 0;
            }

            Cprintf_yellow("[%s %d]  ttyName:[%s]\n", 
                __FUNCTION__, __LINE__, ttyName);

            if(redirect_StdOut(ttyName) == 0)
            {
                bHaveFile = 1;
            }
        }
    }

    if((access(REDIRECT_SWITCH_FILE, F_OK) < 0) && (bHaveFile == 1))
    {
        redirect_StdOut_Reset();
        bHaveFile = 0;
    }

    return;
}
```
