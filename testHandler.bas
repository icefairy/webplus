Type=Class
Version=5
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Handler class
Sub Class_Globals
	Private te As WPTemplateEngine
	Private actionKey As String="/test"
End Sub

Public Sub Initialize
	te.Initialize
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	te.bindResponse(resp)
	te.putData("headertitle","WebPlusTitle")
	te.putData("title","网页中的标题")
	te.putData("bodyhtml","<script>alert('test');</script>")
	te.putData("bodytext","普通的￥文本<br>$3331'")
	te.putData("my",CreateMap("username":"icefairy","comefrom":"China"))
	te.putData("footertext","关于我们（尾部）")
	te.putData("logined",1)
	te.putData("isadmin",0)
	te.putData("onlyif",1)
	te.putData("inta",3)
	te.putData("stra","aaa")
	te.putData("onlyiffalse",0)
	'for循环演示(只支持map类型的list)这个list也可以是直接从数据库中查询出来的结果
	Dim lst As List
	lst.Initialize
	For i=0 To 20
		Dim m As Map
		m.Initialize
		m.Put("line1","text1:"&i)
		m.Put("line2","text2:"&Rnd(0,100))
		lst.Add(m)
	Next
	te.putData("testlist",lst)
	te.renderTPL("/live/live")
End Sub
