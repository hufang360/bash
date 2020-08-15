@echo off&setlocal enabledelayedexpansion
title ���ػ�����Ŵ�ű���power by ffmpeg��
rem author��hufang360

echo ==============================
echo ���ػ�����Ŵ�ű�
echo	1���ܶ����ط���ͼƬ��������Ŵ���
echo	2���Ŵ�����ɺ󣬻��Զ�����Դ��������ѡ��ͼƬ��
echo ==============================
echo.


rem ++++++++++++++++++++++++++++++++++++++
rem �������Ŀ¼
set output=%~dp0_���ػ��Ŵ�

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
set /p pngFile=�϶�png���⣬Ȼ��enter����
rem set pngFile="D:\0001.png"
if not defined pngFile (
    echo ������png�ļ���ַ��������������²���������
    pause
    goto inputFile
)
goto inputSize
goto:eof



rem ++++++++++++++++++++++++++++++++++++++
rem ��ʾ����ߴ�
:inputSize
    echo.
    rem ���
    echo �������ȣ�
    echo  ֱ�Ӱ�enter������ȷŴ�10����
    echo  ���� iw*20 ��ȷŴ�20����
    echo  ���� 200 �������Ϊ200px��
	set /p w=:
    if defined w (
        echo ������߶ȣ�
        echo  ֱ�Ӱ�enter�����߶ȷŴ�10����
        echo  ���� ih*20 �߶ȷŴ�20����
        echo  ���� 200 �߶�����Ϊ200px��
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
echo ����Ĳ�����:
echo   ��x��     !w! x !h!   
echo   iw*10    ��ʾͼƬ��ȷŴ�10��
echo   ih*10    ��ʾͼƬ�߶ȷŴ�10��
echo.
echo ���������ʼת�����رմ���ֱ�ӽ�����
echo ==============================
echo.
pause


rem ���õ����ļ����͵���Ŀ¼
set fName=""
for /f "tokens=1,2,3,4 delims=	" %%a in ("%pngFile%") do (
    rem ��ȡ�ļ���
    set fName=%%~na
    title ���ڴ���%%~nxa
    echo ���ڴ���%%~nxa
)
set outFile=%output%\!fName!.png
echo ����ļ�Ϊ��!outFile!
if not exist "%output%" ( md "%output%" )


rem ����ffmpeg����ת��
ffmpeg -hide_banner -y -i !pngFile! ^
 -vf "scale=!w!:!h!" -sws_flags "neighbor" ^
 "!outFile!"

rem ����Դ��������ѡ���ļ�
echo "!outFile!"
explorer /select,"!outFile!"


pause
goto:eof

pause