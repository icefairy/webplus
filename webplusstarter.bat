@echo off
color 0a
title webplus������
cd /d %~dp0..\
set curpath=%cd%
echo ���빤��Ŀ¼:%curpath%
echo �ر�����������Ŀ
@taskkill /f /im java.exe
echo ����֮ǰ����־�ļ�
del logs /s /f /q
java.exe -jar e:\projects\webplus\objects\webplus.jar
echo webplus��Ŀ�������
pause