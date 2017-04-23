Type=Class
Version=5
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'WebPlus Handler自动扫描器
Sub Class_Globals
	Private jr As jarUtils
End Sub

'init and add all handler(which "handler" in names),you should defined a var named "actionkey" in handler else I will use the name before "handler"
'you must set MergeLibraries=false in main module
Public Sub Initialize(ser As Server)
	jr.Initialize
	Dim clsList As List=jr.GetAllClassesNames
	If clsList.IsInitialized And clsList.Size>0 Then
		For Each k As String In clsList
			If k.IndexOf("handler")>-1 And k.IndexOf("$")=-1 Then
				Dim actKey As String=GetActionKey(k)
				If actKey.Length<1 Then
					actKey="/"&k.Replace("handler","")
					G.mLog("add handler:"&actKey&" with default handler:"&k)
				Else
					G.mLog("add handler:"&actKey&" with handler:"&k)
				End If
				
				ser.AddHandler(actKey,k,False)
			End If
		Next
	Else
		Log("clsList not init or MergeLibraries is set to true,if you want to using this utils you should set MergeLibraries to false")
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