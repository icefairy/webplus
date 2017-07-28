Type=Class
Version=5.8
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@

Sub Class_Globals
	Private te As WPTemplateEngine
	Public actionkey As String="/menu/*"
End Sub

Public Sub Initialize
	te.Initialize
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	te.bindResponse(resp)
	Dim routes() As String= G.url2Array(req.RequestURI)
	If SubExists(Me,routes(1)) Then
		CallSub3(Me,routes(1),req,resp)
	else If SubExists(Me,"api_"&routes(1)) Then
		CallSub3(Me,"api_"&routes(1),req,resp)
	Else
		unknowaction(req,resp)
	End If
	Return
End Sub
Sub add(req As ServletRequest,resp As ServletResponse)
	te.renderText("action add:"&req.RequestURI)
End Sub
Sub unknowaction(req As ServletRequest,resp As ServletResponse)
	te.renderText("unknow:"&req.RequestURI)
End Sub