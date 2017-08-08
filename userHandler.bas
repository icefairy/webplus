Type=Class
Version=5.8
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@

Sub Class_Globals
	Private te As WPTemplateEngine
	Public actionkey As String="/user/*"
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
'这里演示分页数据获取
Sub test(req As ServletRequest,resp As ServletResponse)
	Dim m As Map=reqUtils.getReqMap(req)
	Dim pn As Int=m.GetDefault("pn",1)
	Dim ps As Int=m.GetDefault("ps",10)
	Dim start As Int=(pn-1)*ps
	If start<0 Then start=0
	Dim lst As List=wpDBUtils.ExecuteMemoryTable(G.db,$"select * from test limit ${start},${ps}"$,Null,0)
	te.putData("lst",lst)
	te.putData("title","tt")
'	te.putData("headertitle","tt")
	te.renderTPL("live/test")
End Sub
'这个使用laytpl进行前端渲染
Sub test2(req As ServletRequest,resp As ServletResponse)
	Dim m As Map=reqUtils.getReqMap(req)
	Dim pn As Int=m.GetDefault("pn",1)
	Dim ps As Int=m.GetDefault("ps",10)
	Dim start As Int=(pn-1)*ps
	If start<0 Then start=0
	Dim lst As List=wpDBUtils.ExecuteMemoryTable(G.db,$"select * from test limit ${start},${ps}"$,Null,0)
	te.putData("lst",lst)
	te.putData("title","tt")
	Dim r As Map
	r.Initialize
	r.Put("lst",lst)
	Dim jsg As JSONGenerator2
	jsg.Initialize(r)
	te.putData("jss",jsg.ToString)
	Log(jsg.ToString)
	te.renderTPL("live/page2")
End Sub