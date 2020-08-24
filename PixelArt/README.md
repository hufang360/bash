# 什么是 像素画？
像素画，强调清晰的轮廓、明快的色彩，且大多图片分辨率非常小，一般认知里图片放大会变模糊，但由于像素画画风特殊，采用“邻近”放大模式放大图片人眼不会感到模糊。<br>

![slime_36.png](../img/slime_36.png)
<br>
**↓放大十倍↓**
<br>
![slime_360.png](../img/slime_360.png) <br>
<br>
上面两张图片中，第一张的尺寸是 **36x36px** ，第二张的尺寸是 **360x360px** 。<br><br><br>



# 使用说明
调用 ffmpeg 和 Imagemagick 都能实现，不过ffmpeg在处理256色的图片时会有问题，im的则没有这个问题。<br><br>


**像素画无损放大_v2.bat**<br>
将单张png放大；<br>
<br>
**像素画无损放大_文件夹批量_v2.bat**<br>
将单个文件夹下的所有png统一放大；<br>
<br>
上面这两个脚本是通过 Imagemagick 实现的，ffmpeg版已归档到 **old** 目录下<br>
`./old/像素画无损放大_文件夹批量_ffmpeg.bat`<br>
`./old/像素画无损放大_ffmpeg.bat`<br><br><br>





# 技术实现
## ImageMagick
```shell
convert "!inFile!" -filter Point -resize !w!x!h! "!outFile!"
```
`-filter Point`，即将缩放模式设置成“邻近”。<br><br><br>



## ffmpeg
ffmpeg支持在缩放图像/视频时调节放大模式。<br>
windows端代码：
```shell
ffmpeg -hide_banner -y -i "!inFile!" ^
 -vf "scale=!w!:!h!" -sws_flags "neighbor" ^
 "!outFile!"
```

`-sws_flags "neighbor"`，即将缩放模式设置成“邻近”。<br><br>

**注意：**<br>
1、需要注意的是 `-sws_flags` 和 `-vf` 一起使用才能生效；<br>
2、实践发现 256色的图片在放大后，原来透明部分会变成黑色，使用ImageMagick则没有这个问题。ffmpeg的专长是处理音视频，单独的图片缩放建议使用Imagemagick处理。<br>
![256色图片样本](./示例_猩红魔杖.png)


<br><br><br>
# 示例素材：
示例素材 来自游戏《泰拉瑞亚》 ，版权归泰拉瑞亚公司所有。<br>