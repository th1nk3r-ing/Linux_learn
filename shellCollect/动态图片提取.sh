FILE=./MVIMG_20241124_153735.mp4
OUTPUT_FILE=./out.mp4

# 查找 "ftyp" 的偏移量并减去 3
OFFSET=$(grep -F --byte-offset --only-matching --text ftyp "$FILE" | grep -o ^[0-9]*)
NEW_OFFSET=$(echo "$OFFSET - 3" | bc)

# 提取视频数据
tail -c +$NEW_OFFSET "$FILE" > "$OUTPUT_FILE"
