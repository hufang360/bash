@echo off&setlocal enabledelayedexpansion
title Gifתmov�ű���power by ffmpeg��
rem author��hufang360
rem time��2020��08��09��

echo ==============================
echo Gifתmov�ű�
echo	1����gifת�ɴ�͸���ȵ�mov�ļ���
echo	2�������ʽΪ Apple ProRes 4444��
echo ==============================
echo.

rem ++++++++++++++++++++++++++++++++++++++
rem �������Ŀ¼
set output=%~dp0_gif2mov

REM �õ�ǰ�ű���ʶ��ffmpeg·��
set path=%path%;%~dp0
REM cd /d %~dp0/ffmpeg


rem ++++++++++++++++++++++++++++++++++++++
rem ��ʾ�����ļ�
goto inputFile
pause
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem �����ļ���ʾ
:inputFile
echo.
set /p inputDir=�϶��ļ��� ���⣬Ȼ��Enter����
if not defined inputDir (
    echo �������ļ��У�����������²���������
    pause
    goto inputFile
)

goto ffmpegFolder
pause
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem �����ļ����µ�gif����ת��mov
:ffmpegFolder
set fName=""
cd %inputDir%

set /a count=0
for /r %%a in ( *.gif ) do (
    set /a count+=1

    rem ��ȡ�ļ���
    set "fName=%%~na"
    title ���ڴ���%%~nxa
    echo ���ڴ���%%~nxa

    set inFile="%%~nxa"
    set outFile=%output%\!fName!.mov
    echo �����ļ�Ϊ��!inFile!
    echo ����ļ�Ϊ��!outFile!

	rem �������Ŀ¼
	if not exist "%output%" ( md "%output%" )

    ffmpeg -hide_banner -y ^
     -i !inFile! ^
     -vcodec prores_ks -pix_fmt yuva444p10le -profile:v 4444 ^
     -acodec copy ^
     "!outFile!"
)
echo ������ɣ��Ѵ��� !count! ��gif
title ������ɣ��Ѵ��� !count! ��gif
echo ��ܰ��ʾ����������ű����Զ��������ļ��У��˳���ֱ�ӹرմ��ڣ�
pause
rem ����Դ��������ѡ���ļ�
if defined outFile (
    explorer /select,"!outFile!"
)
goto:eof

