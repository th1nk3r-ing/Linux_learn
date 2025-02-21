# <font color=#0099ff> **socket 编程** </font>

> `@think3r` 2024-09-18 21:49:18 <br/>
>
> 1. <<深入理解计算机系统>>
> 2. [Socket编程入门 - Socket通信技术简明教程](https://www.dotcpp.com/course/socket/)
> 3. [SSH比SSL更高层，更安全？请看两者4大区别—基于原理和协议](https://www.51cto.com/article/594591.html)
> 4. [最大连接数65535，服务器是如何应对百万千万的并发的？](https://zhuanlan.zhihu.com/p/646383328)
>    - [linux的TCP连接数量最大不能超过65535个，那服务器是如何应对百万千万的并发的？](https://www.zhihu.com/question/384470425)

## <font color=#009A000> 0x00 socket 编程 </font>

- 同步，就是在发出一个功能调用时，在没有得到结果之前，该调用就不返回，同时其它线程也不能调用这个方法。
- 异步，就是发出一个功能调用后，不管没有结果的返回，都不影响当前任务的继续执行。即两个生产线相互独立。
- 网络字节顺序(network byte order) : 大端字节顺序
- 域名 (domain name)
  - 因特网定义了域名集合和 IP 地址集合之间的映射。直到 1988 年，这个映射都是通过一个叫做 `H0STS.TXT` 的文本文件来手工维护的。从那以后，这个映射是通过分布世界范围内的数据库（称为 DNSCDomainNameSystem, 域名系统））来维护的。
  - 查看制定 DNS 返回的域名解析 : `nslookup IP DNS`
  - 在某些情况下，多个域名可以映射为同一个 IP 地址
  - 多个域名可以映射到同一组的多个 IP 地址
- 毎个套接字都有相应的套接字地址 : 由一个因特网地址和一个 16 位的整数端口组成, 即 `地址：端口`
  - 当客户端发起一个连接请求时，客户端套接字地址中的端口是由内核自动分配的，称为临时端口 (ephemeral port)
  - 然而，服务器套接字地址中的端口通常是某个知名端口，是和这个服务相对应的
    - Web 服务器通常使用端口 `80`
    - 而电子邮件服务器使用端口 `25`
    - ssh 服务器使用端口 `22`
    - `/etc/services` 包含一张这台机器提供的知名名字和知名端口之间的映射
  - —个连接是由它两端的套接字地址唯一确定的。这对套接字地址叫做套接字对(socket pair) : `(cliaddr: cliport , servaddr :servport)`

```c
/* IP address structure */
struct in_addr {
    uint32_t s_addr; /* Address in network byte order (big-endian) */
}

// 'n' 代表网络， 'p' 代表表示。
#include <arpa/inet.h>
int inet_pton(AF_INET, const chax *src, void *dst); // 返回：若成功则为 1，若 src 为非法点分十进制地址则为 0, 若出错则为一1。
const char *inet_ntop(AF_INET, const void *src, char *dst, socklen_t size); // 返回：若成功则指向点分十进制字符串的指针，若出错则为 NULL

// _in 为 internet 的缩写
/* IP socket address structure */
struct sockaddr_in {
    uintl6_t sin_family;        /* Protocol family (always AF_INET) */
    uintl6_t sin_port;          /* Port number in network byte order */   // 16bit 端口号
    struct in_addr sin_addr;    /* IP address in network byte order */    // IP　地址
    unsigned char sin_zero[8];  /* Pad to sizeof(struct sockaddr) */
};
/* Generic socket address structure (for connect, bind, and accept) */
struct sockaddr {
  uintl6_t sa_family;           /* Protocol family */
  char sa_data[14];             /* Address data */    // 填充字节 : 2 + 4 + 8 = 14 ; sizeof(sockaddr) = sizeof(sockaddr_in)
}

// NOTE: sockaddr 和 sockaddr_in 两个结构体之间可强制转换, 以解决当时没有 `void*` 的问题


// getaddrinfo() 函数
struct addrinfo {
    int ai_flags;                 /* AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST */
    int ai_family;                /* PF_xxx */                                // IPV*/IPV4/IPV6
    int ai_socktype;              /* SOCK_xxx */                              // TCP/UDP
    int ai_protocol;              /* 0 or IPPROTO_xxx for IPv4 and IPv6 */
    socklen_t ai_addrlen;         /* length of ai_addr */
    char  * ai_canonname;         /* canonical name for hostname */
    struct  sockaddr *ai_addr;    /* binary address */
    struct  addrinfo *ai_next;    /* next structure in linked list */         // 链表...
}
```

![socket_func](../image/socketFunc.png)

## <font color=#009A000> Web </font>

对于 Web 客户端和服务器而言，内容是与一个 `MIME` (Multipurpose Internet MailExtensions 多用途的网际邮件扩充协议)类型相关的字节序列.

Web 服务器以两种不同的方式向客户端提供内容：

- 取一个磁盘文件，并将它的内容返回给客户端。磁盘文件称为静态内容(static content), 而返回文件给客户端的过程称为服务静态内容(serving static content)
- 运行一个可执行文件，并将它的输出返回给客户端。运行时可执行文件产生的输出称为动态内容 (dynamic content), 而运行程序并返回它的输出到客户端的过程称为服务动 态内容 (serving dynamic content)。
  - 确定一个 URL 指向的是静态内容还是动态内容没有标准的规则。
- URL(Universal Resource Locator, 通用资源定位符) : `http://ww.google.com:80/index.html`
  - 端口号是可选的，默认为知名的 HTTP 端口 80
  - 可执行文件的 URL 可以在文件名后包括程序参数。`？` 字符分隔文件名和参数，而且每个参数都用 `&` 字符分隔开 : `http://bluefish.ics.cs.emu.edu:8000/cgi-bin/adder?15000&213`
  - 后缀中的最开始的那个 `/` 不表示 Linux 的根目录。相反，它表示的是被请求内容类型的主目录
  - 最小的 URL 后缀是 `/` 字符，所有服务器将其扩展为某个默认的主页，例如 `/index.html` 这解释了为什么简单地在浏览器中键人一个域名就可以取出一个网站的主页
    - `baidu.com` = `baidu.com/index.html`
- ~~因为 HTTP 是基于在因特网连接上传送的文本行的，我们可以使用 Linux 的 `TELNET` 程序来和因特网上的任何 Web 服务器执行事务。~~

---

### <font color=#FF4500> 大小端和网络 </font>

- 大端：高字节存放低地址，低字节存放高地址；
- 小端：低字节存放低地址，高字节存放高地址。
- UDP/TCP/IP协议规定：把收到的第一个字节当作高位字节看待 : 因为我们的机器通常情况下是小端字节序，在写网络数据传输时最开始建立连接去初始化 `sockaddr_in` 时，经常要先把 IP 和端口转换成大端模式(使用 `inet_addr，htons`)
  - 既然网络传输协议规定了传输使用的是大端字节序，那为什么又只把IP地址，端口等转成大端格式，数据部分却不进行大小端转换呢？
  - 网络传输协议规定了要大端化，那么对于各级交换机、路由器提取报文中的 MAC、IP 也应该是大端化的，这样统一便于做比对去查找路由表。
  - 大端模式的高地址, 方便了比较, 更便于网络硬件寻址的处理
  那么为什么数据部分又不大端化呢？数据大小端的差异与机器的存储方式有关，而与传输方式无关。也就是说，网络包都是以大端的方式传输，而传输到本地对包做解析时，不管你是按大端传来的还是按小端传来的，接收方将变量赋值给本地变量，还是只能将先拿到的字节存在低地址。
