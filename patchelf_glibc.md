# <font color=#0099ff> **patchelf of glibc** </font>

> `@think3r` 2025-07-04 23:26:12

如下以 git 为例...

## <font color=#009A000> 0x00 下载准备 </font>

- `sudo apt-get install zstd patchelf`
- 下载 : <https://launchpad.net/~git-core/+archive/ubuntu/ppa/+packages>
  - 需下载 man 和 git 本地的 `deb` 包
- `git clone https://github.com/matrix1001/glibc-all-in-one.git`
  - `update_list` 改为 python3
  - `./update_list`
  - `./download 2.39-0ubuntu8_amd64` 安装指定版本 git

## <font color=#009A000> 0x01 解包 deb </font>

- `dpkg-deb -x git_2.49.0-2\~ppa1\~ubuntu25.04.1_amd64.deb git_249`
- `dpkg-deb -e git_2.49.0-2~ppa1~ubuntu25.04.1_amd64.deb ./git_249/DEBIAN`
- 删除 `git_249/DEBIAN/control` 中的依赖 ...

## <font color=#009A000> 0x02 patchelf 修改 : </font>

- `patchelf --set-interpreter /xxx/bin/glibc-all-in-one/libs/2.39-0ubuntu8_amd64/ld-linux-x86-64.so.2  ./git`
- `patchelf --replace-needed libc.so.6 /xxx/bin/glibc-all-in-one/libs/2.39-0ubuntu8_amd64/libc.so.6 git`

```sh
#!/bin/bash

# 遍历当前目录下的所有文件
find ./git_249 -type f -executable -print0 | while IFS= read -r -d $'\0' file; do
    if file "$file" | grep -q "script"; then
        echo "跳过脚本文件: $file"
        continue
    fi
    # 检查是否为可执行文件（普通文件且具有可执行权限）
    # if [[ -f "$file" && -x "$file" ]]; then
        echo "=== 处理可执行文件: $file ==="

        # ===== 在此处替换为您需要执行的命令 =====
        # 示例命令1：打印文件信息
        echo "📄 执行命令1：文件信息"
        file "$file"

        # 示例命令2：计算文件哈希值
        echo "🔒 执行命令2：SHA256校验"
        sha256sum "$file"

        # 自定义命令区域（替换以下注释部分）
        # 命令1替换位置（例如：./"$file" --option1）
        # 命令2替换位置（例如：cp "$file" /backup/)
        # ====================================
        patchelf --set-interpreter /home/thinker/bin/glibc-all-in-one/libs/2.39-0ubuntu8_amd64/ld-linux-x86-64.so.2 "$file"
        patchelf --replace-needed libc.so.6 /home/thinker/bin/glibc-all-in-one/libs/2.39-0ubuntu8_amd64/libc.so.6 "$file"

        echo "----------------------------------"
    # fi
done
```

## <font color=#009A000> 0x03 安装 </font>

- `deb 打包` : `dpkg-deb -b git_249 git_2.49.0-2~ppa1~ubuntu25.04.1_amd64_new.deb`
- `sudo apt install xxx.dep`
- `ldd git` & `./git --version`
