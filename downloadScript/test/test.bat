@echo off
rem ��ȡĿ�����labelRepo��Ŀ¼
rem ����˵����

rem �������ص�d:\labelRepo\Ŀ¼���������d�������ص�c:\labelRepo\Ŀ¼
set pan=d:
if not exist %pan% set pan=c:
set labelRepo=%pan%\labelRepo\
if not exist %labelRepo% md %labelRepo%
@echo on
echo labelRepo:%labelRepo%