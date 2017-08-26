@echo off
rem 功能：从artifactory下载应用发布包
rem 参数说明：
rem   [参数1]：源文件url
rem   [参数2]：下载到本地的文件名
rem   [参数3]：日志文件名
rem 调用示例：./getFile_windows_artifactory.bat http://xx.xx.xx.xx:8081/artifactory/UAT_20170516_01.zip
rem             UAT_20170516_01.zip artiLog.log

rem 以下配置开发和生产环境配置不一样---
rem artifactory账号和密码
set auth=8037:@2017
rem -----------------------------------

set srcFileUrl=%1
set localFile=%2
set logName=%3

set saScriptHome=%cd%
set saMgrPluginHome=%saScriptHome%/getFilePlugin

rem 优先下载到d:\labelRepo\目录，如果存在d盘则下载到c:\labelRepo\目录
set pan=d:
if not exist %pan% set pan=c:
set labelRepo=%pan%\labelRepo\
if not exist %labelRepo% md %labelRepo%
set ymd=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%
set downloadPath=%labelRepo%%ymd%\
if not exist %downloadPath% md %downloadPath%

set pluginHome=%labelRepo%getFilePlugin\
set logPath=%downloadPath%logs\
if not exist %logPath% md %logPath%
set logFullFile=%logPath%%logName%

rem 记录开始时间
set startDate=%DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2% %TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%
call :time2second %time%
set /a startSecond=%ns%
echo params:%*>%logFullFile%
echo begin download:%startDate%>>%logFullFile%

rem 判断是否安装插件
if not exist %pluginHome%getFile.jar (
	  echo notFindGetFilePlugin %pluginHome%getFile.jar>>%logFullFile%
	  @echo on
	  echo notFindGetFilePlugin
	  exit
)

rem 插件执行下载功能
setlocal enabledelayedexpansion
for %%i in (%pluginHome%libs\*.jar) do (
	set cpOptions=!cpOptions!!pluginHome!libs\%%~nxi;
)
set cpOptions=!cpOptions!%pluginHome%getFile.jar; GetFileMain %srcFileUrl% %auth% %downloadPath% %localFile%
echo cpOptions:>>$logFullFile
java -Xms256M -Xmx1024M -cp %cpOptions%>>%logFullFile% 2>&1

rem 记录结束时间
set endDate=%DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2% %TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%
set time2=%time%
call :time2second %time2%
set /a endSecond=%ns%
set /a tdiff=%endSecond% - %startSecond%
echo end download:%endDate%>>%logFullFile%
echo expend second:%tdiff%>>%logFullFile%

rem 判断下载结果
findstr "downloadSuccess" %logFullFile%>nul
@echo on
if %errorlevel% equ 0 (
  echo downloadSuccess
) else (
  echo downloadFailed
)
goto :eof

rem 将时间转换成秒数
:time2second
set tt=%time%
set /a hh=%tt:~0,2%
set /a mm=%tt:~3,2%
set /a ss=%tt:~6,2%
set ns=(%hh%*60+%mm%)*60+%ss%

