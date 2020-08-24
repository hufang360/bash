# Windows
**Gif转mov.bat**<br>
将单个gif转成mov，支持定义gif的宽高，还可以将gif转成1080p；<br>
<br>
**Gif转mov_文件夹批量.bat**<br>
将单个文件夹下的所有gif转成mov，转换后的mov宽高和原始gif相同；<br>
<br>

## 使用方法：
脚本功能通过调用ffmpeg实现，请将 ffmpeg.exe 拷贝到脚本一起, 或者将ffmpeg添加到环境变量中。<br>

**方法1：**<br>
双击bat文件，然后拖动 文件/文件夹 到打开的命令行窗口，按提示操作即可；<br>
**方法2：**<br>
直接拖动 文件/文件夹 到bat文件上，此时会打开命令行，而且脚本已经接收要处理的文件，不会在提示拖入文件，比方法1能节约一点点时间；<br>



<br>
<br>
<br>



# Mac
**Gif2mov.sh**<br>
将单个gif转成mov，支持定义gif的宽高，还可以将gif转成1080p；<br>
<br>
**Gif2mov_folder.sh**<br>
将单个文件夹下的所有gif转成mov，转换后的mov宽高和原始gif相同；<br>

<br>

## 使用方法：
脚本功能通过调用ffmpeg实现，请将 ffmpeg 拷贝到脚本一起, 或者将ffmpeg添加到环境变量。

1、双击sh文件；<br>
2、拖动 文件/文件夹 到打开的终端窗口，然后按Enter键；<br>
3、按提示完成接下来的操作即可；<br>


<br>
<br>
<br>



# 常见问题：
Q：**是否处理成1080p？** 是什么功能？<br>
A：脚本支持创建一个1080p(1920x1080px)的画布，并将gif画面缩放到指定宽高，然后放在画布的指定位置。



<br>
<br>
<br>



# 示例素材：
示例素材来自游戏《泰拉瑞亚》，版权归泰拉瑞亚公司所有。<br>



<br>
<br>
<br>

# 核心命令
**Windows端：**
```shell
ffmpeg -i !gifFile! ^
 -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444 ^
 -s 1920x1080 -r !fps! ^
 -vf "scale=!w!:!h!,pad=1920:1080:!x!:!y!:0x00000000" ^
 -sws_flags "neighbor" ^
 "!outFile!"
```

**Mac端**
```shell
ffmpeg -i "${gifFile}" \
 -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444 \
 -s 1920x1080 -r $fps \
 -vf "scale=$w:$h,pad=1920:1080:$x:$y:0x00000000" \
 -sws_flags "neighbor" \
 "${outFile}"
```

<br>

## ProRes
ProRes编码可以让mov视频带有透明度<br>
` -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444` <br>
[更多参数](https://ffmpeg.org/ffmpeg-codecs.html#ProRes)<br>

<br>

## sws_flags
示例素材为像素画，分辨率只有36x36px，由于画风特殊，采用“邻近”放大模式放大图片人眼不会感到模糊<br>
` -sws_flags "neighbor"` <br>