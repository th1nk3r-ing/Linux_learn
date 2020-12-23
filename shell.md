# <font color=#0099ff> **shell 脚本学习笔记** </font>

> `@think3r` 2020-12-22 11:07:24

## <font color=#009A000> 0x00 </font>

```sh
# 摘抄于 vlc 编译脚本
if [ -z "$MAKEFLAGS" ]; then
    UNAMES=$(uname -s)
    MAKEFLAGS=
    if which nproc >/dev/null; then
        MAKEFLAGS=-j$(nproc)
    elif [ "$UNAMES" = "Darwin" ] && which sysctl >/dev/null; then
        MAKEFLAGS=-j$(sysctl -n machdep.cpu.thread_count)
    fi
fi

if [ "${ANDROID_ABI}" = "arm" ] ; then
    ANDROID_ABI="armeabi-v7a"
elif [ "${ANDROID_ABI}" = "arm64" ] ; then
    ANDROID_ABI="arm64-v8a"
fi

if [ -f $SRC_DIR/src/libvlc.h ];then
    VLC_SRC_DIR="$SRC_DIR"
elif [ -d $SRC_DIR/vlc ];then
    VLC_SRC_DIR=$SRC_DIR/vlc
else
    echo "Could not find vlc sources"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo_props > "$1"
    return 0
fi

init_local_props local.properties || { echo "Error initializing local.properties"; exit $?; }

# shell 中写文件
rm -rf $VLC_OUT_PATH/Android.mk
cat << 'EOF' > $VLC_OUT_PATH/Android.mk
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE    := libvlc
LOCAL_SRC_FILES := libvlcjni-modules.c libvlcjni-symbols.c dummy.cpp
LOCAL_LDFLAGS := -L$(VLC_CONTRIB)/lib
LOCAL_LDLIBS := \
    $(VLC_MODULES) \
    $(VLC_BUILD_DIR)/lib/.libs/libvlc.a \
    $(VLC_BUILD_DIR)/src/.libs/libvlccore.a \
    $(VLC_BUILD_DIR)/
EOF
```

- if 判断语句 :
  - `-z` 变量为空判断;
  - `"${ANDROID_ABI}" = "arm"` 判断字符串相等, 只用一个 `=` 号;
  - `-f` 文件存在判断;
  - `-d` 文件夹存在判断;
  - `!` 结果取反;
- `uname -s` 操作系统;
- `which nproc >/dev/null` 是否存在制定命令;
  - `nproc` 等价于 `sysctl -n machdep.cpu.thread_count` 都是获取 cpu 核数;
  - `which` 等价于 `command -v` 都是查找命令位置的;
- `||` 执行对应命令, 有错误时, 执行之后的命令;

### <font color=#FF4500> 时间计算 </font>

```sh
startTime=$(date +'%Y-%m-%d %H:%M:%S')
#执行程序
endTime=$(date +'%Y-%m-%d %H:%M:%S')
startSeconds=$(date --date="$startTime" +%s);
endSeconds=$(date --date="$endTime" +%s);
echo "本次运行时间" $((endSeconds-startSeconds)) "s"
```
