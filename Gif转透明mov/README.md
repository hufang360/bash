请将 ffmpeg.exe 和 bat格式的脚本 放在同一个目录下，否则脚本无法工作。
ffmpeg.exe 是一个命令行工具，双击它会一闪而过，它只能通过命令行来使用。



# 使用方法：
1、双击 “Gif转mov.bat”，然后拖动文件到cmd命令行窗口，按提示操作即可；
2、拖动gif到bat文件上，打开cmd命令行窗口，此时脚本已经知道要处理的文件，按提示做其它操作即可；



# 常见问题：
Q：“是否处理成1080p？”是什么功能？
A：启用这个功能后，脚本会让让输入 x坐标、y坐标、宽度、高度 信息，是的此时脚本会创建一个1080p(1920x1080px)的画布，并将gif画面缩放到指定宽高，然后放在画布的指定位置。




# 示例素材版权：
“Slime Prince.gif” 来自沙盒类像素风的游戏《泰拉瑞亚》 ，版权归泰拉瑞亚公司所有。




# 核心命令
```shell
ffmpeg -i !gifFile! ^
 -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444 ^
 -s 1920x1080 -r !fps! ^
 -vf "scale=!w!:!h!,pad=1920:1080:!x!:!y!:0x00000000" ^
 -sws_flags "neighbor" ^
 "!outFile!"
```
## ProRes
ProRes编码可以让mov视频带有透明度，相关转码参数是
“-vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444”
[ProRes官方文档](https://ffmpeg.org/ffmpeg-codecs.html#ProRes)

## 缩放
示例素材为像素画，分辨率只有36x36px，由于画风特殊，采用“邻近”放大模式放大图片人眼不会感到模糊，转码参数是：
-sws_flags "neighbor"