# <font color=#0099ff> **Gradle** </font>

<!-- [![LICENSE](https://img.shields.io/badge/license-Anti%20996-blue.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE) [![996.icu](https://img.shields.io/badge/link-996.icu-red.svg)](https://996.icu) --->

> `@think3r` 2020-08-10 00:01:14 <br />
> 参考链接 :
> 1. [来自Gradle开发团队的Gradle入门教程](https://www.bilibili.com/video/BV1DE411Z7nt?from=search&seid=5541083429304083164)
> 2. [Android Gradle 插件版本所需的 Gradle 版本对照](https://developer.android.google.cn/studio/releases/gradle-plugin.html#updating-plugin)

## <font color=#009A000> 0x00 基础概念 </font>

### <font color=#FF4500> Gradle </font>

通用的构建工具, 纯 `java` 编写, 但其构建脚本的语言为 `groovy`(全面兼容 `java`). 因此与绝大部分 jvm 库一样, Gradle 本身的安装包(`Distribution`) 即为一个 脚本和一个 lib 的集合.

- 2019 年 3 月份开启了中国地区的 CDN : [servicces.Gradle.org](https://services.Gradle.org).
  - 在上述链接中可找到最新的 Gradle 版本;
- Gradle 的三种安装包 :
  - `src` 源码的打包;
  - `bin` 仅仅包含可执行文件, 不包含 sample, 用户文档 等;
  - `all` 包含可执行文件, sample, 用户文档等;
- 本质上为一个脚本( unix 和 windows 下各一个), 启动后, 加载 lib 下的一些东西;
- `Gradle wrapper` 既 `Gradlew` :
  - 将构建与具体的 Gradle 版本绑定起来;
    - 如果机器上没有对应版本的 Gradle 的话, 其首先下载对应版本的额 Gradle, 保证运行环境的一致性;
      - 启动一个 jvm, 加载 `Gradle-wrapper.jar` 读取同路径下的 `gradle-wrapper.properties` 中的配置, 来下载真正的 `Distribution`;
- `Gradle_user_home`
  - 默认位置在 `~/.Gradle/`
    - `init.d` 中的配置对所有 Gradle 构建均生效, 最典型的配置为全局的仓库替换;
    - `wrapper` 下载的 Gradle 版本;
    - `caches` 缓存, 减少依赖的下载;
- `Daemon` :
  - jvm 启动到完成所有 jar 包的加载, 需要 10s 左右的时间, 比较慢, 因此自 Gradle-3.0 之后, 默认启用了 daemon ;
  - 轻量级的 `client jvm` 连接查找 `Daemon Jvm`(通过 `socket`), 转发具体的参数和任务至 daemon jvm, daemon 完成后,将结果和日志发回至 jvm;
  - 本次构建结束后, client jvm 会被销毁, 而 Daemon jvm 继续保留(默认空闲三小时后自动退出);
  - Deamon 的兼容性, client 和 Daemon 版本要对应;
  - `--no-daemon` 参数;

### <font color=#FF4500> groovy </font>

- `groovy` 是一个运行在 jvm 之上的脚本语言;
  - 强类型, 动态调用;
- `DSL` : `groovy`, `Makefile`, `CMake` 等等;
  - 闭包

## <font color=#009A000> 0x01 Gradle 构建 </font>

> [Gradle Build Lifecycle](https://docs.Gradle.org/current/userguide/build_lifecycle.html)

- `build.gradle` 指明了构建的核心模型;
- Gradle 的 lifeCycle 生命周期:
  - Initialization 初始化阶段:
    > Gradle supports single and multi-project builds. During the initialization phase, Gradle determines which projects are going to take part in the build, and creates a Project instance for each of these projects.
  - Configuration 配置 :
    > During this phase the project objects are configured. The build scripts of all projects which are part of the build are executed.
    - 如 : 将 doLast 中的函数添加至 task 列表的最后;
  - Execution :
    > Gradle determines the subset of the tasks, created and configured during the configuration phase, to be executed. The subset is determined by the task name arguments passed to the Gradle command and the current directory. Gradle then executes each of the selected tasks. 
- project :
  - 项目, jvm 中的一个实例;
  - 多项目树状列表, 可用 `projet.parent` or `childProjects`;
- task :
  - Gradle 构建的最小单元;
  - 动态的 `task` 创建;
  - **`doFirst` , `doLast`, `dependsOn`, `afterEvaluate`**

## <font color=#009A000> 0x02 Gradle 插件 </font>

- Gradle 的核心由插件(plugin)构成, 插件本质上就是一堆能够被复用的逻辑;
  - `apply plugin` 使用编写好的插件;
- `External Libraries` 项目所依赖的 jar 包等, 取决于 `build.gradle` 中的 `dependencies`;
- `build.Gradle` 中的 `repositories` 则指明了中央仓库的地址;
- `build.Gradle` 中 `buildscript` 下的 `dependencies` 生效的是这个 `build.gradle` 脚本, 而不是源码;
  - 即 : 构建脚本自身所依赖的第三方库;
  - `build.Gradle` 中的 `apply plugin: 'com.android.application'`
    - 使用的是其自身 `buildscript` 下 `dependencies` 中的依赖包;
    - [https://mvnrepository.com/artifact/com.android.tools.build/Gradle/2.3.3](https://mvnrepository.com/artifact/com.android.tools.build/Gradle/2.3.3) 中下载对应 jar 包, 解压, 即可查看;
- 因为 gradle 并不是只针对 Android 的构建工具, 其也可以构建 java, c++ 等等, 因为 Android 开发需要用到 Android 插件, 如下为常用的一些插件 :

   ```gradle
   /* 插件声明*/
    dependencies {
      classpath com.android.tools.build:gradle:2.3.3
    }
    /* 插件使用 */
    apply plugin: 'com.android.application'  //安卓 app 插件;
    apply plugin: 'com.android.library'      //安卓 lib 插件;
    apply plugin: 'java'    //java 程序 (用 java 开发 Android 插件可省略)
    apply plugin: 'war'     //打包成 war 包 ???
    apply plugin: 'kotlin-android'     //kotlin 程序;
   ```

## <font color=#009A000> 0x03 其他基础 </font>

目录介绍 :

- `src/main/java` 正式代码目录;
- `src/main/resources` 真是配置文件目录
- `src/test/java` 单元测试代码目录(打包时不编译);
- `src/test/resources` 测试配置文件目录;
- `src/main/webapp` 放置页面元素 : js, css, img, jsp, html 等;

groovy 语言 :

- 完全兼容 java 语法, 可做脚本也可做类;
- 类, 方法, 字段都是公共的, 没有访问权限的限制;
- 字段不定义访问权限时, 编译器自动给字段添加 `setter/getter` 方法, 字段可使用 `.` 来获取;
- 方法可省略 `return` 关键字, 自动检索最后一行的结果作为返回值;
- 调用带参方法时可省略括号;
- 字符串定义有三种方式 : 单引号, 双引号, 三个单引号;
- `println("hello world")` 打印元素
  - groovy 中可省略语句末尾的分号
  - groovy 可省略括号
- `def` 定义变量, 变量为弱类型;
- 集合 `[a,b]`
- `map [key1:value1, key2:value2]`
  - `map.get("key1")`
- groovy 的闭包其实就是一段代码块. 主要把闭包当参数来使用;
  - `Closure` 类型;
- Gradle 工程中所有 jar 包的坐标都在 `build.Gradle` 内 `dependence` 的属性内放置; 每个 jar 包都包含三个基本元素 : `group`, `name`, `version` ; 此外还有 jar 包的作用域 :
  - `testCompile` 表示该 jar 包在测试的时候起作用;
  - `compile`
  - `provided` 只在编译阶段起作用, 运行阶段不起作用;
- `repositories` 仓库路径配置 :
  - `mavenLocal()` 本地仓库;
  - `mavenCentral()` 服务器中央仓库;
  - `google()` google 自家的拓展依赖库;
  - `jcenter()` 第三方开源库;

### <font color=#FF4500> Android `build.gradle` 解析 </font>

- `applicationId` 每个应用唯一标识符, 默认为创建应用程序时指定的包名(lib 没有);
- `minSdkVersion` 用于指定项目最低兼容的 Android 系统版本;
- `targetSdkVersion` 表示你在该目标版本上已经做过了充分的测试, 系统将会为你的应用程序启用一些最新的功能和特性(`minSdkVersion` 没有而 `targetSdkVersion` 有的特性);
- `buildType` --> `release` -->
  - `minifyEnabled` 是否对项目代码进行混淆;
  - `proguardFiles` 用于指定混淆时使用的规则文件;
- Android Studio 项目的三种依赖 :
  - 本地依赖 : 对本地的 jar 包或目录添加依赖关系;
    - `compile/implementation fileTree`
      - `compile` 在 gradle Plugin 3.0 以上被 `implementation` 取代;
  - 库依赖 : 可以对项目中的库模块添加依赖关系;
    - `implementation project(':')`
  - 远程依赖 : 可以对 jcenter 仓库上的开源项目添加依赖关系;
    - `implementation` 远程依赖声明;

---

# <font color=#0099ff> **Gradle 系统讲解** </font>

> `@think3r` 2020-08-28 00:42:45

## <font color=#009A000> 0x00 Gradle 的引入 </font>

1. 石器时代 :
    - 依赖管理 : 手动拷贝第三方 jar 包至 lib 路径中;
    - 容易出现版本冲突;
    - 每个项目都得拷贝相同的 jar 包, 占用存储空间;
    - 每个功能都要书写测试类;
    - 打包和上传 : 手动打包, 手动上传;
2. 工业时期 :
    - 依赖管理 : 可以做一些简单的依赖管理, 但没有拷贝至项目中去;
    - 自动化 : 可以自动化测试, 打包, 发布;  
3. 主流的构建工具 :
    - Ant (Apache Ant)
    - Maven (Apache)
    - Gradle

- Gradle 是一个开源的自动化构建工具, 建立在 Apache Ant 和 Apache Maven 概念的基础上, 并引入了基于 Groovy 的 DSL, 而不是 xml 管理构建脚本;
- Groovy 是一个基于 Java 虚拟机的一种敏捷的动态语言, 它是一种成熟的 OOP 编程语言, 既可以用于面向对象编程, 又可以用作纯粹的脚本语言, 使用该种语言不必要编写过多的代码, 同时又具有闭包和动态语言中的其他特性;

---

# <font color=#0099ff> **Gradle-Code** </font>

### <font color=#FF4500> 缓存时效 </font>

```groovy
// 设置缓存的时效, 避免每次都去通过网络下载依赖
configurations.all {
    resolutionStrategy.cacheChangingModulesFor 24, 'hours'    // 检查远程依赖是否存在更新的间隔时间
    resolutionStrategy.cacheDynamicVersionsFor 4, 'hours'    // 采用动态版本声明的依赖缓存的检查间隔时间
}
```

### <font color=#FF4500> 自动拷贝 </font>

```groovy
// 编译时, 自动拷贝文件, 需要存在对应的文件, 否则会报错;
ext { // 变量
    fileBaseName="testLib-"
    //fileType="release"
    fileType="debug"
    fileName = fileBaseName + fileType
}
delete fileTree("libs").matching { // 删除文件
    include (fileBaseName + "*.so")
}
copy {  // 拷贝文件
    from('./build/intermediates/merged_native_libs/debug/out/lib/arm64-v8a/')
    into('libs/')
    include(fileName + '*.aar')
}
compile(name: fileName, ext : 'aar')
```

### <font color=#FF4500> 执行命令 </font>

```groovy
// 获取当前的 git 版本
task test12() {
    def myVersion = 'git rev-parse --short HEAD'.execute().text.trim()
    System.out.println("\n ------> " + myVersion  + "\n")
}
```
