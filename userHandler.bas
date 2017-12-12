B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=5.9
@EndOfDesignText@

Sub Class_Globals
	Private te As WPTemplateEngine
	Public actionkey As String="/user/*"
	Private db As SQL
	Private bEnd As Boolean=False
End Sub

Public Sub Initialize
	te.Initialize
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	te.bindResponse(resp)
	db=wpDBUtils.conpool.GetConnection
	Dim routes() As String= G.url2Array(req.RequestURI)
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
	Dim lst As List=wpDBUtils.ExecuteMemoryTable(db,$"select * from test limit ${start},${ps}"$,Null,0)
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
	Dim lst As List=wpDBUtils.ExecuteMemoryTable(db,$"select * from test limit ${start},${ps}"$,Null,0)
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
'分页例子
Public Sub Pagination
	Dim i As Int=0
	Dim pagesize As Int=5
	Dim ts As Int
	ts=wpDBUtils.Pagination_TotalSize(G.db,"from wp_user","",Null)
	Log("totalSize:"&ts)
	Do While bEnd=False
		getPage(i,pagesize)
		i=i+1
	Loop
	Log("全部结束")
	StartMessageLoop
End Sub
Private Sub getPage(pn As Int,pagesize As Int)
	Dim lst As List= wpDBUtils.Pagination(G.db,"select * ","from wp_user","","username asc",Null,pn,pagesize)
	Log("第"&pn&"页开始")
	For Each m As Map In lst
		Log(m)
	Next
	Log("第"&pn&"页结束")
	If lst.Size<pagesize Then
		bEnd=True
		Return
	End If
End Sub