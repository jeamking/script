@echo off
rem 功能：通过ftp下载应用发布包
rem 参数说明：
rem   [参数1]：源文件
rem   [参数2]：日志文件名
rem 调用示例：./getFile_windows_ftp.bat /UAT_803_V04.00_20160302_01.zip log1.log

rem 以下配置开发和生产环境配置不一样---
set ftpIp=99.1.38.18
set ftpUser=ftpuser1
set ftpPwd=123456
rem -----------------------------------

set srcFullFile=%1
set logName=%2

rem 优先下载到d:\labelRepo\目录，如果存在d盘则下载到c:\labelRepo\目录
set pan=d:
if not exist %pan% set pan=c:
set labelRepo=%pan%\labelRepo\
if not exist %labelRepo% md %labelRepo%
set ymd=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%
set downloadPath=%labelRepo%%ymd%\
if not exist %downloadPath% md %downloadPath%

set logPath=%downloadPath%logs\
if not exist %logPath% md %logPath%
set logFullFile=%logPath%%logName%
call :getFileName %srcFullFile%
set downloadFile=%downloadPath%%srcFileName%

rem 记录开始时间
set startDate=%DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2% %TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%
call :time2second %time%
set /a startSecond=%ns%
echo params:%*>%logFullFile%
echo begin download:%startDate%>>%logFullFile%

rem 执行ftp下载
rem ftp info
echo open %ftpIp%> getFile_windows_ftp.tmp
echo User %ftpuser%>> getFile_windows_ftp.tmp
echo %ftpPwd%>> getFile_windows_ftp.tmp
echo binary>> getFile_windows_ftp.tmp
echo quote opts utf8 off>> getFile_windows_ftp.tmp
echo get %srcFullFile% %downloadFile%>> getFile_windows_ftp.tmp
echo bye>> getFile_windows_ftp.tmp
echo quit>> getFile_windows_ftp.tmp
echo exit>> getFile_windows_ftp.tmp
ftp -v -n -s:"getFile_windows_ftp.tmp">>%logFullFile%

rem 记录结束时间
set endDate=%DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2% %TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%
set time2=%time%
call :time2second %time2%
set /a endSecond=%ns%
set /a tdiff=%endSecond% - %startSecond%
echo end download:%endDate%>>%logFullFile%
echo expend second:%tdiff%>>%logFullFile%

rem 判断下载结果
findstr "Transfer complete" %logFullFile%>nul
@echo on
if %errorlevel% equ 0 (
  echo downloadSuccess	
) else (
  echo downloadFailed
)
goto :eof

:getFileName
set srcFileName=%~nx1

rem 将时间转换成秒数
:time2second
set tt=%time%
set /a hh=%tt:~0,2%
set /a mm=%tt:~3,2%
set /a ss=%tt:~6,2%
set ns=(%hh%*60+%mm%)*60+%ss%