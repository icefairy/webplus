﻿B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=5.9
@EndOfDesignText@
'Class module
Sub Class_Globals
	Private tbName As String="wp_menu"
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub
Public Sub create(m As Map) As Boolean
	m=G.copyMap(m)
	m.Put("create",G.getdatetime)
	Return wpDBUtils.InsertMap(G.db,tbName,m).success
End Sub
Public Sub update(id As Int,m As Map)
	m=G.copyMap(m)
	m.Remove("id")
	m.Put("update",G.getdatetime)
	wpDBUtils.UpdateRecord2(G.db,tbName,m,CreateMap("id":id))
End Sub
Public Sub delete(id As Int)
	wpDBUtils.DeleteRecord(G.db,tbName,CreateMap("id":id))
End Sub
Public Sub find(id As Int) As Map
	Return wpDBUtils.ExecuteMap(G.db,"select * from "&wpDBUtils.EscapeField(tbName)&" where id=?",Array As String(id))
End Sub
Public Sub list(kv As Map) As List
	Return 	wpDBUtils.ExecuteMemoryTable2(G.db,tbName,"*",kv,0)
End Sub