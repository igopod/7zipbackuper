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

echo Резевное копирование каталога с последующим архивированием с помощью 7zip
echo Использование backuper.bat -backup [Источник для бэкапа] [Каталог для сохрания бэкапа] [Каталог для логов]
goto :eof


:backup
:: проверка наличия директории откуда создается резевная копия и создание в случае отсутствия
if not exist %2 (
	echo %2 не существует
	mkdir %2
	echo %2 создана
)

:: проверка наличия диркетроии хранения резевных копий и создание в случае отсутствия
if not exist %3 (
	echo %3 не существует
	mkdir %3
	echo %3 создана
)

:: проверка наличия диркетроии хранения логов и создание в случае отсутствия
if not exist %4 (
	echo %4 не существует
	mkdir %4
	echo %4 создана
)

:: оставляем 10 самых последних копий, остальные удаляем
for /f "skip=%BACKUP_CAP% usebackq delims=" %%i in (
	`dir /b /a:-d /o:-d /t:w "%BACKUP_DEST%"`
) do (
	echo [%CURRENT_DATE%%CURRENT_TIME%] Удаление бэкапа, Файл "%BACKUP_DEST%\%%i" >> %LOGS_DEST%\log_%CURRENT_DATE%.txt
	del /f /q "%BACKUP_DEST%\%%~i"	
)

:: архивирование в место хранения резервных копий дерииктории с данными с логированием
echo [%CURRENT_DATE%%CURRENT_TIME%] Начало бэкапа, Файл %BACKUP_DEST%\%CURRENT_DATE%%CURRENT_TIME%.zip >> %LOGS_DEST%\log_%CURRENT_DATE%.txt
%RUN7Z% a -tzip -mx5 %BACKUP_DEST%\%CURRENT_DATE%%CURRENT_TIME%.zip -ssw %BACKUP_FROM% >> %LOGS_DEST%\log_%CURRENT_DATE%.txt
echo [%CURRENT_DATE%%CURRENT_TIME%] Время окончания >> %LOGS_DEST%\log_%CURRENT_DATE%.txt
echo.  >> %LOGS_DEST%\log_%CURRENT_DATE%.txt
goto :eof
