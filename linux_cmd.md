# <font color=#0099ff> **linux 命令** </font>

## <font color=#0099ff> **常用命令** </font>

- `ls`
  - <font color=#EA00DA>ls 相关通配符与正则表达式.</font>
    - `ls *.md`
    - `ls Linux?.md`
    - `ls Linux[34].md`
    - `ls Linux[a-f].md`
- `cd`  
  - `cd -` 跳至上一次操作的路径
  - 文件的连接数... 软硬链接.
- `pwd`
- `clear`
- `history`
- 绝对路径 & 相对路径
- tab 按键
  - 可补全一些文件名、路径等
  - 双击可提示多个
- `touch` 创建一个文件
- 使刚刚修改的 `~/.bashrc` 生效: `source .bashrc`

## <font color=#009A000> 0x00 搜索 </font>

- `find 搜索路径 参数 搜索内容`
  - `-name` '文件名'
  - `-size` 
  - `-type`
    - d 仅查找文件夹
    - f 进查找普通文件
  - `-ctime` `-mtime` `-atime`
    - `-n` n 天以内.
  - `-printf` 指定输出格式(文件名中有特殊字符时使用)
    - `%p` File's name.
  - `maxdepth` `mindepth` 搜索深度
  - `-ok` 或 `-exec` 执行的命令 `{} \;`
      -高级用法: `find ./ -name "*.md" -size +10k | xargs ls -alh`
- `grep -r '搜索内容' 搜素路径`
  - `grep -r "颜色空间" ./ -n`
  - 在某个目录下的头文件中找到某个字符串:
    - `find ./ -name "*.h" | xargs grep "字符串"`
  - 寻找历史命令行中相关的命令:
    - `histroy | grep dpigs*`
  - `grep -R -n "软件"`
    - 递归搜索并显示行号;
## <font color=#009A000> 0x01 压缩解压缩 </font>
- `gzip`  
  - `*.gz`
- `bzip2`
  - `*.bz2`
- `tar` 打包:
  - `c` 创建压缩文件
  - `x` 释放压缩文件
  - `v` 打印提示信息
  - `f` 指定压缩包名
  - `z` 使用 `gzip` 压缩文件 
    - `xxx.tar.gz`
  - `j` 使用 `bzip2` 方式压缩文件
    - `xxx.tat.bz2`
  - 压缩: `tar 参数 压缩包名字 原材料`
    - `tar zcvf test.tar.gz file/dir`
  - 解压缩:
    - `tar zxvf tes .tar.gz -C 解压目录`
- `rar` 
  - 需要安装,
  - `rar a 压缩包名 原材料`
  - `rar x 压缩包名 解压目录名`
  - 操作目录时加 `-r`
- `zip`
  - `zip 参数 压缩包名 原材料`
  - `unzip 压缩包名 -d 解压目录`
- `who` : 查看当前系统有谁在线与否;

## <font color=#009A000> 0x02 软件的安装、卸载、更新 </font>
- ubuntu 在线安装:
  - `sudo apt-get install 安装包名`
  - `sudo apt install 安装包名`
      - ubuntu 16.04 以上
- **源码安装:**
  - 下载源码, 查看源码中的 `readme.md` 文档, 根据不同编译需求安装
    - `sudo apt-get remove 安装包名`
- 软件卸载:
  - `sudo apt-get autoremov`
