Type=Class
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Handler class
Sub Class_Globals
	Private te As WPTemplateEngine
	Public actionkey As String="/common/*"
	Private db As SQL
End Sub

Public Sub Initialize
	te.Initialize
	
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	te.bindResponse(resp)
	Dim routes() As String= G.url2Array(req.RequestURI)
	db=wpDBUtils.conpool.GetConnection
	If SubExists(Me,routes(1)) Then
		CallSub3(Me,routes(1),req,resp)
	else If SubExists(Me,"api_"&routes(1)) Then
		CallSub3(Me,"api_"&routes(1),req,resp)
	Else
		unknowaction(req,resp)
	End If
	db.Close
	Return
End Sub

'这个用来渲染自定义页面，传入参数tplname
Public Sub customTPL(req As ServletRequest,resp As ServletResponse)
	te.renderTPL(req.GetParameter("tplname"))
End Sub
Sub unknowaction(req As ServletRequest,resp As ServletResponse)
	te.renderText("unknow:"&req.RequestURI)
End Sub
