@echo off&setlocal enabledelayedexpansion
title ���ػ�����Ŵ�ű� �����棨power by ImageMagick��
rem author��hufang360
rem time: 2020��08��24��

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


set openWithFile=%*
if defined openWithFile (
	echo "�����룺"%openWithFile%
	set pngDir=%*
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
    echo  ���� 1000^%% ��ȷŴ�10����
    echo  ���� 100 �������Ϊ100px��
	set /p w=
    if defined w (
        echo ������߶ȣ�
        echo  ֱ�Ӱ�enter�����߶ȷŴ�10����
        echo  ���� 1000^%% �߶ȷŴ�10����
        echo  ���� 100 �߶�����Ϊ100px��
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
rem ffmpegWithParam
:ImageMagickWithParam
echo ==============================
echo ����Ĳ�����:
echo   ��x��     !w! x !h!
echo   1000^%%    ��ʾͼƬ��ȷŴ�10��
echo   1000^%%    ��ʾͼƬ�߶ȷŴ�10��
echo.
echo ���������ʼת�����رմ���ֱ�ӽ�����
echo ==============================
echo.
pause



set fName=""
cd %pngDir%
for /f "delims=" %%a in ('dir /a-d /b /s %pngDir%\*.png') do (
    rem ��ȡ�ļ���
    set "fName=%%~na"
    title ���ڴ���%%~nxa
    echo ���ڴ���%%~nxa

    set "inFile=%%~dpnxa"
    set "outFile=%output%\%%~nxa"
    REM echo �����ļ�Ϊ��!inFile!
    REM echo ����ļ�Ϊ��!outFile!
	rem �������Ŀ¼
	if not exist "%output%" ( md "%output%" )

    rem ����ImageMagick����ת��
    %~dp0convert.exe "!inFile!" -filter Point -resize "!w!x!h!" "!outFile!"
)

set outFile=%output%\!fName!.png
echo ����ļ�Ϊ��!outFile!
title �������!

rem ����Դ��������ѡ���ļ�
if defined outFile (
    explorer /select,"!outFile!"
)

pause
goto:eof

pause