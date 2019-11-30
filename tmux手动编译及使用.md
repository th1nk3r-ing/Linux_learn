# <font color=#0099ff> **tmux 使用及手动编译 tmux ** </font>

> `@think3r` 2019-11-30 12:06:11

> 1. [Linux手动安装TMUX 编译 以及遇到的问题](https://blog.csdn.net/alvine008/article/details/48027687)
> 2. [configure,pkg-config和PKG_CONFIG_PATH](https://blog.csdn.net/earbao/article/details/17502581)
> 3. [静态编译 Tmux](http://ju.outofmemory.cn/entry/180492)
> 4. [https://www.cnblogs.com/liuguanglin/p/9290345.html](https://www.cnblogs.com/liuguanglin/p/9290345.html)

## <font color=#009A000> 0x00 手动编译 </font>

```sh
# 编译 libevent, 并安装到自定义路径;
git clone https://github.com/libevent/libevent.git
cd libevent
./configure --prefix=/home/think3r/github/bin/
make && make install

# 编译
git clone https://github.com/tmux/tmux.git
cd tmux
./configure  --enable-static --prefix=/home/think3r/github/install/ PKG_CONFIG_PATH=/home/think3r/github/install/lib/pkgconfig/ LIBEVENT_CFLAGS=-I/home/think3r/github/install/include  CFLAGS="-I/home/think3r/github/install/include" LDFLAGS="-L/home/think3r/github/install/lib/"
make && make install

# --enable-static 启动静态编译;
# --prefix 指定安装文件夹;
# PKG_CONFIG_PATH 指定搜索 libevent.pc 的路径;
# LIBEVENT_CFLAGS configure 搜索 libevent 头文件时使用;
# CFLAGS 编译时搜索 libevent 头文件使用;
# LDFLAGS 编译时库的搜索路径;
```

### <font color=#FF4500> 0x01 使用 </font>

1. 输入命令 tmux 使用工具
2. 上下分屏：ctrl + b  再按 "
3. 左右分屏：ctrl + b  再按 %
4. 切换屏幕：ctrl + b  再按 o
5. 关闭一个终端：ctrl + b  再按 x
6. 上下分屏与左右分屏切换： ctrl + b  再按空格键
