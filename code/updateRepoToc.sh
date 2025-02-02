#!/bin/bash

scriptAbsPath=$(dirname $(readlink -f "$0")) && cd ${scriptAbsPath}   # 获取脚本的真实路径并>    进入其根路径 (支持软连接 & 外部文件夹调用)

cd ../

# 清空或创建 toc 文件
> toc.txt

old_dirname=0

# 使用 find 命令递归查找所有 .md 文件，并按目录结构排序
find . -type f -name "*.md" | sort | while read -r file; do
    # 获取相对路径并去除开头的 './'
    relative_path=${file:2}

    # 获取文件所在的目录路径（不包括文件名）
    dir=$(dirname "$relative_path")

    # 获取文件名并去除扩展名作为标题
    title=${file##*/}
    title=${title%.md}

    # 计算当前文件所在目录的深度
    if [ "$dir" = "." ]; then
        depth=0
    else
        # 目录深度 = 斜杠数量 + 1
        depth=$(grep -o '/' <<< "$dir" | wc -l)
        depth=$((depth + 1))
    fi

    # 构建缩进（每层两个空格）
    indent=""
    for (( i=0; i<depth; i++ )); do
        indent+="  "
    done

    if [ "$dir" == "$old_dirname" ]; then
        true                            # do-nothing
    else
        old_dirname=$dir
        if [ "$dir" == "." ]; then      # 不显示根文件夹
            true
        else
            echo "${indent:2}- **$dir**" >> toc.txt
        fi
    fi

  # 输出格式化的链接到 toc.txt 文件中
  echo "$indent- [$title]($relative_path)" >> toc.txt
done

echo "TOC 已生成到 toc.txt"


# 定义一个临时文件
temp_file="readme_temp.md"

# 将 readme.md 的内容复制到临时文件，直到遇到旧的 TOC 部分
sed '/<!-- TOC start -->/,/<!-- TOC end -->/d' readme.md > "$temp_file"

# 在临时文件中插入新的 TOC
echo -e "<!-- TOC start -->\n" >> "$temp_file"
cat toc.txt >> "$temp_file"
echo -e "\n<!-- TOC end -->" >> "$temp_file"

# 替换原来的 readme.md 文件
mv "$temp_file" readme.md

# 删除 toc.txt 文件
rm toc.txt

echo "TOC 已更新到 readme.md"
