# <font color=#0099ff> **Sqlite for music** </font>

## <font color=#009A000> 0x00 ubuntu 安装 squlite </font>

- `sudo apt-get install sqlite3`

## <font color=#009A000> 0x01 基本命令操作 </font>

- 打开已有数据库;
  - `sqlite3 *.db` 或:
  - `sqlite3`
    - `.open *.db` 
- `.table` 查看数据库中的表;
- `.exit` 退出;
- sqlite3 语句结束应加 `;`,  和 C语言 一致;
- `select` 语句
  - `select _id,name,album_cover_id from album;` 查看 album 表中的 _id,name,album_cover_id 三项内容;

## <font color=#009A000> 0x02 有用的命令 </font>

- 选择出表单 `playlist` `creator_nickname` 以 `逝者` 创建的歌单:
  - `select _id,name,track_count from playlist where creator_nickname LIKE '逝者%';`
