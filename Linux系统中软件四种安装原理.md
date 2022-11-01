# <font color=#0099ff> **Linux系统中软件的“四”种安装原理详解：源码包安装、RPM二进制安装、YUM在线安装、脚本安装包** </font>

> `@think3r` 2020-02-17 21:54:28 <br>
> 参考链接:
> 1. [Linux系统中软件的“四”种安装原理详解：源码包安装、RPM二进制安装、YUM在线安装、脚本安装包](https://segmentfault.com/a/1190000011325357)
> 2. [制作 shell 脚本安装包](https://blog.csdn.net/lu_embedded/article/details/90601743)

- ## <font color=#009A000> 0x00Linux软件包分类 </font>

1. 源码包;
2. 二进制包（RPM 包）;
3. yum 在线安装;
4. 脚本安装包;

PS: 其实 Linux 中软件包只有源码包和二进制（RPM）包两种软件安装包。

## <font color=#009A000> 0x01 源码包安装 </font>

- 优点: 开源，如果有足够的能力，可以修改源代码； 较为安全;<br>
- 缺点: 安装步骤较多; 编译时间较多;

## <font color=#009A000> 0x02 二进制包（RPM 包） </font>

- 优点:
  1. 包管理系统简单，只通过几个命令就可以实现包的安装、升级、查询和卸载；
  2. 安装速度比源码包安装快的多
- 缺点:  依赖性强;

## <font color=#009A000> 0x03 在线安装 </font>

将所有软件包放到官方服务器上，当进行在线安装时，可以自动解决依赖性问题;

- 优点: 简单快捷;
- 缺点: 需要网络支持;

## <font color=#009A000> 0x04 脚本安装包 </font>

所谓的脚本安装包如：lnmp/lamp 一键安装包，就是把复杂的软件包安装过程写成了程序脚本，初学者可以执行脚本实现一键安装。但实际安装的还是源码包和二进制包, 如下图所示。

![sh安装包](./image/sh安装.png)

优点：安装简单、快捷；<br>
缺点：完全丧失了自定义性；

### <font color=#FF4500> 0x05 制作过程 </font>

- 如下为脚本额外添加的内容:

    ```sh
    #!/bin/bash

    lines=9  # 变量 lines 的值是指这个脚本的行数加 1（这个脚本共有 8 行, 因此是 9);
    tail -n+$lines $0 > /tmp/hello.tar.bz2 # $0 表示脚本本身，这个命令用来把从 $lines 开始的内容写入一个 /tmp 目录的 hello.tar.bz2 文件里
    cd /tmp  # 切换到 /tmp 目录操作，解压出来的文件重启系统后将会消失。
    tar jxvf hello.tar.bz2
    cp hello /bin
    exit 0
    ```

- 制作命令: `cat install.sh hello.tar.bz2 > helloinstall.run`
