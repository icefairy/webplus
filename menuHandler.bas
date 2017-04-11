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
	MgoUtils.init("",0,"")	
	te.Initialize
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	te.bindResponse(resp)
'	req.get

End Sub