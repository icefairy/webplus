Type=Class
Version=5.51
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'WebPlus Handler自动扫描器
Sub Class_Globals
	Private jr As jarUtils
	Type actionts(ak As String,sth As Boolean)
End Sub

'init and add all handler(which "handler" in names),you should defined a var named "actionkey" in handler else I will use the name before "handler"
'add:public sth as boolean=true 'when you want the handler to be SingleThreadHandler
Public Sub Initialize(ser As Server)
	jr.Initialize
	Dim clsList As List
	Dim srcpath As String=jr.SrcPath
	If srcpath.ToLowerCase.EndsWith(".jar") Then
		'find class from jar
		clsList=jr.GetAllClassesNamesFromJar(jr.pkgName,srcpath)
	Else
		clsList=jr.GetAllClassesNames
	End If
	
	If clsList.IsInitialized And clsList.Size>0 Then
		For Each k As String In clsList
			If k.IndexOf("handler")>-1 And k.IndexOf("$")=-1 Then
				Dim actKey As actionts=GetActionKeyTS(k)
				If actKey.ak.Length<1 Then
					actKey.ak="/"&k.Replace("handler","")
					G.mLog("add handler:"&actKey.ak&" with default handler:"&k)
				Else
					G.mLog("add handler:"&actKey.ak&" with handler:"&k)
				End If
				
				ser.AddHandler(actKey.ak,k,actKey.sth)
			End If
		Next
	Else
		Log("clsList not init or MergeLibraries is set to true,if you want to using this utils you should set MergeLibraries to false")
	End If
	#if release
	printStartCmdLine
	#End If
	
End Sub
Private Sub printStartCmdLine
	File.WriteString(File.DirApp,"webplus.pid",jr.GetCurrentPid)
	If File.Exists(File.DirApp,"webplusstarter.bat")=False Then
		'如果启动脚本不存在则进入生成环节
		Dim srcpath As String=jr.SrcPath.ToLowerCase
		Dim sb As StringBuilder
		Dim cplst As List
		sb.Initialize
		sb.Append($"@echo off
color 0a
title "webplus Project Starter"
cd /d %~dp0
set curpath=%cd%
echo "enter work dir:%curpath%"
echo "kill java.exe"
for /f "tokens=1" %%i in (webplus.pid) do taskkill /f /im %%i
echo "clean old logs"
del logs /s /f /q
"$)
		If srcpath.EndsWith(".jar") Then 
			sb.Append("java.exe -jar "&srcpath).Append(CRLF)
		Else
			Dim cpstr As String=GetSystemProperty("java.class.path","")
			Dim enc As String=GetSystemProperty("file.encoding","unknow")	
			sb.Append("java.exe -Dfile.encoding=").Append(enc).Append(" -cp ")
			Try
				If cpstr.Length>0 Then
					cplst=Regex.Split(";",cpstr)
					If cplst.IsInitialized=False Then cplst.Initialize
					For Each s As String In cplst
						If s.Length>0 Then
							sb.Append($""${getFilePathinLibs(s)}";"$)
						End If
					Next
					sb=sb.Remove(sb.Length-1,sb.Length)
					sb.Append(" -jar "&getJarFilenameFromOBjects).Append(CRLF)
'					sb.Append(" "&jr.pkgName&".main").Append(CRLF)
				End If
				
			Catch
				Log(LastException)
			End Try
			Try
				If File.Exists(File.DirApp,"libs")=False Then File.MakeDir(File.DirApp,"libs")
				Dim libsdir As String=File.Combine(File.DirApp,"libs")
				For Each s As String In cplst
					If File.Exists("",s) And File.IsDirectory("",s)=False And s.ToLowerCase.EndsWith(".jar") Then
						'如果文件存在且不是目录且是jar文件
						File.Copy("",s,libsdir,File.GetName(s))
					End If
				Next
			Catch
				Log("copy libs error:"&LastException)
			End Try
			
		End If
		sb.Append("echo ""webplus project run completed ok""").Append(CRLF).Append("pause")
		Dim tw As TextWriter
		tw.Initialize2(File.OpenOutput(File.DirApp,"webplusstarter.bat",False),"GBK")
		tw.WriteLine(sb.ToString)
		tw.Flush
		tw.Close
		Log("项目启动脚本:"&File.Combine(File.DirApp,"webplusstarter.bat"))
	End If
	
	
	
End Sub
Private Sub getJarFilenameFromOBjects As String
	Dim lst As List=File.ListFiles(File.DirApp)
	For Each s As String In lst
		If s.ToLowerCase.EndsWith(".jar") Then
			Return File.GetName(s)
		End If
	Next
End Sub
Private Sub getFilePathinLibs(s As String) As String
	Return File.Combine(File.Combine("%curpath%","libs"),File.GetName(s))
End Sub
Private Sub GetActionKeyTS(clsName As String) As actionts
	Dim jo As JavaObject
	Dim ret As actionts
	ret.Initialize
	Dim pkg As String=jr.pkgName&"."&clsName
	Try
		jo=jo.InitializeNewInstance(pkg,Null)
		#if release
			jo.RunMethod("_class_globals",Null) 'release mode
		#else
			jo.RunMethod("_class_globals",Array As Object(Null)) 'debug mode
		#End If
		
		ret.ak=jo.GetField("_actionkey")
	Catch
'		Log(LastException)
		ret.ak=""
	End Try
	Try
		ret.sth=jo.GetField("_sth")
	Catch
		ret.sth=False
	End Try
	Return ret
End Sub