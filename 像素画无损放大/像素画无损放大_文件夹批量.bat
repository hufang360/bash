@echo off&setlocal enabledelayedexpansion
title 像素画无损放大脚本 批量版（power by ffmpeg）
rem author：hufang360

echo ==============================
echo 像素画无损放大脚本 批量版
echo	1、对指定目录下的所有像素风格的图片进行无损放大处理；
echo	2、脚本只会处理指定目录下的png格式的图片；
echo	3、放大后的图片会保存在“_像素画放大_批量”目录下；
echo	4、处理完后，会自动在资源管理器中选中最后一张图片；
echo ==============================
echo.

rem ++++++++++++++++++++++++++++++++++++++
rem 定义输出目录
set output=%~dp0_像素画放大_批量

REM 让当前脚本能识别ffmpeg路径
set path=%path%;%~dp0
REM cd /d %~dp0/ffmpeg

rem ++++++++++++++++++++++++++++++++++++++
rem 提示拖入文件
goto inputFile
pause
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem 输入文件提示
:inputFile
echo.
set /p pngDir=拖动文件夹到这，然后敲enter键：
rem set "pngDir=D:\pixel pngs"
if not defined pngDir (
    echo 操作不正确：请拖入文件夹
    echo 按任意键重新操作！！！
    pause
    goto inputFile
)
goto inputSize
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem 提示输入尺寸
:inputSize
    echo.
    rem 宽高
    echo 请输入宽度：
    echo  直接按enter键，宽度放大10倍；
    echo  输入 iw*20 宽度放大20倍；
    echo  输入 200 宽度设置为200px；
	set /p w=:
    if defined w (
        echo 请输入高度：
        echo  直接按enter键，高度放大10倍；
        echo  输入 ih*20 高度放大20倍；
        echo  输入 200 高度设置为200px；
		set /p h=:
        if not defined h ( set h=ih*10 )
    ) else (
        set w=iw*10
        set h=ih*10
    )
    goto ffmpegWithParam
    pause
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem ffmpegWithParam
:ffmpegWithParam
echo ==============================
echo 输入的参数是:
echo   宽x高     !w! x !h!   
echo   iw*10    表示图片宽度放大10倍
echo   ih*10    表示图片高度放大10倍
echo.
echo 按任意键开始转换，关闭窗口直接结束！
echo ==============================
echo.
pause



set fName=""
cd %pngDir%
for /r %%a in ( *.png ) do (
    rem 提取文件名
    set "fName=%%~na"
    title 正在处理：%%~nxa
    echo 正在处理：%%~nxa
    
    set inFile=%%~nxa
    set outFile=%output%\!fName!.png
    echo 输入文件为：!inFile!
    echo 输出文件为：!outFile!
	rem 创建输出目录
	if not exist "%output%" ( md "%output%" )


    rem 调用ffmpeg进行转换
    ffmpeg -hide_banner -y -i "!inFile!" ^
     -vf "scale=!w!:!h!" -sws_flags "neighbor" ^
     "!outFile!"
)

set outFile=%output%\!fName!.png
echo 输出文件为：!outFile!

rem 在资源管理器中选中文件
if defined outFile (
    explorer /select,"!outFile!"
)

pause
goto:eof

pause