@echo off&setlocal enabledelayedexpansion
title ���ػ�����Ŵ�ű���power by ImageMagick��
rem author��hufang360
rem time: 2020��08��24��

echo ==============================
echo ���ػ�����Ŵ�ű�
echo	1���ܶ����ط���ͼƬ��������Ŵ���
echo	2���Ŵ�����ɺ󣬻��Զ�����Դ��������ѡ��ͼƬ��
echo ==============================
echo.


rem ++++++++++++++++++++++++++++++++++++++
rem �������Ŀ¼
set output=%~dp0_���ػ��Ŵ�

REM �õ�ǰ�ű���ʶ��ImageMagick·��
set path=%path%;%~dp0
REM cd /d %~dp0/ImageMagick



set openWithFile=%*
if defined openWithFile ( 
	echo "�������ļ���"%openWithFile%
	set pngFile=%*
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
    echo �������˵����
    echo   ����1000^%% ��ʾ�Ŵ�10��
    echo   ����100 ��ʾ������100px
    echo.
    echo �������ȣ�Ĭ�� 1000^%%��
	set /p w=
    if defined w (
        echo ������߶� ��Ĭ�� 1000^%%��
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
echo ����Ĳ�����:
echo   ��x��     !w! x !h!   
echo   1000^%%    ��ʾͼƬ��ȷŴ�10��
echo   1000^%%    ��ʾͼƬ�߶ȷŴ�10��
echo.
echo ���������ʼת�����رմ���ֱ�ӽ�����
echo ==============================
echo.
pause


rem ���õ����ļ����͵���Ŀ¼
set fName=""
for %%a in (!pngFile!) do (
    rem ��ȡ�ļ���
    set fName=%%~nxa
    title ���ڴ���%%~nxa
    echo ���ڴ���%%~nxa
    set "inFile=%%~dpnxa"
    set "outFile=%output%\%%~nxa"
    echo ����ļ�Ϊ��!outFile!
    if not exist "%output%" ( md "%output%" )
)

rem ����ImageMagick����ת��
%~dp0convert.exe "!inFile!" -filter Point -resize !w!x!h! "!outFile!"

rem ����Դ��������ѡ���ļ�
echo "!outFile!"
explorer /select,"!outFile!"


pause
goto:eof

pause