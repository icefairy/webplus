Type=Class
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Filter class
Sub Class_Globals

End Sub

Public Sub Initialize

End Sub

'Return True to allow the request to proceed.
Public Sub Filter(req As ServletRequest, resp As ServletResponse) As Boolean
	Log("Filter:"&req.RequestURI)
	If G.addFunctionAuto Then addfun(req.RequestURI,"unknow function")
	Return True
End Sub
Sub addfun(uri As String,name As String)
	If G.funCache.ContainsKey(uri)=False Then
		G.funCache.Put(uri,name)
		Dim m As Map
		m.Initialize
		m.Put("url",uri)
		m.Put("name",name)
		m.Put("create",G.getdatetime)
		m.Put("parentid",0)
		wpDBUtils.InsertMap(g.db,"wp_function",m)
	End If
End Sub