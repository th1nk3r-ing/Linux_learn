#!/bin/bash

scriptAbsPath=$(dirname $(readlink -f "$0")) && cd ${scriptAbsPath}   # 获取脚本的真实路径并>    进入其根路径 (支持软连接 & 外部文件夹调用)

echo "pwd : $(pwd)"

# 处理 github markdown 相关语法问题(actions 发布时使用)
function handle_github_md_syntax() {
    # 删除标签 </font>
    find . -name "*.md" -exec sed -i 's/<\/font>//g' {} +
    # 删除标签 <font color=#009A000>
    find . -name "*.md" -exec sed -i 's/<font color=#\([a-fA-F0-9]*\)>//g' {} +
    echo "已完成 font 标签删除"
    # <u>**XXX**</u>  -->  **<u>XXX</u>**
    find . -name "*.md" -exec sed -E -i 's/<u>\*\*(.+?)\*\*<\/u>/**<u>\1<\/u>**/g'  {} +
    echo "已完成 下划线和高亮 标签替换"

    echo "-------> will delete :"
    find .  \(  -name "*.sh" -o \
                -name "*.py" -o \
                -name "*.c" -o \
                -name "*.cpp" -o \
                -name "*.so" -o \
                -name "*.o" \) -print -exec rm -f {} \;
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
            if find "$file" \( -name "*.md" -o -name "*.pdf" -o -name "*.html" \) -print -quit | grep -q .; then
                # 如果是目录，则递归调用自身，并增加缩进层级
                echo "${prefix}- **${file##*/}** :"  >> toc.txt
                handle_repo_doc_toc "${prefix}  " "$file"
            else
                true                            # do-nothing
            fi
        elif [[ "$file" =~ \.md$ || "$file" =~ \.pdf$ || "$file" =~ \.html$ ]]; then
            # 如果是 .md 文件，则按要求格式化输出
            escaped_url=$(echo "$file" | sed 's/ /%20/g')
            echo "${prefix}- [${file##*/}](${escaped_url})" >> toc.txt
        fi
    done
}

# NOTE: 处理 文件 toc
handle_repo_doc_toc  ""  "."
echo "TOC 已生成到 toc.txt"

# 使用 grep 检查两个标记是否存在，并统计行数
start_tag=$(grep -c '<!-- TOC start -->' readme.md)
end_tag=$(grep -c '<!-- TOC end -->' readme.md)

# 判断是否两个标记都存在
if [ $start_tag -gt 0 ] && [ $end_tag -gt 0 ]; then
    true
else
    echo "One or both of the 'TOC' tags are missing. Exiting..."
    exit 1 # 返回非零值表示异常退出
fi

# 定义一个临时文件
temp_head="temp_head.md"
temp_tail="temp_tail.md"
output_file="updated_readme.md"

# 将 readme.md 的内容复制到临时文件，直到遇到旧的 TOC 部分
# 提取 <!-- TOC start --> 之前的部分
sed '/<!-- TOC start -->/q' readme.md > "$temp_head"
# 提取 <!-- TOC end --> 之后的部分
sed -n '/<!-- TOC end -->/,$p' readme.md | sed '1d' > "$temp_tail"

# 合并头部、新内容和尾部
cat "$temp_head" > "$output_file"
echo "" >> "$output_file" # 确保换行
cat toc.txt >> "$output_file"
echo "" >> "$output_file" # 确保换行
echo "<!-- TOC end -->" >> "$output_file"
cat "$temp_tail" >> "$output_file"

# 清除中间文件
rm "$temp_head" "$temp_tail" toc.txt
mv $output_file readme.md

echo "TOC 已更新到 readme.md"
