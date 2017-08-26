@echo off
rem ���ܣ���artifactory����Ӧ�÷�����
rem ����˵����
rem   [����1]��Դ�ļ�url
rem   [����2]�����ص����ص��ļ���
rem   [����3]����־�ļ���
rem ����ʾ����./getFile_windows_artifactory.bat http://xx.xx.xx.xx:8081/artifactory/UAT_20170516_01.zip
rem             UAT_20170516_01.zip artiLog.log

rem �������ÿ����������������ò�һ��---
rem artifactory�˺ź�����
set auth=8037:@2017
rem -----------------------------------

set srcFileUrl=%1
set localFile=%2
set logName=%3

set saScriptHome=%cd%
set saMgrPluginHome=%saScriptHome%/getFilePlugin

rem �������ص�d:\labelRepo\Ŀ¼���������d�������ص�c:\labelRepo\Ŀ¼
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

rem ��¼��ʼʱ��
set startDate=%DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2% %TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%
call :time2second %time%
set /a startSecond=%ns%
echo params:%*>%logFullFile%
echo begin download:%startDate%>>%logFullFile%

rem �ж��Ƿ�װ���
if not exist %pluginHome%getFile.jar (
	  echo notFindGetFilePlugin %pluginHome%getFile.jar>>%logFullFile%
	  @echo on
	  echo notFindGetFilePlugin
	  exit
)

rem ���ִ�����ع���
setlocal enabledelayedexpansion
for %%i in (%pluginHome%libs\*.jar) do (
	set cpOptions=!cpOptions!!pluginHome!libs\%%~nxi;
)
set cpOptions=!cpOptions!%pluginHome%getFile.jar; GetFileMain %srcFileUrl% %auth% %downloadPath% %localFile%
echo cpOptions:>>$logFullFile
java -Xms256M -Xmx1024M -cp %cpOptions%>>%logFullFile% 2>&1

rem ��¼����ʱ��
set endDate=%DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2% %TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%
set time2=%time%
call :time2second %time2%
set /a endSecond=%ns%
set /a tdiff=%endSecond% - %startSecond%
echo end download:%endDate%>>%logFullFile%
echo expend second:%tdiff%>>%logFullFile%

rem �ж����ؽ��
findstr "downloadSuccess" %logFullFile%>nul
@echo on
if %errorlevel% equ 0 (
  echo downloadSuccess
) else (
  echo downloadFailed
)
goto :eof

rem ��ʱ��ת��������
:time2second
set tt=%time%
set /a hh=%tt:~0,2%
set /a mm=%tt:~3,2%
set /a ss=%tt:~6,2%
set ns=(%hh%*60+%mm%)*60+%ss%

