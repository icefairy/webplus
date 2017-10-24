Type=Class
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Class module
Sub Class_Globals
'	Private db As SQL
	Private tmr As Timer
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
'	db=wpDBUtils.conpool.GetConnection
	If G.baseCache.IsInitialized=False Then G.baseCache.Initialize
	If G.funCache.IsInitialized=False Then G.funCache.Initialize
	tmr.Initialize("tmr",G.reloadbasemaptime*1000)
	tmr.Enabled=True
	tmr_Tick
End Sub
Sub tmr_Tick
	Dim m As Map=wpDBUtils.ExecuteBaseMap(g.db,"select id,val from wp_dict",Null)
	For Each k As String In m.Keys
		G.baseCache.Put(k,m.GetDefault(k,k))
	Next
	Dim lst As List=wpDBUtils.ExecuteMemoryTable(g.db,"select * from wp_function",Null,0)
	For i=0 To lst.Size-1
		m=lst.Get(i)
		G.funCache.Put(m.GetDefault("url",""),m)
	Next
	Log("load basemap once")
End Sub