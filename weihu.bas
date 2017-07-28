Type=Class
Version=5.8
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Class module
Sub Class_Globals
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	'insert test data
	
	Dim lst As List
	lst.Initialize
	For i=0 To 999
		lst.Add(CreateMap("id":i+1,"line":"line"&i,"dt":G.getdatetime))
	Next
	wpDBUtils.InsertList(G.db,"test",lst)
	Log("insert test data complete")
	StartMessageLoop
End Sub