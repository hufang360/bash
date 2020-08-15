@echo off&setlocal enabledelayedexpansion
title Gif转mov脚本（power by ffmpeg）
rem author：hufang360
rem time：2020年08月09日

echo ==============================
echo Gif转mov脚本
echo	1、将gif转成带透明度的mov文件；
echo	2、编码格式为 Apple ProRes 4444；
echo ==============================
echo.

rem ++++++++++++++++++++++++++++++++++++++
rem 定义输出目录
set output=%~dp0_gif2mov

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
set /p inputDir=拖动文件夹 到这，然后按Enter键：
if not defined inputDir (
    echo 请输入文件夹，按任意键重新操作！！！
    pause
    goto inputFile
)

goto ffmpegFolder
pause
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem 查找文件夹下的gif，并转成mov
:ffmpegFolder
set fName=""
cd %inputDir%

set /a count=0
for /r %%a in ( *.gif ) do (
    set /a count+=1

    rem 提取文件名
    set "fName=%%~na"
    title 正在处理：%%~nxa
    echo 正在处理：%%~nxa

    set inFile="%%~nxa"
    set outFile=%output%\!fName!.mov
    echo 输入文件为：!inFile!
    echo 输出文件为：!outFile!

	rem 创建输出目录
	if not exist "%output%" ( md "%output%" )

    ffmpeg -hide_banner -y ^
     -i !inFile! ^
     -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444 ^
     -acodec copy ^
     "!outFile!"
)
echo 操作完成，已处理 !count! 个gif
title 操作完成，已处理 !count! 个gif
echo 温馨提示：按任意键脚本将自动打开所在文件夹，退出请直接关闭窗口！
pause
rem 在资源管理器中选中文件
if defined outFile (
    explorer /select,"!outFile!"
)
goto:eof

