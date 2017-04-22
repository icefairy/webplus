Type=Class
Version=5
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Class module
Sub Class_Globals
	Private jr As jarUtils
End Sub

'init and add all handler(which "handler" in names),you should defined a var named "actionkey" in handler else I will use the name before "handler"
'you must set MergeLibraries=false in main module
Public Sub Initialize(ser As Server)
	jr.Initialize
	Dim clsList As List=jr.GetAllClasses
	If clsList.IsInitialized Then
		For Each k As String In clsList
			If k.IndexOf("handler")>-1 And k.IndexOf("$")=-1 Then
				Dim actKey As String=GetActionKey(k)
				If actKey.Length<1 Then actKey="/"&k.Replace("handler","")
				G.mLog("add handler:"&actKey&" with handler:"&k)
				Log("add handler:"&actKey&" with handler:"&k)
				ser.AddHandler(actKey,k,False)
			End If
		Next
	Else
		Log("clsList not init")
	End If
End Sub
Private Sub GetActionKey(clsName As String) As String
	Dim jo As JavaObject
	Dim ret As String=""
	Dim pkg As String=jr.pkgName&"."&clsName
	Try
		jo=jo.InitializeNewInstance(pkg,Null)
		#if release
			jo.RunMethod("_class_globals",Null) 'release mode
		#else
			jo.RunMethod("_class_globals",Array As Object(Null)) 'debug mode
		#End If
		
		ret=jo.GetField("_actionkey")
	Catch
'		Log(LastException)
		ret=""
	End Try
	Return ret
End Sub