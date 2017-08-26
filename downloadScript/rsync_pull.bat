@echo on
set rsyncExe="D:\Program Files\cwRsync\bin\rsync"
set srcRoot=rsync://99.1.38.158:28123/rsyncRoot/
set destPath=/cygdrive/e/rsyncRoot
set allFileType=zip,tar

set logName=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%.txt
set logPath=%cd%\rsyncPullLogs\
if not exist %logPath% md %logPath%
set logFullFile=%logPath%%logName%
echo --------begin:%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2% >> %logFullFile%
for %%f in (%allFileType%) do (
	call :rsyncOneFileType %%f
)

echo --------end:%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2% >> %logFullFile%
goto :eof

rem 同步1种文件类型的文件
:rsyncOneFileType
set ft=%1
set joinStr=*/
set relPath=
setlocal enabledelayedexpansion
for /l %%a in (1,1,5) do (
		%rsyncExe% -av %srcRoot%!relPath!*.%ft% %destPath% >> %logFullFile% 2>&1
		set relPath=!relPath!%joinStr%
)
	
