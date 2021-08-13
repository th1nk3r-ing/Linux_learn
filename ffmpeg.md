# <font color=#0099ff> **ffmpeg 相关** </font>

> `@think3r` 2020-07-07 14:11:15
> 1. [FFmpeg 入门学习笔记 _](https://lingyunfx.com/2020/11/21/ffmpeg-used01/)
> 2. [FFmpeg DASH部分指令参数参考](https://www.jianshu.com/p/637553d479b4?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)

## <font color=#009A000> 0x00 ffmpeg </font>

- [FFmpeg命令行工具学习(一)：查看媒体文件头信息工具ffprobe](https://www.cnblogs.com/renhui/p/9209664.html)
  - 用来查看媒体文件格式的工具 :
    - `-show_format`  输出格式信息;
    - `-print_format json` 以 JSON 格式输出;
      - `-of csv` 以 csv 表格输出(可用 excel 打开)
    - `-show_frames` 显示帧信息;
    - `-show_packets` 查看包信息;

## <font color=#009A000> 0x01 组合命令 </font>

> 参考链接 : <br/>
> 1. [FFmpeg使用手册 - ffprobe 的常用命令](http://blog.chinaunix.net/uid-11344913-id-5750194.html)

- [让 ffmpeg 支持 10bit 编码](https://www.cnblogs.com/koder/p/7851387.html)
  - `ffmpeg.exe -i input.ts -vcodec libx265 -pix_fmt yuv420p10le -acodec copy output.ts`
  - `ffmpeg -i 比利林恩_4k_60fps_h265.mkv -vcodec libx265 -pix_fmt yuv420p -acodec copy output.mkv`
- 使用 ffprobe 查看文件中帧对应时间(pts)是否对齐 :
  - `ffprobe -show_frames file | grep -E "media_type|pkt_pts_time"`
- 单独查看视频的帧信息 
  - `ffprobe -show_frame -select_streams v -of xml input.mp4`
- 串联音频视频 :
  - `ffmpeg -i "concat:01.mp4|02.mp4|03.mp4" -c copy out.mp4`
- ffplay 播放 pcm 数据:
  - `ffplay -ar 44100 -channels 2 -f s16le -i aout.pcm`
- ffmpeg 替换视频内音频:
  - `ffmpeg -i 0.mp4 -i 1.mp3 -c:v copy -c:a copy -map 0:v -map 1:a  out.flv`
- 从指定位置开始:
  - `-ss pos             seek to a given position in seconds`
    - `-ss $(echo  "18 * 60" | bc)`  从 18 分钟的地方开始;

# <font color=#0099ff> **其它** </font>

## <font color=#009A000> 0x0 x264 </font>

- [Low latency, high performance x264 options for for most streaming services (Youtube, Facebook,...)](https://obsproject.com/forum/resources/low-latency-high-performance-x264-options-for-for-most-streaming-services-youtube-facebook.726/)
- [去抖音面试被问到硬编码与软编码区别，如何选取硬编与软编？](https://my.oschina.net/u/4338729/blog/3399299)

## <font color=#009A000> 0x02 抓包 </font>

### <font color=#FF4500> 抓包 iphone </font>

- [获取iPhone手机UDID的方法](https://www.jianshu.com/p/d36943527ad0)
- [网络抓包工具](https://www.jianshu.com/p/98f16d6b8f5f)
- [iOS抓包](https://www.jianshu.com/p/e4165e8149ec)
- [url-encode-decode](https://tool.chinaz.com/tools/urlencode.aspx)
- ffmpeg 天然支持 *代理* ????
