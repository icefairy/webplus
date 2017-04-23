@echo off
color 0a
title "webplus Project Starter"
cd /d %~dp0
set curpath=%cd%
echo "enter work dir:%curpath%"
echo "kill java.exe"
@taskkill /f /im java.exe
@taskkill /f /im javaw.exe
echo "clean old logs"
del logs /s /f /q
java.exe -Dfile.encoding=UTF-8 -cp "%curpath%\libs\jcore.jar";"%curpath%\libs\jserver.jar";"%curpath%\libs\json.jar";"%curpath%\libs\jstringutils.jar";"%curpath%\libs\javaobject.jar";"%curpath%\libs\jsql.jar";"%curpath%\libs\byteconverter.jar";"%curpath%\libs\encryption.jar";"%curpath%\libs\jetty_b4j.jar";"%curpath%\libs\servlet-api-3.1.jar";"%curpath%\libs\c3p0-0.9.5.2.jar";"%curpath%\libs\c3p0-oracle-thin-extras-0.9.5.2.jar";"%curpath%\libs\mchange-commons-java-0.2.11.jar";"%curpath%\libs\mysql-connector-java-5.1.41-bin.jar";"%curpath%\libs\classes";"%curpath%\libs\.." -jar WebPlus.jar
echo "webplus project start ok"
pause
