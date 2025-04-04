#!/usr/bin/env python3


# TODO: ffmpeg 支持 ncm 直接播放 (patch), ref : <https://github.com/taurusxin/ncmdump.git>
# 导出 网易云音乐的 播放 list, 并替换其中的 ncm 文件到转换后的

# 歌单处理流程
# 1. git clone https://github.com/mkmark/netease-cloudmusic-playlist-exporter?tab=readme-ov-file.git
# 2. cd xxx && 2to3 -W .
# 3. 文件拷贝输出
# 4. ncmplex -l /mnt/e/Desktop/tmp/tmp/ -d /mnt/f/Music/CloudMusic/  -e /mnt/e/Desktop/tmp/tmp/export/  -c
# 5. 执行本脚本进行 ncm 替换

import os
import sys
import shutil
import subprocess  # 确保导入 subprocess 模块

def process_file(filepath):
    # 生成备份文件
    backup_path = filepath + ".bak"
    shutil.copy2(filepath, backup_path)
    print(f"备份文件已生成：{backup_path}")

    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    new_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.rstrip("\n")
        # 检查当前行是否以 '.ncm' 结尾
        if stripped.endswith(".ncm"):
            # 生成修改后的新行：替换 VipSongsDownload -> ncmDir 及 ncm -> mp3
            modified_line = stripped.replace(".ncm", ".mp3").replace("VipSongsDownload", "ncmDir")

            # 使用 wslpath -u 将 Windows 路径转换为 Linux 路径
            try:
                linux_path = subprocess.check_output(["wslpath", "-u", modified_line], text=True).strip()
            except subprocess.CalledProcessError as e:
                print(f"wslpath 转换失败: {e}, 使用原路径进行检测")
                linux_path = modified_line

            # 判断修改后的文件路径是否存在，如果不存在则将扩展名改为 .flac
            if not os.path.exists(linux_path):
                base, ext = os.path.splitext(modified_line)
                modified_line = base + ".flac"
                print(f"文件不存在，修改扩展名：{modified_line}")

            # 注释掉原来的 .ncm 结尾行，并在下一行插入修改后的行
            new_lines.append("#" + stripped + "\n")
            new_lines.append(modified_line + "\n")
        else:
            new_lines.append(line)
        i += 1

    # 写回处理后的内容到原文件
    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    print(f"处理完成：{filepath}")

def process_folder(folder):
    # 遍历文件夹下所有文件
    for root, dirs, files in os.walk(folder):
        for filename in files:
            if filename.lower().endswith(".m3u8"):
                filepath = os.path.join(root, filename)
                print(f"正在处理文件：{filepath}")
                process_file(filepath)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: python script.py <文件夹路径>")
        sys.exit(1)

    folder_path = sys.argv[1]
    if not os.path.isdir(folder_path):
        print(f"错误：{folder_path} 不是一个有效的文件夹")
        sys.exit(1)

    process_folder(folder_path)

