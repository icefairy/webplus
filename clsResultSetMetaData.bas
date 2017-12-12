B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=6
@EndOfDesignText@
'Class module
Sub Class_Globals
	Private jo As JavaObject
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(rs As ResultSet)
	jo=rs
	jo=jo.RunMethodJO("getMetaData",Null)
End Sub
'idx start from 1
Public Sub getColumnClassName(idx As Int) As String
	If idx>(getColumnCount-1) Then Return ""
	Return jo.RunMethod("getColumnClassName",Array(idx+1))
End Sub
'idx start from 1
Public Sub 	getColumnLabel(idx As Int) As String
	If idx>(getColumnCount-1) Then Return ""
	Return jo.RunMethod("getColumnLabel",Array(idx+1))
End Sub
'idx start from 1
Public Sub getColumnTypeName(idx As Int) As String
	If idx>(getColumnCount-1) Then Return ""
	Return jo.RunMethod("getColumnTypeName",Array(idx+1))
End Sub
Public Sub 	getColumnCount As Int
	Return jo.RunMethod("getColumnCount",Null)
End Sub