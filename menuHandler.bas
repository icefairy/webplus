Type=Class
Version=5
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Handler class
Sub Class_Globals
	Private te As WPTemplateEngine
	Public actionkey As String="/menu"
End Sub

Public Sub Initialize
	te.Initialize
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	te.bindResponse(resp)
'	req.get
	resp.Write("menu handler")
End Sub