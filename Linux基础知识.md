# <font color=#0099ff> **Linux基础知识** </font>

- `Linux` 操作系统的发展过程：
  > 参见： 《鸟哥的 Linux 私房菜》 —— `Linux 之前， Unix 的历史`。

    - 1965 年以前, 为大型单主机多终端模式. 单仅一般仅能支持 30 台终端.
    - 1969 年, Ken Tompson 利用妻子探亲的 1 个月时间, 编写出来了 <u>**Unix**</u>  操作系统的原型.
    - 1970 年, Ken Tompson 以 BCPL 语言为基础, 设计出很接近硬件的 B语言, 并利用它写出了第一个 UNIX 操作系统.
    - 但 B语言的跨平台性比较差, 为了能将 UNIX 移植到其他电脑上, Dennis Ritchie & Ken Tompson 在 B 语言的基础上开发了一个新的语言: C语言.
    - 1973年, Tompson & Ritchie 利用 C完全重写了  UNIX 操作系统.
    - <u>**Minix**</u>
        - 一个教授因 `Version 7  UNIX` 之后的私有化对教学的不方便而编写, 但其仅为教学使用, 并未不断添加一些实用的功能.
    - <u>**Linux:**</u>
        - 此处省略.......

- 当前市面上的主要操作系统:
     
    - ![当今市面上的主要操作系统](./image/当今主要操作系统.JPG)

- Linux 目录:
    - /user 应用程序存放
    - /home 用户家目录
    - 
- Linux 隐藏文件以 `.` 开头
- Linux 没有后缀的说法.

<div STYLE="page-break-after: always;"></div><!------------------ 分页符 ----------------->

# <font color=#0099ff> **GNG** </font>

1984 年，`Richard Mathew Stallman` 开始 GNU 计划， 这个计划癿目的是：建立一个自由、开放的 Unix 操作系统(Free Unix)。 但是建立一个操作系统谈何容易啊！而丏在当时癿 GNU 是仅有自己一个人单打独斗癿叱托曼～ 这实在太麻烦，但又丌想放弃这个计划，那可怎举办啊？



# <font color=#0099ff> **Linux 基础知识** </font>

> `@think3r` 2017-09-03 19:04:43

## <font color=#009A000> 一、常用命令 </font>

- 调出图形计算器:
    - `gnome-calculator` 
- 调出图形截图工具
    - `gnome-screenshot -i`
- 终端中的一些命令:
    - 放大: `ctrl + shift + \+`
    - 缩小: `ctrl + \-`

## <font color=#009A000> 二、软件管理 </font>

    
- 更新Linux 软件:
    - `sudo apt-get update` 更新软件源 & 读取软件包列表
    - `sudo apt-get dist-upgrade` 更新所有的软件.
- 安装单独的软件:
    - `sudo apt-get install 软件名`
- ubuntu 开机启动脚本:
    - `sudo vim /etc/rc.local`
    - 开启 SSH 服务:
        - `sudo /etc/init.d/ssh start`
        - 查看 ssh 服务器 `ps -e | grep ssh`
            - 出现 `sshd` 即为 ssh server

- 安装 `chrome`
- linux 下的 7 中文件类型:
    - 普通文件 f, 目录 d, 符号链接 l, 管道 p,  套接字 s, 字符设备 c, 块设备b.
- 搜素
    - find, `find 搜索路径 参数 搜索内容`
        - `-name` '文件名'
        - `-size` 
        - `-type`
        - `-ctime` `-mtime` `-atime` 
            -  -n n天以内.
        - `maxdepth` `mindepth` 搜索深度
        - `-ok` 或 `-exec` 执行的命令 `{} \;`
            -高级用法: `find ./ -name "*.md" -size +10k | xargs ls -alh`
    - `grep -r '搜索内容' 搜素路径`
        - `grep -r "颜色空间" ./ -n`
- 

## <font color=#009A000> 三  </font>

- 压缩解压缩:
    - 解压缩:
        |压缩包类型|解压命令|    
        |---|---|   
        |`*.tar.gz`| `tar xzvf fileName`|
    - 压缩:
        |压缩包类型|压缩命令|    
        |---|---|

- 

