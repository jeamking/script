@echo off
rem ���artifactory���ز���Ƿ����
rem ����˵����
rem ���ߣ���/80374310

rem �������ص�d:\labelRepo\Ŀ¼���������d�������ص�c:\labelRepo\Ŀ¼
set pan=d:
if not exist %pan% set pan=c:
set labelRepo=%pan%\labelRepo\
if not exist %labelRepo% md %labelRepo%
@echo on
set pluginHome=%labelRepo%getFilePlugin\
if exist %pluginHome%getFile.jar (
  echo isInstallPlugin:true
) else (
  echo isInstallPlugin:false
)
