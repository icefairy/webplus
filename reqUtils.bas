Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@

Sub Process_Globals
	
End Sub
'从request中获取所有参数以及值,如果值是数组就返回数组
Public Sub getReqMap(req As ServletRequest) As Map
	Dim reqmap As Map=req.ParameterMap
	Dim retmap As Map
	retmap.Initialize
	For Each k As String In reqmap.Keys
		Dim arr() As String=reqmap.Get(k)
		If arr.Length=1 Then
			retmap.Put(k,arr(0))
		Else
			retmap.Put(k,arr)
		End If
		
	Next
	Return retmap
End Sub
'从request中获取所有参数以及值(只取以modulename开头的），如果值是数组就返回数组
Public Sub getReqMapByModulename(req As ServletRequest,modulename As String) As Map
	Dim reqmap As Map=req.ParameterMap
	Dim retmap As Map
	retmap.Initialize
	For Each k As String In reqmap.Keys
		Dim arr() As String=reqmap.Get(k)
		If k.StartsWith(modulename) Then
			k=k.Replace(modulename&".","")
			If arr.Length=1 Then
				retmap.Put(k,arr(0))
			Else
				retmap.Put(k,arr)
			End If
		End If
	Next
	Return retmap
End Sub