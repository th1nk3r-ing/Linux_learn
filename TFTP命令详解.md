# <font color=#0099ff> **TFTP 命令** </font>

> `@think3r` 2017-08-07 22:50:21
> 参考链接 : 
>   1. [tftp命令](http://man.linuxde.net/tftp)
>   2. [tftp使用方法](http://blog.sina.com.cn/s/blog_7d7e9d0f0101ifoz.html)

## <font color=#009A000> 一、TFTP 简介 </font>

- tftp 命令用在本机和 tftp 服务器之间使用 TFTP 协议传输文件。
- TFTP 是用来下载远程文件的最简单网络协议，它其于 UDP 协议而实现。
- 嵌入式 linux 的 tftp 开发环境包括两个方面：
    - linux 服务器端的 tftp-server 支持
    - 嵌入式目标系统的 tftp-client 支持
- busybox 中内置了 tftp 的命令支持。

## <font color=#009A000> 二、 tftp 命令的用法 </font>

- `tftp [option] [参数]`   
    - tftp 默认占用 `69` 端口。
- **选项(option):**

 ````
   -g 表示下载文件 (get), 下载文件时用.
   -p 表示上传文件 (put), 上传文件时用，
   -l 表示本地文件名(local file), 后跟存在于 Client 的源文件名，
        或下载 Client 后重命名的文件名。
   -r 表示远程主机的文件名(remote file), 后跟 Server 即 PC 机 tftp 服务器根目录中的
        源文件名，或上传 Server 后重命名后的文件名。
   -b SIZE Transfer blocks of SIZE octets (暂存多大数据后再写入, 可加快传输速度.)
   ````


## <font color=#009A000> 三、TFTP 命令说明 </font>

- 主要用法:
    - `tftp –g/-p 目标文件名  源文件名  服务器地址`

- 一些说明:

| 说明 | 选项 | 目标文件名 | 源文件名 |
|----|----|----|-----|
| 说明 | `-g` 表示下载 | 加参数 `-l` , 可与源文件相同或不同 | 加参数 `-r` , 不可改名 | 
| 说明 | `-p` 表示上传 | 加参数 `-r` , 可与源文件相同或不同 | 加参数 `-l` , 不可改名 |
||||

<div STYLE="page-break-after: always;"></div><!------------------分页符------------------->


## <font color=#009A000> 四、 TFTP 命令实例 </font>


- **更名** 的上传与下载: 
    - 从 server 中的 tftp 根目录下，下载文件 `A.txt` 到 Client 并更名为 `B.txt` ；

      ````   
      tftp –g –l B.txt     –r  A.txt  192.168.1.2    
      tftp –g –l 目标文件名 –r 源文件名 服务器地址
      ````      
        
    - 从 Client 上传文件 `C.txt` 到 Server 的 tftp 根目标下，并更名为 `D.txt` ；     

      ````
      tftp –p –r D.txt –l C.txt 192.168.1.2      
      tftp –p –r 目标文件名  -l 源文件名 服务器地址
      ````

- **不重命名** 的上传与下载:
    - 不更名从服务器 *下载* :
        - `tftp –g –l/-r 源文件名   服务器地址`
            - 此时参数 `-l` 与 `-r` (对于服务器根目录下的文件)，使用时只使用其中一个;
        - 从远程 `tftp` 主机下载 **指定目录下的文件** (相对 tftp 服务器目录), 且不更名:
           - `tftp -gr ./test/test.c 10.10.0.16 -b 8192`
           - **必须是 `-r` 选项** ,
    - 不更名 *上传* 文件至服务器:
        - `tftp –p –l/-r 源文件名   服务器地址`   
        - （此时参数-l与-r等效，使用时只使用其中一个）
