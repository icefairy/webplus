Type=Class
Version=5
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Handler class
Sub Class_Globals
	Private te As WPTemplateEngine
End Sub

Public Sub Initialize
	UserFunc.Initialize
	te.Initialize
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	te.bindResponse(resp)
	Dim reqmap As Map=moduleFunc.getAllModule(req)
	Log(reqmap.GetDefault(G.action,""))
	Select req.GetParameter(g.action)
		Case "checkuser"
			resp.Write(G.Json(True,	UserFunc.getUserByAny("name",reqmap.GetDefault("username",""))))
		Case Else
			resp.Write(G.Json(True,UserFunc.getUserList))
	End Select
	
End Sub