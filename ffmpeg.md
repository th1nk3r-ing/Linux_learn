# <font color=#0099ff> **ffmpeg 相关** </font>

> `@think3r` 2020-07-07 14:11:15

## <font color=#009A000> 0x00 ffmpeg </font>

- [FFmpeg命令行工具学习(一)：查看媒体文件头信息工具ffprobe](https://www.cnblogs.com/renhui/p/9209664.html)
  - 用来查看媒体文件格式的工具 :
    - `-show_format`  输出格式信息;
    - `-print_format json` 以 JSON 格式输出;
    - `-show_frames` 显示帧信息;
    - `-show_packets` 查看包信息;
- [让ffmpeg支持10bit编码](https://www.cnblogs.com/koder/p/7851387.html)
  - `ffmpeg.exe -i input.ts -vcodec libx265 -pix_fmt yuv420p10le -acodec copy output.ts`
  - `ffmpeg -i 比利林恩_4k_60fps_h265.mkv -vcodec libx265 -pix_fmt yuv420p -acodec copy output.mkv`

## <font color=#009A000> 0x01 x264 </font>

- [Low latency, high performance x264 options for for most streaming services (Youtube, Facebook,...)](https://obsproject.com/forum/resources/low-latency-high-performance-x264-options-for-for-most-streaming-services-youtube-facebook.726/)
- [去抖音面试被问到硬编码与软编码区别，如何选取硬编与软编？](https://my.oschina.net/u/4338729/blog/3399299)

## <font color=#009A000> 0x02 抓包 </font>

### <font color=#FF4500> 抓包 iphone </font>

- [获取iPhone手机UDID的方法](https://www.jianshu.com/p/d36943527ad0)
- [网络抓包工具](https://www.jianshu.com/p/98f16d6b8f5f)
- [iOS抓包](https://www.jianshu.com/p/e4165e8149ec)
- [url-encode-decode](https://tool.chinaz.com/tools/urlencode.aspx)
- ffmpeg 天然支持 *代理* ????
