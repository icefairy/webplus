@echo off
color 0a
title webplus启动器
cd /d %~dp0..\
set curpath=%cd%
echo 进入工作目录:%curpath%
echo 关闭已启动的项目
@taskkill /f /im java.exe
echo 清理之前的日志文件
del logs /s /f /q
java.exe -jar e:\projects\webplus\objects\webplus.jar
echo webplus项目启动完毕
pause