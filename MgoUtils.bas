Type=StaticCode
Version=5
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@

Sub Process_Globals
	Public mongo As MongoClient
	Public db As MongoDatabase
	Public mongoserverIP As String="127.0.0.1"
	Public mongoport As Int=27017
	Private connected As Boolean
	Private defDbName As String="webplus"
End Sub

Public Sub init(ip As String,port As Int,dbname As String)
	If ip.Length>1 Then 	mongoserverIP=ip
	If port>1 Then mongoport=port
	If connected=False Then
		mongo.Initialize("", $"mongodb://${mongoserverIP}:${mongoport}"$)
	End If
	If dbname.Length>0 Then
		useDB(dbname)
	Else
		useDB(defDbName)
	End If
End Sub
Public Sub useDB(dbname As String)
	db=mongo.GetDatabase(dbname)
End Sub
Public Sub getTable(tabName As String) As MongoCollection
	Return db.GetCollection(tabName)
End Sub
Public Sub disconnect
	mongo.Close
	connected=False
End Sub