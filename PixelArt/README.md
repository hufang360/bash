请将 ffmpeg.exe 和bat格式的脚本放在同一个目录下，否则脚本无法工作。<br>
ffmpeg.exe 是一个命令行工具，双击会一闪而过，它只能通过命令行来使用。<br>


# 核心命令
```shell
ffmpeg -hide_banner -y -i "!inFile!" ^
 -vf "scale=!w!:!h!" -sws_flags "neighbor" ^
 "!outFile!"
```
示例素材为像素画，分辨率非常小，由于画风特殊，采用“邻近”放大模式放大图片人眼不会感到模糊，转码参数是：<br>
-sws_flags "neighbor"<br>


# 示例素材：
示例素材 来自游戏《泰拉瑞亚》 ，版权归泰拉瑞亚公司所有。<br>