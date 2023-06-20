# <font color=#0099ff> **docker 学习笔记** </font>

> `@think3r` 2023-06-19 19:09:16
>
> 1. [全面的 Docker 快速入门教程](https://zhuanlan.zhihu.com/p/435605760)
> 2. [Docker for Mac 的网络问题及解决办法（新增方法四）](https://www.haoyizebo.com/posts/fd0b9bd8/)
> 3. [菜鸟教程 -- Docker 教程](https://www.runoob.com/docker/docker-tutorial.html)
> 4. [如何制作Docker镜像（image）？](https://zhuanlan.zhihu.com/p/122380334)
> 5. [突破 DockerHub 限制，全镜像加速服务](https://zhuanlan.zhihu.com/p/256359308)
> 6. [DockerHub 里面有哪些好用的镜像?](https://www.zhihu.com/question/426345980)
> 7. [Docker 命令大全 - runoob](https://www.runoob.com/docker/docker-command-manual.html)
> 8. [macos 中 docker 的存储路径问题](https://www.cnblogs.com/robinunix/p/12795456.html)

Docker 是一个开源的应用容器引擎，基于 Golang 语言开发，可以让开发者打包他们的应用以及依赖包到一个轻量级、可移植的容器中，然后发布到任何流行的 Linux 服务器。容器是一个沙箱机制，相互之间不会有影响（类似于我们手机上运行的 app），并且容器开销是很低的。

Docker 是一个供开发人员和系统管理员构建、运行和与容器共享应用程序的平台。使用容器部署应用程序称为容器化。容器并不是新事物，但它们用于轻松部署应用程序却是新鲜的。

<u>注意：Docker 并非是一个通用的容器工具，**它依赖于已存在并运行的 Linux 内核环境。**</u>

Docker 的优势 :

- 灵活性：即使是最复杂的应用程序也可以容器化。
- 轻量级：容器利用并共享主机内核，使它们在系统资源方面比虚拟机更有效率。
- 可移植：您可以在本地构建，部署到云上，并在任何地方运行。
- 松耦合：容器是高度自给自足和封装的，允许您在不影响其他容器的情况下替换或升级其中一个。
- 扩展：您可以跨数据中心增加和自动分发容器副本。
- 安全性：容器对进程应用主动约束和隔离，而不需要用户进行任何配置。

<u>**Docker的出现主要就是为了解决：在我的机器上运行时是正常的，但为什么到你的机器上就运行不正常了。**</u>

## <font color=#009A000> 0x00 基本概念 </font>

docker 中有这样几个概念 ：

- DockerFile : image 的源代码 (docker 可看做编译器)
- Image : 镜像(docker 的可执行程序), 一个'虚拟机'的快照.
  - 操作系统分为内核和用户空间。对于 Linux 而言，内核启动后，会挂载 root 文件系统为其提供用户空间支持。
  - 而 Docker 镜像（Image），就相当于是一个 root 文件系统。
  - Docker 镜像是一个特殊的文件系统，除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等）。
  - 镜像不包含任何动态数据，其内容在构建之后也不会被改变。
- Container : image 运行之后的进程 (镜像运行时的实体)
  - 容器的实质是进程，但与直接在宿主执行的进程不同，容器进程运行于属于自己的独立的命名空间。
  - 前面讲过镜像使用的是分层存储，容器也是如此。容器存储层的生存周期和容器一样，容器消亡时，容器存储层也随之消亡。
    - 因此，任何保存于容器存储层的信息都会随容器删除而丢失。
- Repository :（仓储）集中存放镜像文件的地方
  - 镜像构建完成后，可以很容易的在当前宿主上运行，但是， 如果需要在其它服务器上使用这个镜像，我们就需要一个集中的存储、分发镜像的服务（就像Git仓库一样），Docker Registry 就是这样的服务。
  - 一个 Docker Registry 中可以包含多个仓库（Repository），每个仓库可以包含多个标签（Tag），每个标签对应一个镜像。
  - 所以说：镜像仓库是 Docker 用来集中存放镜像文件的地方类似于我们之前常用的代码仓库。通常，一个仓库会包含同一个软件不同版本的镜像，而标签就常用于对应该软件的各个版本 。我们可以通过 `<仓库名>:<标签>` 的格式来指定具体是这个软件哪个版本的镜像。如果不给出标签，将以 `latest` 作为默认标签。

docker 使用了常见的 `CS` 架构，也就是 client-server 模式.

- docker client 负责处理用户输入的各种命令，比如 `docker build`、`docker run`。
- 真正工作的其实是 server，也就是 docker demon，值得注意的是，docker client 和 docker demon 可以运行在同一台机器上。
  - Docker 客户端和守护进程通过 UNIX 套接字或网络接口使用 REST API 进行通信。

常用的 docker 命令 :

1. `docker build` : 当我们写完 dockerfile 交给 docker “编译”时使用这个命令，那么 client 在接收到请求后转发给 docker daemon，接着 docker daemon 根据 dockerfile 创建出“可执行程序” image
2. `docker run` : 有了“可执行程序” image 后就可以运行程序了，接下来使用命令 docker run，docker daemon 接收到该命令后找到具体的 image，然后加载到内存开始执行，image 执行起来就是所谓的 container。
3. `docker pull` : docker 中 image 的概念就类似于“可执行程序”，我们可以从哪里下载到别人写好的应用程序呢？
   - 很简单，那就是 APP Store，即应用商店。与之类似，既然 image 也是一种“可执行程序”，那么有没有 "Docker Image Store" 呢？
   - 答案是肯定的，这就是 `Docker Hub`，docker 官方的“应用商店”，你可以在这里下载到别人编写好的 image，这样你就不用自己编写 `dockerfile` 了。docker registry 可以用来存放各种 image，公共的可以供任何人下载 image 的仓库就是 docker Hub。
   - 用户通过 docker client 发送命令，docker daemon 接收到命令后向 docker registry 发送 image 下载请求，下载后存放在本地，这样我们就可以使用 image 了。
   - `docker search xxx` : 搜索某某镜像

NOTE: 一些需要注意的问题 :

1. 容器只打包了用户空间的系统调用，执行系统调用的地方依然是宿主的 kernel，所以当你 docker run centos:6 bash 执行这句话的时候，在新的内核上可能会发生段错误，而老的宿主机却不会。真正要做到 BORE，还是必使用同样的内核.
2. decker 的一些管理工具
   - [Portainer - github](https://github.com/portainer/portainer)
   - DockStation
   - Docker Desktop

## <font color=#009A000> 0x01 docker 的底层实现原理 </font>

docker 基于 Linux 内核提供这样几项功能实现的：

1. NameSpace :
   1. 我们知道 Linux 中的 PID、IPC、网络等资源是全局的，而 NameSpace 机制是一种资源隔离方案，在该机制下这些资源就不再是全局的了，而是属于某个特定的N ameSpace，各个 NameSpace 下的资源互不干扰，
   2. 这就使得每个 NameSpace 看上去就像一个独立的操作系统一样，但是只有 NameSpace 是不够。
2. Control groups :
   1. 虽然有了 NameSpace 技术可以实现资源隔离，但进程还是可以不受控的访问系统资源，比如 CPU、内存、磁盘、网络等，
   2. 为了控制容器中进程对资源的访问 Docker 采用 control groups 技术(也就是 `cgroup`)有了 cgroup 就可以控制容器中进程对系统资源的消耗了，比如你可以限制某个容器使用内存的上限、可以在哪些 CPU 上运行等等。

## <font color=#009A000> 0x02 docker 的镜像制作 </font>

制作 Docker 镜像一般有2种方法：

1. 使用 hub 仓库中已有的环境，安装自己使用的软件环境后完成 image 创建
2. 通过 Dockerfile，完成镜像 image 的创建

## <font color=#009A000> 0x03 实战 </font>

1. `docker info` : 查看 docker 的基本信息
2. 配置 docker 阿里云镜像 :
   1. `~/.docker/daemon.json` 中加入 `"registry-mirrors": ["https://xxxx.mirror.aliyuncs.com"]`
   2. docker for Desktop 中修改配置
3. `docker run` 相关 :
   1. `-d` : detach, Run container in background and print container ID (后台运行容器，并返回容器ID)
      - 其后可接 image 名称
   2. `-i` : 以交互模式运行容器，通常与 -t 同时使用
   3. `-t` : 为容器重新分配一个伪输入终端，通常与 -i 同时使用；
   4. `-p` : 指定端口映射，格式为：主机(宿主)端口:容器端口
   5. `--name="nginx-lb"` : 为容器指定一个名称
   6.
4. `docker ps` : 查看正在运行的容器
   - `-a` 查看所有(终止)状态的容器
   - `-q` 查看对应的 container ID
5. docker 的生命周期 :
   ![docker 生命周期](../image/docker%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F.png)
   1. `docker create` : `created`, 初建状态
   2. `docker run` : `running` / `Up`, 运行状态
      - `docker start` ： 容器转为运行状态；
   3. `docker stop` : `stopped` / `exited`, 停止状态
   4. `docker pause ：` paused, 停状态
   5. `docker unpause` ： 取消暂停状态，容器进入运行状态；
   6. `docker kill` : 容器在故障（死机）时，执行 kill（断电），容器转入停止状态，这种操作容易丢失数据，除非必要，否则不建议使用；
   7. `docker rm -f xxx` : deleted：删除状态
   8. `dead` : 死亡
6. 进入正在运行的 container 的两种方法 :
   1. `docker exec -it containerId /bin/bash` : 进入正在运行的容器并开启一个新的终端
   2. `docker attach containerId` : 进入容器正在执行的终端，不会启动新的进程
      - 如果使用 `exit` 退出，容器会停止运行！
      - 如果想退出容器但不想容器停止，则按住 `Ctrl+P+Q` 退出
7. docker 文件/存储相关 :
   1. `docker cp 本地路径 容器id或者容器名字:容器内路径` : 本地到服务器
8. docker 生成自定义镜像(修改启动命令)的方式 :
   1. Dockerfile 的方式修改命令 :

        ```Dockerfile
        FROM image:demo  #要改动命令的镜像
        WORKDIR /root/  #执行命令的工作目录路径
        CMD ["python","main.py"] # 要更改的命令
        ```

   2. 直接通过 commit 修改 : `docker commit --change="WORKDIR /" -c 'CMD [ "bash" ]'  -m "基础ubuntu镜像" -a 'think3r' 639b37671e5c  outImage:v1`
      1. `–change` : Apply Dockerfile instruction to the created image (可以写入 dockerfile 的语法语句)
      2. `-c` : Apply Dockerfile instruction to the created image(可以写入启动命令)
      3. `-m` : --message string, Commit message
9. 导入和导出容器 :
   1. 导出 : `docker export 1e560fca3906 > ubuntu.tar`
   2. 导入 : `cat docker/ubuntu.tar | docker import - test/ubuntu:v1`
10. 清理掉所有处于终止状态的容器 : `docker container prune`

### <font color=#FF4500> docker 操作命令 </font>

```sh
apt-get update && apt-get upgrade
apt-get install ca-certificates # 更新 ca 证书
# 更改为清华源
apt-get install vim-tiny tree file zsh inetutils-ping
# git clone 拷贝 oh-my-zsh 及其插件
```
