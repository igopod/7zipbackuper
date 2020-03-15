@echo off
@chcp 1251

SET CURRENT_DATE=%DATE:~0,2%%DATE:~3,2%%DATE:~6,4%
SET CURRENT_TIME=T%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
::SETTINGS
SET RUN7Z="C:\Program Files\7-Zip\7z.exe"
SET BACKUP_FROM=%2
SET BACKUP_DEST=%3
SET LOGS_DEST=%4
SET BACKUP_CAP=2

if "%1"=="-backup" goto backup

echo �������� ����������� �������� � ����������� �������������� � ������� 7zip
echo ������������� backuper.bat -backup [�������� ��� ������] [������� ��� �������� ������] [������� ��� �����]
goto :eof


:backup
:: �������� ������� ���������� ������ ��������� �������� ����� � �������� � ������ ����������
if not exist %2 (
	echo %2 �� ����������
	mkdir %2
	echo %2 �������
)

:: �������� ������� ���������� �������� �������� ����� � �������� � ������ ����������
if not exist %3 (
	echo %3 �� ����������
	mkdir %3
	echo %3 �������
)

:: �������� ������� ���������� �������� ����� � �������� � ������ ����������
if not exist %4 (
	echo %4 �� ����������
	mkdir %4
	echo %4 �������
)

:: ��������� 10 ����� ��������� �����, ��������� �������
for /f "skip=%BACKUP_CAP% usebackq delims=" %%i in (
	`dir /b /a:-d /o:-d /t:w "%BACKUP_DEST%"`
) do (
	echo [%CURRENT_DATE%%CURRENT_TIME%] �������� ������, ���� "%BACKUP_DEST%\%%i" >> %LOGS_DEST%\log_%CURRENT_DATE%.txt
	del /f /q "%BACKUP_DEST%\%%~i"	
)

:: ������������� � ����� �������� ��������� ����� ����������� � ������� � ������������
echo [%CURRENT_DATE%%CURRENT_TIME%] ������ ������, ���� %BACKUP_DEST%\%CURRENT_DATE%%CURRENT_TIME%.zip >> %LOGS_DEST%\log_%CURRENT_DATE%.txt
%RUN7Z% a -tzip -mx5 %BACKUP_DEST%\%CURRENT_DATE%%CURRENT_TIME%.zip -ssw %BACKUP_FROM% >> %LOGS_DEST%\log_%CURRENT_DATE%.txt
echo [%CURRENT_DATE%%CURRENT_TIME%] ����� ��������� >> %LOGS_DEST%\log_%CURRENT_DATE%.txt
echo.  >> %LOGS_DEST%\log_%CURRENT_DATE%.txt
goto :eof