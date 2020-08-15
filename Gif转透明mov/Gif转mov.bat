@echo off&setlocal enabledelayedexpansion
title gif转mov脚本（power by ffmpeg）
rem author：hufang360
rem time：2020年07月30日






echo ==============================
echo Gif转mov脚本
echo	1、将gif转成带透明度的mov文件；
echo	2、编码格式为 Apple ProRes 4444；
echo	3、支持自定义gif在画布上的位置和宽高；
echo	4、转码完成后，自动在打开资源管理器，并选中转码后的mov文件；
echo ==============================
echo.

rem ++++++++++++++++++++++++++++++++++++++
rem 定义输出目录
set output=%~dp0_gif2mov

REM 让当前脚本能识别ffmpeg路径
set path=%path%;%~dp0
REM cd /d %~dp0/ffmpeg

set openWithFile=%*
if defined openWithFile ( 
	echo "已拖入gif："%openWithFile%
	set gifFile=%*
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
set /p gifFile=拖动 gif 文件到这，然后按 Enter 键：
REM set gifFile="D:\FFmpeg\merge convert2.gif"
if not defined gifFile (
    echo 请输入gif文件地址，按任意键重新操作！！！
    pause
    goto inputFile
)
goto inputSize
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem 提示输入尺寸
:inputSize
    echo.
    set /p c=是否需要处理成 1080p？,默认“y”（y/n）：
    set /a c_num=0
    if defined c (
        if !c!==Y ( set /a c_num=1 )
        if !c!==y ( set /a c_num=1 )
    ) else (
        set /a c_num=1
    )

    if !c_num!==1 (
        rem 位置
        set /p x=输入x坐标，默认是“0”：
        if defined x (
            set /p y=输入y坐标，默认是“0”：
            if not defined y ( set /a y=0 )
        ) else (
            set /a x=0
            set /a y=0
        )

        rem 宽高
        set /p w=输入宽度，默认是“gif宽度”：
        if defined w (
            set /p h=输入高度，默认是“gif高度“：
            if not defined h ( set h=ih )
        ) else (
            set w=iw
            set h=ih
        )

        rem fps
        set /p fps=输入帧率，默认是“30”：
        if not defined fps ( set /a fps=30 )

        rem loop
        set /p loop=要gif播放几次，默认是 1：
        if not defined loop ( set /a loop=1 )

        REM 将gif放置在画布为1920x1080的画布上
        goto ffmpegWithParam
    ) else (
        REM 直接将gif转成mov
        goto ffmpegNoParam
    )
    pause
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem ffmpegWithParam
:ffmpegWithParam
echo.
echo ==============================
echo 输入的参数是:
echo     x,y:      !x!,!y!
echo   宽x高:      !w!x!h!   (iw,ih表示gif原始宽高)
echo   帧 率:      !fps!
echo   gif循环播放 !loop! 次
echo.
echo 按任意键开始转换，关闭窗口直接结束！
echo ==============================
echo.
pause


set fName=""
for /f "tokens=1,2,3,4 delims=	" %%a in ("%gifFile%") do (
    rem 提取文件名
    set fName=%%~na
    title 正在处理：%%~nxa
    echo 正在处理：%%~nxa
)

set outFile=%output%\!fName!.mov
echo 输出文件为：!outFile!
if not exist "%output%" ( md "%output%" )

rem 调用ffmpeg进行转换
ffmpeg -hide_banner -y ^
 -stream_loop !loop! ^
 -i !gifFile! ^
 -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444^
 -acodec copy ^
 -s 1920x1080 -r !fps! ^
 -vf "scale=!w!:!h!,pad=1920:1080:!x!:!y!:0x00000000" ^
 -sws_flags "neighbor" ^
 "!outFile!"

rem 在资源管理器中选中文件
explorer /select,"!outFile!"


pause
goto:eof


rem ++++++++++++++++++++++++++++++++++++++
rem 直接将gif转成mov
:ffmpegNoParam
echo "ffmpegNoParam:"!x!,!y!,!w!,!h!

set fName=""
for /f "tokens=1,2,3,4 delims=	" %%a in ("%gifFile%") do (
    rem 提取文件名
    set fName=%%~na
    title 正在处理：%%~nxa
    echo 正在处理：%%~nxa
)

set outFile=%output%\!fName!.mov
echo 输出文件为：!outFile!
if not exist "%output%" ( md "%output%" )

rem 调用ffmpeg进行转换
ffmpeg -hide_banner -y ^
 -i !gifFile! ^
 -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444 ^
 -acodec copy ^
 -sws_flags "neighbor" ^
 "!outFile!"

rem 在资源管理器中选中文件
explorer /select,"!outFile!"

pause
goto:eof


pause