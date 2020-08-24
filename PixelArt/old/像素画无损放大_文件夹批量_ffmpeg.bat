@echo off&setlocal enabledelayedexpansion
title ���ػ�����Ŵ�ű� �����棨power by ffmpeg��
rem author��hufang360

echo ==============================
echo ���ػ�����Ŵ�ű� ������
echo	1����ָ��Ŀ¼�µ��������ط���ͼƬ��������Ŵ���
echo	2���ű�ֻ�ᴦ��ָ��Ŀ¼�µ�png��ʽ��ͼƬ��
echo	3���Ŵ���ͼƬ�ᱣ���ڡ�_���ػ��Ŵ�_������Ŀ¼�£�
echo	4��������󣬻��Զ�����Դ��������ѡ�����һ��ͼƬ��
echo ==============================
echo.

rem ++++++++++++++++++++++++++++++++++++++
rem �������Ŀ¼
set output=%~dp0_���ػ��Ŵ�_����

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
set /p pngDir=�϶��ļ��е��⣬Ȼ����enter����
rem set "pngDir=D:\pixel pngs"
if not defined pngDir (
    echo ��������ȷ���������ļ���
    echo ����������²���������
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



set fName=""
cd %pngDir%
for /r %%a in ( *.png ) do (
    rem ��ȡ�ļ���
    set "fName=%%~na"
    title ���ڴ���%%~nxa
    echo ���ڴ���%%~nxa
    
    set inFile=%%~nxa
    set outFile=%output%\!fName!.png
    echo �����ļ�Ϊ��!inFile!
    echo ����ļ�Ϊ��!outFile!
	rem �������Ŀ¼
	if not exist "%output%" ( md "%output%" )


    rem ����ffmpeg����ת��
    ffmpeg -hide_banner -y -i "!inFile!" ^
     -vf "scale=!w!:!h!" -sws_flags "neighbor" ^
     "!outFile!"
)

set outFile=%output%\!fName!.png
echo ����ļ�Ϊ��!outFile!

rem ����Դ��������ѡ���ļ�
if defined outFile (
    explorer /select,"!outFile!"
)

pause
goto:eof

pause