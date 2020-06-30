# <font color=#0099ff> **ubuntu 设置** </font>

> `@think3r` 2017-11-09 0:3:52



## <font color=#009A000> **0x-1 待读** </font>

- [mac 装了 oh my zsh 后比用 bash 具体好在哪儿？](https://www.zhihu.com/question/29977255)
- `.rc_add` 修改 :
  - mac 的 prt 配置(仅添加至 mac);
  - mac 的 `PS1` 配置到 (zsh);
- 修改整个的配置流程, 如 `bashrc` 和 `zshrc` 的 `source` 命令追加, 最终导出一个文件夹给;
- vim 进阶;

## <font color=#009A000> 0x-2 杂项软件 </font>

- 换源 : [https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/](https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/)
- `sudo apt-get install sl cmake cloc ffmpeg tree busybox shellcheck`
- `sudo apt-get install zsh`

## <font color=#009A000> 0x-3 </font>

1. ssh 配置(手动 U 盘拷贝);
2. git clone 仓库(Linux 和 git)
3. `.bashrc` 和 `.zshrc` 配置;
4. autojump 和 incr 配置;

---

## <font color=#009A000> 0x00 vmware 虚拟机安装 </font>

- [Ubuntu 各版本代号简介](https://blog.csdn.net/zhengmx100/article/details/78352773)
- 国内镜像:
  - [Ubuntu18.04更换国内源（阿里，网易，中科大，清华等源）](https://www.cnblogs.com/fanbi/p/10423080.html)
  - [http://mirrors.163.com](http://mirrors.163.com)
  - [https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/](https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/)
- 安装略;
  - [Operating System not found for VMware解决方案](https://blog.csdn.net/dearbaba_8520/article/details/80506349)
  - 更新源修改为阿里云:
    - 搜索 `Software and Updates(软件更新)`, 测试并选择其他站点中最快的镜像站点, 用来加速 update.
- 安装 VMWare-Tools;

## <font color=#009A000> 0x00 vmware 安装 ubuntu 虚拟机 </font>

- [Ubuntu 修改用户密码与启动root账号](http://blog.csdn.net/guanggy/article/details/4636884)
  - ubuntu 的默认账号不是 root? root 需要单独启用??

- ### <font color=#FF4500> ssh 相关 </font>
  - [Ubuntu18.04 ssh 开机自动启动的设置方法如下](https://blog.csdn.net/fandroid/article/details/86799932)

      ```sh 
      # 安装 ssh
      sudo apt-get install openssh-server

      # 开机自动启动ssh命令
      sudo systemctl enable ssh

      # 关闭ssh开机自动启动命令
      sudo systemctl disable ssh

      # 单次开启ssh
      sudo systemctl start ssh

      # 单次关闭ssh
      sudo systemctl stop ssh

      # 设置好后重启系统
      reboot

      #查看ssh是否启动，看到Active: active (running)即表示成功
      sudo systemctl status ssh
      ```

  - 查看当前的ubuntu是否安装了ssh-server服务。默认只安装ssh-client服务: `dpkg -l | grep ssh` 
  - 确认 ssh 服务是否启动: `ps -e | grep ssh`
  - 开启 ssh 连接虚拟机中的 ubuntu 的方法:
    - <a href="http://www.cnblogs.com/ifantastic/p/3415182.html" target="_blank">如何使用 SSH 连接 VMWare 虚拟机中的 Ubuntu</a>
    - <a href="http://blog.csdn.net/crave_shy/article/details/23124895" target="_blank">Linux学习笔记之——ssh连接虚拟机中的ubuntu12.0.4
- <a href="https://www.jianshu.com/p/d69a95aa1ed7" target="_blank">ubuntu 16.04 设置静态IP</a>
  - `sudo vim /etc/network/interfaces`
  - [2019-04-02 Ubuntu 18.04 配置静态IP](https://www.jianshu.com/p/2283b95a81d9)
- ~~[**linux ssh 开启颜色显示**](http://www.cnblogs.com/bamanzi/p/colorful-shell.html)~~ (WSL 默认即可显示颜色无需更改)
  - 直接复制 `.bashrc` 中的颜色方案即可. cmder 使用较为方便
    - 编辑 `~/.bashrc`，设置 `force_color_prompt=yes`　即可（找到 `force_color_prompt=yes` 这一行并删除前面的注释符号
  - <a href="http://blog.csdn.net/wangyang1354/article/details/58077671" target="_blank">编码与颜色值</a>
  - 设置 ssh 连接时的 shell 配色方案为 ubuntu 自带(`~/.bashrc` 中添加):

  ```sh
  #设置ssh连接时的shell配色方案为 ubuntu 自带
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  ```

- 取消与 windows 共享文件夹时, windows 文件夹的背景色:

    ```sh 
    echo "eval \`dircolors $HOME/.dir_colors\`" >> ~/.bashrc
    echo "OTHER_WRITABLE 4;40" > ~/.dir_colors
    ```

- ~~<a href="https://www.zhihu.com/question/46525639" target="_blank">怎样解决Windows10时间快和Ubuntu时间差问题？
</a> 提供以下两种方法:~~ (ubuntu 18.04.1 此问题解决, 无需手动修改了)
    1. 在 Ubuntu 中把计算机硬件时间改成系统显示的时间，即禁用 Ubuntu的 UTC:
        - `timedatectl set-local-rtc 1 --adjust-system-clock`
    2. 修改 Windows 对硬件时间的对待方式，让 Windows 把硬件时间当作UTC. 
        - `win + r` 执行: `Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1`
- 与 windows 共享文件夹:
  - ubunru 设置:
    - `虚拟机` -> `设置` -> `选项` -> `共享文件夹`
  - 创建文件夹软连接:
    - `ln -s /mnt/hgfs/win-Desktop/ /home/th1nk3r/`
    - 注意需要使用绝对路径, 否则会出现错误: `符号连接的层数过多`;

### <font color=#FF4500> git 相关 </font>

- 安装 git: `sudo apt-get install git`
- 设置 
  - `git clone https://gitee.com/think3r/git_learn.git` 
  - 拷贝其中的 `.gitconfig` 至 `~` 目录下;
  - 根据码云的帮助文档进行新的 git 公钥的添加;

- **配置 ssh 显示 git 分支** :
  - >参考链接: <a href="https://www.jianshu.com/p/82783f76a868" target="_blank">让 Shell 命令提示符显示 Git 分支名称
</a>
  - `~/.bashrc` 添加如下代码, 之后 `source ~/.bashrc` 使能更改: 

```sh 
function parse_git_branch_and_add_brackets {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}
#PS1="\h:\W \u\[\033[0;32m\]\$(parse_git_branch_and_add_brackets) \[\033[0m\]\$ "
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[0;32m\]\$(parse_git_branch_and_add_brackets)\[\033[0m\]\$ "
#也就是在原来的 PS1 后添加: 
# \[\033[0;32m\]\$(parse_git_branch_and_add_brackets)\[\033[0m\]\$ 
```

### <font color=#FF4500> autojump </font>

```sh
# 0x00
git clone https://github.com/wting/autojump.git #拷贝源码

# 0x01 python2 的安装方法
sudo apt install python #安装 python
cd autojump && ./install.py #进入目录并安装

# 0x01 python3 的安装方法:
sudo apt install python3
python3 install.py
sed -i "s/\#\!\/usr\/bin\/env\ python/\#\!\/usr\/bin\/env\ python3/" ~/.autojump/bin/autojump

# .bashrc 添加脚本支持
# j -a `pwd` 添加常用路径
```

### <font color=#FF4500> ssh 备份后恢复: </font>

```bash
cp -r .ssh ~/
# fix: 权限相关
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 644 ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/id_rsa
```

### <font color=#FF4500> 解决 python pip install慢的方法 </font>

```sh
# file: ~/.pip/pip.conf
# pip 源: 清华;  (解决pip install慢的方法)[https://blog.csdn.net/yang5915/article/details/83175804]
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
```



## <font color=#009A000> **ubuntu 系统备份** </font>

- 分区与安装挂在目录的选择;
- 一些相关设置的操作步骤;
- 更新文件与脚本的备份与使用;
- <font color=#EA00DA>**ubuntu 常用软件&设置的安装脚本**</font>
- 先使用虚拟机设置 ubuntu 环境. 之后在进行整机的安装.
- <font color=#9664FF>学习使用 VIM, 同时 vscode 也安装 `vim` 和 `vi` </font>
- <font color=#EA00DA>cmder 配置与备份</font>
  - alias 设置: `C:\Program Files My\cmder\vendor\git-for-windows\etc`
