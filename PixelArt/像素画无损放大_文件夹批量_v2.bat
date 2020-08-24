@echo off&setlocal enabledelayedexpansion
title 像素画无损放大脚本 批量版（power by ImageMagick）
rem author：hufang360
rem time: 2020年08月24日

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


set openWithFile=%*
if defined openWithFile (
	echo "已拖入："%openWithFile%
	set pngDir=%*
	goto inputSize
	goto:eof
)


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
    echo  输入 1000^%% 宽度放大10倍；
    echo  输入 100 宽度设置为100px；
	set /p w=
    if defined w (
        echo 请输入高度：
        echo  直接按enter键，高度放大10倍；
        echo  输入 1000^%% 高度放大10倍；
        echo  输入 100 高度设置为100px；
		set /p h=
        if not defined h ( set h=1000^%% )
    ) else (
        set w=1000^%%
        set h=1000^%%
    )
    goto ImageMagickWithParam
    pause
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem ffmpegWithParam
:ImageMagickWithParam
echo ==============================
echo 输入的参数是:
echo   宽x高     !w! x !h!
echo   1000^%%    表示图片宽度放大10倍
echo   1000^%%    表示图片高度放大10倍
echo.
echo 按任意键开始转换，关闭窗口直接结束！
echo ==============================
echo.
pause



set fName=""
cd %pngDir%
for /f "delims=" %%a in ('dir /a-d /b /s %pngDir%\*.png') do (
    rem 提取文件名
    set "fName=%%~na"
    title 正在处理：%%~nxa
    echo 正在处理：%%~nxa

    set "inFile=%%~dpnxa"
    set "outFile=%output%\%%~nxa"
    REM echo 输入文件为：!inFile!
    REM echo 输出文件为：!outFile!
	rem 创建输出目录
	if not exist "%output%" ( md "%output%" )

    rem 调用ImageMagick进行转换
    %~dp0convert.exe "!inFile!" -filter Point -resize "!w!x!h!" "!outFile!"
)

set outFile=%output%\!fName!.png
echo 输出文件为：!outFile!
title 操作完成!

rem 在资源管理器中选中文件
if defined outFile (
    explorer /select,"!outFile!"
)

pause
goto:eof

pause