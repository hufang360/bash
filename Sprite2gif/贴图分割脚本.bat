@echo off&setlocal enabledelayedexpansion
title ��ͼ�ָ�ű���power by ImageMagick��
rem author��hufang360
rem time��2020��08��11��



echo ==============================
echo ��ͼ�ָ�ű�
echo	1������ͼ���ȷݷָ
echo	2��֧�ַŴ�ָ���ͼƬ��ʹ�á��ڽ������з��������ػ������ģ����
echo	3��֧��ѡ��ȫ��/����ͼƬ����gif��
echo.
echo.
echo �ű����� ͨ��ImageMagickʵ��
echo �뱣֤�ű�Ŀ¼�´��� convert.exe (ImageMagick�����й���)
echo ==============================
echo.

rem ++++++++++++++++++++++++++++++++++++++
rem �������Ŀ¼
set output=%~dp0

REM �õ�ǰ�ű���ʶ��ImageMagick·��
set path=%path%;%~dp0

set openWithFile=%*
if defined openWithFile (
	echo ������png��%openWithFile%
	set inFile=%*
	goto inputSize
	goto:eof
)



rem ++++++++++++++++++++++++++++++++++++++
rem ��ʾ�����ļ�
goto inputFile
pause
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem �����ļ���ʾ
:inputFile
REM set inFile="Projectile_881.png"
REM set inFile="Armor_1.png"

set /p inFile=�϶� png �ļ����⣬Ȼ�� Enter ����
if not defined inFile (
    echo ������png�ļ���ַ������������²���������
    pause
    goto inputFile
)
goto inputSize
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem ��ʾ����ߴ�
:inputSize
    echo.
    rem ��ʾ�������
    set /p row=�����Ǽ���(Ĭ�� 1)��
    set /p col=�����Ǽ���(Ĭ�� 1)��
    set /p scale=��Ҫ�Ŵ󼸱�(Ĭ�� 1)(�ڽ�)��

    rem ������ʼֵ
    if not defined row    set /a row=1
    if not defined col    set /a col=1
    if not defined scale    set /a scale=1

    rem ���в���
    goto cropSprite
    pause
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
:cropSprite
set fName=""
for /f "tokens=1,2,3,4 delims=	" %%a in ("%inFile%") do (
    rem ��ȡ�ļ���
    set fName=%%~na
    title ���ڴ���%%~nxa
    echo ���ڴ���%%~nxa
)

rem Ϊ����֡�����ļ���
set pngsDir=%output%!fName!__im\
if not exist "%pngsDir%" (
    md "%pngsDir%"
) else (
    rem ɾ���ؽ�
    rd /s/q "%pngsDir%"
    md "%pngsDir%"
)

rem ��ȡsprite�Ŀ��
for /f "delims=" %%i in ('convert !inFile! -format "%%w" info:') do (set pngW=%%i)
for /f "delims=" %%i in ('convert !inFile! -format "%%h" info:') do (set pngH=%%i)
echo ��ͼ��С: !pngW! x !pngH!

rem ��֡�Ŀ��
set /a oneW=!pngW!/!col!
set /a oneH=!pngH!/!row!
REM echo total:!total!
REM echo oneW:!oneW! oneH:!oneH!
if !scale! GTR 1 (
    set /a sOneW=!oneW!*!scale!
    set /a sOneH=!oneH!*!scale!
    echo ��֡��С: !sOneW! x !sOneH!
) else (
    echo ��֡��С: !oneW! x !oneH!
)

rem ʹ��imagemagick ѭ���ָ�
set /a count=0
set /a total=!row!*!col!
call :convertLoop

echo.
echo �ָ���ɣ�


rem --------------------
rem ����gif
echo.
set /p needGif=��Ҫ����Gifô��Ĭ�ϲ����ɣ�Ҫ����������1��
if !needGif! EQU 1  (
    call :makeGif
)
rem --------------------

echo.
echo �ָ�Ŀ¼�� .\!fName!__im\

echo.
echo �㶨��;-)
echo.


echo.
echo �������������ļ��У��˳���رմ���
pause

rem ����Դ��������ѡ���ļ�
echo !outFile!
explorer /select,"!outFile!"
pause
rem �ű�����
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
:makeGif
echo --------------------
echo.
echo ��������gif
echo.
echo --------------------
set /p delay=��֡���ӳ�����Ĭ��Ϊ10����0.1�룩��
set /p startFrame=gif����ʼ֡��Ĭ�� 1����
set /p endFrame=gif�Ľ���֡��Ĭ�� ���һ֡����
if not defined delay  set /a delay=10
if not defined startFrame  set /a startFrame=1
if not defined endFrame  set /a endFrame=!total!
if !endFrame! GTR !total! set /a endFrame=!total!

rem ���Ҳ���ϳɵ�png����
set /a count=!startFrame!-1
call :getFrameLoop
rem ����ļ�
set outFile=%output%!fName!__im.gif

rem ����ImageMagick������pngת��gif
convert -delay !delay! -loop 0 !frames! -set dispose background +repage "!outFile!"
echo.
echo "!fName!__im.gif" ������!
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem ʹ��imagemagick ѭ���ָ�
:convertLoop
if !count! LSS !total! (
    REM rx������
    REM ry���� ����ȡ��
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

    title !fName! ��!frame_num!��
    echo �������� !frame_num!.png

    rem ����imagemagick�����и�
    if !scale! GTR 1 (
        REM �ָ�������Ŵ���  GTR ���ڣ�LSS С��
        REM -filter Point ���ػ��Ŵ󲻻��ģ��
        set /a sOneW=!oneW!*!scale!
        set /a sOneH=!oneH!*!scale!
        convert !inFile! -crop !oneW!x!oneH!+!cx!+!cy! -filter Point -resize !sOneW!x!sOneH! "!outFile!"
    ) else (
        rem �����ָ�
        convert !inFile! -crop !oneW!x!oneH!+!cx!+!cy! "!outFile!"
    )

    rem ѭ��ִ��
    goto convertLoop
)
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem ���Ҳ���ϳɵ�png����
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

    rem ѭ��ִ��
    goto getFrameLoop
)
goto:eof