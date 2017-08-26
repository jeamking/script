@echo off
rem 获取目标机器labelRepo根目录
rem 参数说明：

rem 优先下载到d:\labelRepo\目录，如果存在d盘则下载到c:\labelRepo\目录
set pan=d:
if not exist %pan% set pan=c:
set labelRepo=%pan%\labelRepo\
if not exist %labelRepo% md %labelRepo%
@echo on
echo labelRepo:%labelRepo%