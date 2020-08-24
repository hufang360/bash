@echo off&setlocal enabledelayedexpansion
title 贴图分割脚本（power by ImageMagick）
rem author：hufang360
rem time：2020年08月11日



echo ==============================
echo 贴图分割脚本
echo	1、将贴图按等份分割；
echo	2、支持放大分割后的图片，使用“邻近”进行方法，像素画不会变模糊；
echo	3、支持选择全部/部分图片生成gif；
echo.
echo.
echo 脚本功能 通过ImageMagick实现
echo 请保证脚本目录下存在 convert.exe (ImageMagick命令行工具)
echo ==============================
echo.

rem ++++++++++++++++++++++++++++++++++++++
rem 定义输出目录
set output=%~dp0

REM 让当前脚本能识别ImageMagick路径
set path=%path%;%~dp0

set openWithFile=%*
if defined openWithFile (
	echo 已拖入png：%openWithFile%
	set inFile=%*
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
REM set inFile="Projectile_881.png"
REM set inFile="Armor_1.png"

set /p inFile=拖动 png 文件到这，然后按 Enter 键：
if not defined inFile (
    echo 请输入png文件地址，按任意键重新操作！！！
    pause
    goto inputFile
)
goto inputSize
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem 提示输入尺寸
:inputSize
    echo.
    rem 提示输入参数
    set /p row=纵向是几行(默认 1)：
    set /p col=横向是几列(默认 1)：
    set /p scale=需要放大几倍(默认 1)(邻近)：

    rem 修正初始值
    if not defined row    set /a row=1
    if not defined col    set /a col=1
    if not defined scale    set /a scale=1

    rem 进行裁切
    goto cropSprite
    pause
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
:cropSprite
set fName=""
for /f "tokens=1,2,3,4 delims=	" %%a in ("%inFile%") do (
    rem 提取文件名
    set fName=%%~na
    title 正在处理：%%~nxa
    echo 正在处理：%%~nxa
)

rem 为序列帧创建文件夹
set pngsDir=%output%!fName!__im\
if not exist "%pngsDir%" (
    md "%pngsDir%"
) else (
    rem 删除重建
    rd /s/q "%pngsDir%"
    md "%pngsDir%"
)

rem 获取sprite的宽高
for /f "delims=" %%i in ('convert !inFile! -format "%%w" info:') do (set pngW=%%i)
for /f "delims=" %%i in ('convert !inFile! -format "%%h" info:') do (set pngH=%%i)
echo 贴图大小: !pngW! x !pngH!

rem 单帧的宽高
set /a oneW=!pngW!/!col!
set /a oneH=!pngH!/!row!
REM echo total:!total!
REM echo oneW:!oneW! oneH:!oneH!
if !scale! GTR 1 (
    set /a sOneW=!oneW!*!scale!
    set /a sOneH=!oneH!*!scale!
    echo 单帧大小: !sOneW! x !sOneH!
) else (
    echo 单帧大小: !oneW! x !oneH!
)

rem 使用imagemagick 循环分割
set /a count=0
set /a total=!row!*!col!
call :convertLoop

echo.
echo 分割完成！


rem --------------------
rem 生成gif
echo.
set /p needGif=需要生成Gif么（默认不生成，要生成请输入1）
if !needGif! EQU 1  (
    call :makeGif
)
rem --------------------

echo.
echo 分割目录： .\!fName!__im\

echo.
echo 搞定了;-)
echo.


echo.
echo 按任意键打开输出文件夹，退出请关闭窗口
pause

rem 在资源管理器中选中文件
echo !outFile!
explorer /select,"!outFile!"
pause
rem 脚本结束
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
:makeGif
echo --------------------
echo.
echo 即将生成gif
echo.
echo --------------------
set /p delay=单帧的延迟数（默认为10，即0.1秒）：
set /p startFrame=gif的起始帧（默认 1）：
set /p endFrame=gif的结束帧（默认 最后一帧）：
if not defined delay  set /a delay=10
if not defined startFrame  set /a startFrame=1
if not defined endFrame  set /a endFrame=!total!
if !endFrame! GTR !total! set /a endFrame=!total!

rem 查找参与合成的png名称
set /a count=!startFrame!-1
call :getFrameLoop
rem 输出文件
set outFile=%output%!fName!__im.gif

rem 调用ImageMagick将多张png转成gif
convert -delay !delay! -loop 0 !frames! -set dispose background +repage "!outFile!"
echo.
echo "!fName!__im.gif" 已生成!
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem 使用imagemagick 循环分割
:convertLoop
if !count! LSS !total! (
    REM rx求余数
    REM ry除数 向下取整
    set /a rx=!count!%%!col!
    set /a ry=!count!/!col!

    set NUMBER=!ry!.
    set /A ry=NUMBER+0
    REM echo floor(ry):!ry!

    set /a cx= !rx!*!oneW!
    set /a cy= !ry!*!oneH!


    set /a count+=1
    rem %04d.png  0001.png / 0010.png / 0100.png
    if !count! GEQ 0 if !count! LSS 10    set frame_num=000!count!
    if !count! GEQ 10 if !count! LSS 100    set frame_num=00!count!
    if !count! GEQ 100 if !count! LSS 1000    set frame_num=0!count!
    set outFile=!pngsDir!!frame_num!.png

    title !fName! （!frame_num!）
    echo 正在生成 !frame_num!.png

    rem 调用imagemagick进行切割
    if !scale! GTR 1 (
        REM 分割并按比例放大处理，  GTR 大于，LSS 小于
        REM -filter Point 像素画放大不会变模糊
        set /a sOneW=!oneW!*!scale!
        set /a sOneH=!oneH!*!scale!
        convert !inFile! -crop !oneW!x!oneH!+!cx!+!cy! -filter Point -resize !sOneW!x!sOneH! "!outFile!"
    ) else (
        rem 正常分割
        convert !inFile! -crop !oneW!x!oneH!+!cx!+!cy! "!outFile!"
    )

    rem 循环执行
    goto convertLoop
)
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem 查找参与合成的png名称
:getFrameLoop
if !count! LSS !endFrame! (
    set /a count+=1

    rem %04d.png  0001.png / 0010.png / 0100.png
    if !count! GEQ 0 if !count! LSS 10    set frame_num=000!count!
    if !count! GEQ 10 if !count! LSS 100    set frame_num=00!count!
    if !count! GEQ 100 if !count! LSS 1000    set frame_num=0!count!

    if not defined frames (
        set frames="!pngsDir!!frame_num!.png"
    ) else (
        set frames=!frames! "!pngsDir!!frame_num!.png"
    )
    REM echo !count!
    REM echo !frames!

    rem 循环执行
    goto getFrameLoop
)
goto:eof