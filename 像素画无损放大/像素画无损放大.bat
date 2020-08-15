@echo off&setlocal enabledelayedexpansion
title 像素画无损放大脚本（power by ffmpeg）
rem author：hufang360

echo ==============================
echo 像素画无损放大脚本
echo	1、能对像素风格的图片进行无损放大处理；
echo	2、放大处理完成后，会自动在资源管理器中选中图片；
echo ==============================
echo.


rem ++++++++++++++++++++++++++++++++++++++
rem 定义输出目录
set output=%~dp0_像素画放大

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
set /p pngFile=拖动png到这，然后按enter键：
rem set pngFile="D:\0001.png"
if not defined pngFile (
    echo 请输入png文件地址，并按任意键重新操作！！！
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


rem 设置导出文件名和导出目录
set fName=""
for /f "tokens=1,2,3,4 delims=	" %%a in ("%pngFile%") do (
    rem 提取文件名
    set fName=%%~na
    title 正在处理：%%~nxa
    echo 正在处理：%%~nxa
)
set outFile=%output%\!fName!.png
echo 输出文件为：!outFile!
if not exist "%output%" ( md "%output%" )


rem 调用ffmpeg进行转换
ffmpeg -hide_banner -y -i !pngFile! ^
 -vf "scale=!w!:!h!" -sws_flags "neighbor" ^
 "!outFile!"

rem 在资源管理器中选中文件
echo "!outFile!"
explorer /select,"!outFile!"


pause
goto:eof

pause