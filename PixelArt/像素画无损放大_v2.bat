@echo off&setlocal enabledelayedexpansion
title 像素画无损放大脚本（power by ImageMagick）
rem author：hufang360
rem time: 2020年08月24日

echo ==============================
echo 像素画无损放大脚本
echo	1、能对像素风格的图片进行无损放大处理；
echo	2、放大处理完成后，会自动在资源管理器中选中图片；
echo ==============================
echo.


rem ++++++++++++++++++++++++++++++++++++++
rem 定义输出目录
set output=%~dp0_像素画放大

REM 让当前脚本能识别ImageMagick路径
set path=%path%;%~dp0
REM cd /d %~dp0/ImageMagick



set openWithFile=%*
if defined openWithFile ( 
	echo "已拖入文件："%openWithFile%
	set pngFile=%*
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
    echo 宽高输入说明：
    echo   输入1000^%% 表示放大10倍
    echo   输入100 表示缩放至100px
    echo.
    echo 请输入宽度（默认 1000^%%）
	set /p w=
    if defined w (
        echo 请输入高度 （默认 1000^%%）
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
rem ImageMagickWithParam
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


rem 设置导出文件名和导出目录
set fName=""
for %%a in (!pngFile!) do (
    rem 提取文件名
    set fName=%%~nxa
    title 正在处理：%%~nxa
    echo 正在处理：%%~nxa
    set "inFile=%%~dpnxa"
    set "outFile=%output%\%%~nxa"
    echo 输出文件为：!outFile!
    if not exist "%output%" ( md "%output%" )
)

rem 调用ImageMagick进行转换
%~dp0convert.exe "!inFile!" -filter Point -resize !w!x!h! "!outFile!"

rem 在资源管理器中选中文件
echo "!outFile!"
explorer /select,"!outFile!"


pause
goto:eof

pause