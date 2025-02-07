#!/bin/bash

scriptAbsPath=$(dirname $(readlink -f "$0")) && cd ${scriptAbsPath}   # 获取脚本的真实路径并>    进入其根路径 (支持软连接 & 外部文件夹调用)

echo "pwd : $(pwd)"


function handle_github_md_syntax() {
    # 删除标签 </font>
    find . -name "*.md" -exec sed -i 's/<\/font>//g' {} +
    # 删除标签 <font color=#009A000>
    find . -name "*.md" -exec sed -i 's/<font color=#\([a-fA-F0-9]*\)>//g' {} +
    echo "已完成 font 标签删除"
    # <u>**XXX**</u>  -->  **<u>XXX</u>**
    find . -name "*.md" -exec sed -E -i 's/<u>\*\*(.+?)\*\*<\/u>/**<u>\1<\/u>**/g'  {} +
    echo "已完成 下划线和高亮 标签替换"
}

#!/bin/bash
if [[ $# -gt 0 && "$1" == "handleGithubMdSyntax" ]]; then
    handle_github_md_syntax
fi

# 清空或创建 toc 文件
> toc.txt

# 定义递归函数来遍历目录并处理 .md 文件
function handle_repo_doc_toc() {
    local prefix="$1"        # 前缀用于树结构的缩进
    local dir="$2"           # 当前处理的目录
    local files=("$dir"/*)   # 获取目录下的所有文件和子目录

    for file in "${files[@]}"; do
        if [ -d "$file" ]; then
            # 如果是目录，则递归调用自身，并增加缩进层级
            echo "${prefix}- **${file##*/}** :"  >> toc.txt
            handle_repo_doc_toc "${prefix}  " "$file"
        elif [[ "$file" =~ \.md$ || "$file" =~ \.pdf$ || "$file" =~ \.html$ ]]; then
            # 如果是 .md 文件，则按要求格式化输出
            echo "${prefix}- [${file##*/}](${file})" >> toc.txt
        fi
    done
}

function handle_repo_doc_toc_old() {
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
            # depth=$(grep -o '/' <<< "$dir" | wc -l)
            depth=$(echo "$dir" | grep -o '/' | wc -l)
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
}

# NOTE: 处理 文件 toc
# handle_repo_doc_toc_old
handle_repo_doc_toc  ""  "."
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