- 系统中的软件更新:
  - 搜索 `Software and Updates(软件更新)`, 测试并选择其他站点中最快的镜像站点, 用来加速 update.
    - 一般选择 <u>阿里云</u> 的站点即可;
  - `sudo apt-get update` 更新本地软件列表
  - `sudo apt-get dist-upgrade` 更新所有的软件.
  - [Ubuntu解决:无法获得锁](https://www.jianshu.com/p/8768e5bccfa8)
      1. kill 占用的进程( linux 只允许开一个 apt-get，当然 apt-get 和新立得也是只能同时开一个):
          - `ps -aux|grep apt-get`
          - `sudo kill PID`
      2. 直接强制删除 lock 文件:
          - `sudo rm /var/lib/dpkg/lock`
          - `sudo rm /var/lib/apt/lists/lock` 
- 系统清理：
  - `sudo apt-get clean`  清空缓存
    - `/var/cashe/apt/archives`
    - `sudo apt-get autoclean`
  - `dpigs -H --lines=20`
    - 倒序查看当前占用比较大的软件包名, 以便卸载;
    - 软件包安装:
      - ubuntu: `*.deb`
        - `sudo dpkg -i *.deb`
        - `sudo dpkg -r 软件名`
- 删除不用的内核(慎用):
  - `uname -a` 查看内核版本;
  - `dpkg --get-selections | grep linux` 查看系统所有内核;
  - `sudo apt-get remove 【内核名】`  内核号较小的一般都能删除.
  - `sudo dpkg -P 包名` 删除已删除包的配置文件(状态位 `deinstall` 的包);
- 磁盘清理:
    > [清理VMware虚拟机磁盘，解决虚拟机磁盘只增不减问题](https://blog.csdn.net/doctor_warren/article/details/81286991)
    - `sudo dd if=/dev/zero of=/0bits bs=20M` 将碎片空间填充上 0，结束的时候会提示磁盘空间不足，忽略即可
    - `sudo rm  /0bits` 删除第二步的填充，如果用 `df -h` 会发现可用的虚拟空间增加许多，但是实际的磁盘空间没有缩减
- [Linux wc 命令](https://www.runoob.com/linux/linux-comm-wc.html)
  - `wc -l` 统计行数, for example :
    - `find . -name "*.o" | wc -l`
    - `ls pwd/*.c | wc -l`

## <font color=#009A000> 0x03 vi / vim  </font>

- `vimtutor`
  - 内置教程
- `vi` linux 自带
- `vim` 需安装
- 三种工作模式
  - 命令行模式
  - 编辑模式
  - 末行模式

## <font color=#009A000> 0x04 文本查找替换 </font>

```sh
# 删除匹配行
sed -i '/onechunk.xsl/d'

## 文本查找替换
sed -i "s/python/python3/" ~/.autojump/bin/autojump

# 特殊字符使用 \ (空格, #, / 等均需要转义)
sed -i "s/\#\!\/usr\/bin\/env\ python/\#\!\/usr\/bin\/env\ python3/" ~/.autojump/bin/autojump

# 文件名中包含特殊字符(如: 空格, 中文)
# find ./ -name "*.md" -printf "\"%p\"" 在文件路径周围添加引号
find ./ -name "*.md" -printf "\"%p\"\n"| xargs sed -i "s/<\/font>\ /<\/font>/"
```

## <font color=#009A000> 0x02 pdf 工具 </font>

> [MacOS PDF分割和合并](https://www.jianshu.com/p/002a4bad9f9b)

- [xpdf --> pdf 命令行工具](http://www.xpdfreader.com/)
- [pdfunite --> github 开源 pdf 合并工具](https://github.com/mtgrosser/pdfunite)

| 命令 | 功能 |
| --- | --- |
| pdfunite | 合并 pdf |
| pdftotext | pdf 转 text |
| pdftops | pdf 转 ops |
| pdftoppm | pdf 转 ppm |
| pdftohtml | pdf 转 html |
| pdftocairo | pdf 转 cairo |
| pdfsig | pdf 签名 |
| pdfseparate | 拆分 pdf |
| pdfinfo | pdf 元数据 |
| pdfimages | pdf 转图片 |
| pdffonts | 提取 pdf 字体 |
| pdfdetach | 删除 pdf 内置附件 |
| pdfattach | 给 pdf 添加附件 |
| pdf2ps | pdf 转 ps |
| pdf2dsc | pdf 转 dsc |
