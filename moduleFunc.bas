Type=StaticCode
Version=5.51
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@

Sub Process_Globals
	
End Sub
'从form中获取module，形式类似:user.name,user.pass,user.address
Public Sub getModule(req As ServletRequest,modulename As String) As Map
	Dim reqmap As Map=req.ParameterMap
	Dim retmap As Map
	retmap.Initialize
	For Each k As String In reqmap.Keys
		If k.StartsWith(modulename&".") Then
			Dim arr() As String=reqmap.Get(k)
			retmap.Put(k.SubString(k.IndexOf(".")+1),arr(0))
		End If
	Next
	Return retmap
End Sub
Public Sub getAllModule(req As ServletRequest ) As Map
	Dim reqmap As Map=req.ParameterMap
	Dim retmap As Map
	retmap.Initialize
	For Each k As String In reqmap.Keys
		Dim arr() As String=reqmap.Get(k)
		retmap.Put(k.SubString(k.IndexOf(".")+1),arr(0))
	Next
	Return retmap
End Sub