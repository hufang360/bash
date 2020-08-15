@echo off&setlocal enabledelayedexpansion
title gifתmov�ű���power by ffmpeg��
rem author��hufang360
rem time��2020��07��30��






echo ==============================
echo Gifתmov�ű�
echo	1����gifת�ɴ�͸���ȵ�mov�ļ���
echo	2�������ʽΪ Apple ProRes 4444��
echo	3��֧���Զ���gif�ڻ����ϵ�λ�úͿ�ߣ�
echo	4��ת����ɺ��Զ��ڴ���Դ����������ѡ��ת����mov�ļ���
echo ==============================
echo.

rem ++++++++++++++++++++++++++++++++++++++
rem �������Ŀ¼
set output=%~dp0_gif2mov

REM �õ�ǰ�ű���ʶ��ffmpeg·��
set path=%path%;%~dp0
REM cd /d %~dp0/ffmpeg

set openWithFile=%*
if defined openWithFile ( 
	echo "������gif��"%openWithFile%
	set gifFile=%*
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
echo.
set /p gifFile=�϶� gif �ļ����⣬Ȼ�� Enter ����
REM set gifFile="D:\FFmpeg\merge convert2.gif"
if not defined gifFile (
    echo ������gif�ļ���ַ������������²���������
    pause
    goto inputFile
)
goto inputSize
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem ��ʾ����ߴ�
:inputSize
    echo.
    set /p c=�Ƿ���Ҫ����� 1080p��,Ĭ�ϡ�y����y/n����
    set /a c_num=0
    if defined c (
        if !c!==Y ( set /a c_num=1 )
        if !c!==y ( set /a c_num=1 )
    ) else (
        set /a c_num=1
    )

    if !c_num!==1 (
        rem λ��
        set /p x=����x���꣬Ĭ���ǡ�0����
        if defined x (
            set /p y=����y���꣬Ĭ���ǡ�0����
            if not defined y ( set /a y=0 )
        ) else (
            set /a x=0
            set /a y=0
        )

        rem ���
        set /p w=�����ȣ�Ĭ���ǡ�gif��ȡ���
        if defined w (
            set /p h=����߶ȣ�Ĭ���ǡ�gif�߶ȡ���
            if not defined h ( set h=ih )
        ) else (
            set w=iw
            set h=ih
        )

        rem fps
        set /p fps=����֡�ʣ�Ĭ���ǡ�30����
        if not defined fps ( set /a fps=30 )

        rem loop
        set /p loop=Ҫgif���ż��Σ�Ĭ���� 1��
        if not defined loop ( set /a loop=1 )

        REM ��gif�����ڻ���Ϊ1920x1080�Ļ�����
        goto ffmpegWithParam
    ) else (
        REM ֱ�ӽ�gifת��mov
        goto ffmpegNoParam
    )
    pause
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem ffmpegWithParam
:ffmpegWithParam
echo.
echo ==============================
echo ����Ĳ�����:
echo     x,y:      !x!,!y!
echo   ��x��:      !w!x!h!   (iw,ih��ʾgifԭʼ���)
echo   ֡ ��:      !fps!
echo   gifѭ������ !loop! ��
echo.
echo ���������ʼת�����رմ���ֱ�ӽ�����
echo ==============================
echo.
pause


set fName=""
for /f "tokens=1,2,3,4 delims=	" %%a in ("%gifFile%") do (
    rem ��ȡ�ļ���
    set fName=%%~na
    title ���ڴ���%%~nxa
    echo ���ڴ���%%~nxa
)

set outFile=%output%\!fName!.mov
echo ����ļ�Ϊ��!outFile!
if not exist "%output%" ( md "%output%" )

rem ����ffmpeg����ת��
ffmpeg -hide_banner -y ^
 -stream_loop !loop! ^
 -i !gifFile! ^
 -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444 ^
 -acodec copy ^
 -s 1920x1080 -r !fps! ^
 -vf "scale=!w!:!h!,pad=1920:1080:!x!:!y!:0x00000000" ^
 -sws_flags "neighbor" ^
 "!outFile!"

rem ����Դ��������ѡ���ļ�
explorer /select,"!outFile!"


pause
goto:eof


rem ++++++++++++++++++++++++++++++++++++++
rem ֱ�ӽ�gifת��mov
:ffmpegNoParam
echo "ffmpegNoParam:"!x!,!y!,!w!,!h!

set fName=""
for /f "tokens=1,2,3,4 delims=	" %%a in ("%gifFile%") do (
    rem ��ȡ�ļ���
    set fName=%%~na
    title ���ڴ���%%~nxa
    echo ���ڴ���%%~nxa
)

set outFile=%output%\!fName!.mov
echo ����ļ�Ϊ��!outFile!
if not exist "%output%" ( md "%output%" )

rem ����ffmpeg����ת��
ffmpeg -hide_banner -y ^
 -i !gifFile! ^
 -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444 ^
 -acodec copy ^
 -sws_flags "neighbor" ^
 "!outFile!"

rem ����Դ��������ѡ���ļ�
explorer /select,"!outFile!"

pause
goto:eof


pause