@echo off
rem 检查artifactory下载插件是否存在
rem 参数说明：
rem 作者：金剑/80374310

rem 优先下载到d:\labelRepo\目录，如果存在d盘则下载到c:\labelRepo\目录
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
