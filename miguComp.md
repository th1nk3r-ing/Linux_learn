# <font color=#0099ff> **migu 编译体系** </font>

> `@think3r` 2020-09-03 15:20:26 </br>
> 参考链接 : <
> 1. [configure向cmake过渡指南 ](https://my.oschina.net/766/blog/211146)

## <font color=#009A000> 0x00 原编译体系 </font>

```sh
#通过 config/mg_build_config.h 中的宏定义来 export 变量;
cd config
export LOCAL_HAVE_OPENH264=`grep -c "#define HAVE_OPENH264 1" mg_build_config.h`
export LOCAL_HAVE_OPENSSL=`grep -c "#define HAVE_OPENSSL 1" mg_build_config.h`

config/module.h 中包含了大量 ffmpeg 的 configure
```

```sh
# openh264 编译
sh init-libopenh264.sh Android
# ----> 调用的是 openh264 git 仓库中的 build 脚本 :
sh build_openh264_android.sh

```

```sh
# openssl 编译

# 如果定义了 LOCAL_HAVE_OPENSSL 则 :
FF_ALL_ARCHS="armv5 armv7a arm64 x86 x86_64"
./compile-openssl.sh clean
# 通过 git 命令直接删除原来的东西;
echo_archs
for ARCH in $FF_ALL_ARCHS
do
    cd $MG_LIBOPESSL_LOCAL_REPO/openssl-$ARCH && git clean -xdf && cd $UNI_BUILD_ROOT
done
rm -rf ./build/openssl-*
# 通过如下脚本进行编译;
sh tools/do-compile-openssl.sh $FF_TARGET

./Configure   zlib-dynamic no-shared --openssldir=/Users/yangzhongyao/work/MGPlayerSDK/android/contrib/build/openssl-armv7a/output --cross-compile-prefix=arm-linux-androideabi- android-armv7
```

## <font color=#009A000> 0x01 Android mpf cmake 编译 </font>

```log
toolchain_file: /home/think3r/bin/android-ndk-r19c//build/cmake/android.toolchain.cmake
version: 21
build type:DEBUG
target install:install
cmake -DCMAKE_TOOLCHAIN_FILE=/home/think3r/bin/android-ndk-r19c//build/cmake/android.toolchain.cmake -DPLATFORM=ANDROID -DANDROID_PLATFORM=21 ../cpp/
-- Check for working C compiler: /home/think3r/bin/android-ndk-r19c/toolchains/llvm/prebuilt/linux-x86_64/bin/clang
-- Check for working C compiler: /home/think3r/bin/android-ndk-r19c/toolchains/llvm/prebuilt/linux-x86_64/bin/clang -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /home/think3r/bin/android-ndk-r19c/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++
-- Check for working CXX compiler: /home/think3r/bin/android-ndk-r19c/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
CMAKE_INSTALL_PREFIX is /mnt/g/code/mpf/trunk/jni/cpp/../install
CMAKE_MODULE_PATH is
-- This is PROJECT BINARY dir /mnt/g/code/mpf/trunk/jni/build_armeabi-v7a
-- This is PROJECT SOURCE dir /mnt/g/code/mpf/trunk/jni/cpp
-- /mnt/g/code/mpf/trunk/jni/cpp/cmake/android/ignore.cmake doesn't exist, macro(mpf_include_cmake_file) just does nothing
-- Looking for pthread.h
-- Looking for pthread.h - found
-- Looking for pthread_create
-- Looking for pthread_create - found
-- Found Threads: TRUE
CMAKE_THREAD_LIBS_INIT is
-- mpf -- PLATFORM = ANDROID
-- mpf -- ARCH = x86_64
-- mpf -- MPF_TARGET = mpf
-- media -- BUILD_TYPE/CMAKE_BUILD_TYPE = DEBUG/Debug
-- mpf -- MPF_VERSION = 1.0.0
-- mpf -- TEST_ENABLE = TRUE
-- mpf -- DEBUG_TOOL_ENABLE = FALSE
-- mpf -- MPF_COMPILE_FLAGS = -g -Wall -Wno-write-strings -Werror -D__NODIR_FILE__=$(notdir $<) -O0 -D__SYSTEM_LINUX__
-- mpf -- MPF_LINK_FLAGS = -Wl,--no-as-needed -Wl,--gc-sections -z relro -z now -fstack-protector -fPIC
```

## <font color=#009A000> 0x03 cMake 中间记录 </font>

- linux 下编译 migusdk 时, 需要 `/bin/sh --> /bin/bash` 而不是 `/bin/dash`

```cmake
# flags
-v 选项能打开编译提示

set(CMAKE_TOOLCHAIN_FILE "/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/build/cmake/harmonyos.toolchain.cmake")

set(CMAKE_TOOLCHAIN_FILE "/home/think3r/bin/android-ndk-r14b/build/cmake/android.toolchain.cmake")

# c++ 相关, 必须有 cpp 文件后缀;
-L/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/../lib/aarch64-linux-harmonyos/c++

# 鸿蒙 cmake 相关配置
-- CMAKE_C_COMPILER:/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang
-- CMAKE_CXX_COMPILER:/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang++

-- CMAKE_SYSROOT:/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/sysroot
--sysroot=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/sysroot

# 编译选项
--target=aarch64-linux-harmonyos 
--gcc-toolchain=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm
--sysroot=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/sysroot  

cmake -DCMAKE_TOOLCHAIN_FILE=$NDK_PATH/build/cmake/android.toolchain.cmake \
    -DANDROID_NDK=$NDK_PATH                      \
    -DCMAKE_BUILD_TYPE=Release                     \
    -DANDROID_ABI=$abi          \
    -DANDROID_NATIVE_API_LEVEL=16                  \
    -DANDROID_STL=c++_static \
    -DCMAKE_CXX_FLAGS=-frtti -fexceptions --std=c++1z \
    -DCMAKE_INSTALL_PREFIX=$OUTPUT_PATH \
    ../..

```

### <font color=#FF4500> libyuv 编译 </font>

- https://gitee.com/aidem/libyuv/commit/5736f6ba6f5ef9297251150d8c74940df4240f1b

## <font color=#009A000> openh264 编译 </font>

```sh
git clone https://gitee.com/mirrors/openh264.git

# x86 编译
sudo apt-get install nasm
make OS=linux ARCH=x86_64 -j

# aarch64-linux-gnu 编译
make OS=linux CC=aarch64-linux-gnu-gcc CXX=aarch64-linux-gnu-g++ ARCH=arm64

# Android armv7a 编译
/home/think3r/bin/android-ndk-r14b/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-g++ 
-O3  -DNDEBUG 
-DHAVE_NEON -march=armv7-a 
-mfloat-abi=softfp -mfpu=vfpv3-d16 
-DANDROID_NDK -fpic 
--sysroot=/home/think3r/bin/android-ndk-r14b/platforms/android-12/arch-arm 
-MMD -MP 
-DGENERATED_VERSION_HEADER -fno-rtti -fno-exceptions 
-I./codec/api/svc 
-I./codec/common/inc 
-Icodec/common/inc  
-I./codec/encoder/core/inc 
-I./codec/encoder/plus/inc 
-I./codec/processing/interface 
-c -o codec/encoder/core/src/au_set.o codec/encoder/core/src/au_set.cpp

```

```sh
# 鸿蒙编译
# 去掉 uild/platform-linux.mk 中的架构参数
make OS=linux CC=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang CXX=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang++ ARCH=arm64

# 编译 aarch 相关东西报错
/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang -O3 -DNDEBUG -DHAVE_NEON_AARCH64 -Wall -fno-strict-aliasing -fPIC -MMD -MP -fstack-protector-all -DGENERATED_VERSION_HEADER -I./codec/common/arm64/ -I./codec/api/svc -I./codec/common/inc -Icodec/common/inc   -c -o codec/common/arm64/copy_mb_aarch64_neon.o codec/common/arm64/copy_mb_aarch64_neon.S
<instantiation>:1:1: error: invalid instruction mnemonic 'sxtw'
sxtw x1, w1

# 去除 ARCH=64 后, 编译的指令中又包含了 -DHAVE_AVX2, 即: x86 平台;
make OS=linux CC=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang CXX=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang++

# 链接失败
make OS=linux CC="/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang --target=aarch64-linux-harmonyos --gcc-toolchain=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm --sysroot=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/sysroot" CXX="/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang++ --target=aarch64-linux-harmonyos --gcc-toolchain=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm --sysroot=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/sysroot" ARCH=arm64

# SoundTouch 鸿蒙链接命令
/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang++ --target=aarch64-linux-harmonyos --gcc-toolchain=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm --sysroot=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/sysroot -fPIC  -v -O3 -Wall  -fopenmp -v --rtlib=compiler-rt -fuse-ld=lld -Wl,--build-id=sha1 -Wl,--warn-shared-textrel -Wl,--fatal-warnings -lunwind -Wl,--no-undefined -Qunused-arguments -Wl,-z,noexecstack  -shared -Wl,-soname,libmgsoundtouch.so -o libmgsoundtouch.so CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/AAFilter.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/FIFOSampleBuffer.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/FIRFilter.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/cpu_detect_x86.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/sse_optimized.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/RateTransposer.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/InterpolateCubic.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/InterpolateLinear.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/InterpolateShannon.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/TDStretch.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/BPMDetect.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/PeakFinder.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/SoundTouch.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/source/SoundTouch/mmx_optimized.cpp.o CMakeFiles/mgsoundtouch.dir/mnt/d/Documents/Desktop/migu/code/my_mgplayer/mgplayersdk/mgmedia/mgsoundtouch/mgsoundtouch_wrap.cpp.o  -lm
```

- 去除 `--gcc-toolchain=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm` 编译也 OK;
  - `make OS=linux CC=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang CXX=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang++ ARCH=arm64 CFLAGS="--target=aarch64-linux-harmonyos" CXXFLAGS="--target=aarch64-linux-harmonyos"`
- 链接错误 :
  - `LDFLAGS="--rtlib=compiler-rt -fuse-ld=lld -Wl,--build-id=sha1 -Wl,--warn-shared-textrel -Wl,--fatal-warnings -lunwind -Wl,--no-undefined -Qunused-arguments -Wl,-z,noexecstack"`
- 最终编译 OK 的命令 :
  - `make OS=linux CC="/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang --target=aarch64-linux-harmonyos --gcc-toolchain=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm --sysroot=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/sysroot" CXX="/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang++ --target=aarch64-linux-harmonyos --gcc-toolchain=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm --sysroot=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/sysroot" ARCH=arm64 LDFLAGS="--rtlib=compiler-rt -fuse-ld=lld -Wl,--build-id=sha1 -Wl,--warn-shared-textrel -Wl,--fatal-warnings -lunwind -Wl,--no-undefined -Qunused-arguments -Wl,-z,noexecstack"`

```log
# 咪咕有报错
/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang --target=aarch64-linux-harmonyos --gcc-toolchain=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm --sysroot=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/sysroot -O3 -DNDEBUG -DHAVE_NEON_AARCH64 -Wall -fno-strict-aliasing -fPIC -MMD -MP -DGENERATED_VERSION_HEADER -I./codec/common/arm64/ -I./codec/api/svc -I./codec/common/inc -Icodec/common/inc   -c -o codec/common/arm64/copy_mb_aarch64_neon.o codec/common/arm64/copy_mb_aarch64_neon.S

# github 最新无报错
/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm/bin/clang --target=aarch64-linux-harmonyos --gcc-toolchain=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/llvm --sysroot=/home/think3r/bin/hongmeng-native-linux-x86_64-1.0.0.0/sysroot -O3 -DNDEBUG -DHAVE_NEON_AARCH64 -Wall -fno-strict-aliasing -fPIC -MMD -MP -fstack-protector-all -march=armv8-a -DGENERATED_VERSION_HEADER -I./codec/common/arm64/ -march=armv8-a -I./codec/api/svc -I./codec/common/inc -Icodec/common/inc   -c -o codec/common/arm64/copy_mb_aarch64_neon.o codec/common/arm64/copy_mb_aarch64_neon.S
```
