#WebPlus B4J web开发增强框架
---
> 
本项目基于B4J v5.0开发  
常用模块的配套数据模块方便起见采用[MongoDB]<https://www.mongodb.com/download-center>（不用手工创建表啥的很好用~）  
QQ群:244038794  

欢迎提供优化建议，最好直接贡献代码 ^_^
---
### 模版引擎特性说明
* 支持include引入其他模版，方便对页面进行模块化拆分
> * 模版中使用方法:{# include "/header" #}
> * 其中模版后缀名可以省略，开头和结尾的(#号旁边)有个空格。

* 支持变量替换  
> * 使用方法见下面范例中的:title
> * 模版文件中使用:`<div id='header'><h1>{# $title #}</h1></div>`<br>
> * 最终将生成:`<div id='header'><h1>网页中的标题</h1></div>`

* 支持map类型变量替换
> * 使用方法见范例中的:my
> * 模版中使用:`<p>我是:{# my.username #}</p>  <p>我来自:{# my.comefrom #}</p>`  
> * 最终输出:`<p>我是:icefairy</p>
    <p>我来自:China</p>`

* 支持IF条件语句  
> * handler中使用方法见范例中：onlyif、onlyfalse、inta、stra、strb  
> * 模版中使用1:`<p>{# if isadmin #}是管理员{# else #}
        不是管理员
    {# endif #}
	</p>`
> * 模版中使用2:`<p>{# if onlyif #}这是单条件示范
    {# endif #}
	</p>`
> * 模版中使用3:`    {# if inta=3 #}
	如果传入的参数inta=3这里就会显示
	{# endif #}`
> * 模版中使用4:`    {# if stra="aaa" #}
    如果传入的参数stra="aaa"这里就会显示
	{# endif #}`
> * 模版中使用5:`     {# if strb="bbb" #}
	如果传入的参数strb="bbb"这里就会显示
	{# else #}
	传入的参数strb!="bbb"这里就会显示
	{# endif #}`
* 支持FOR循环
> * 注意for循环只支持在list中存放map类型
> * 使用方法见范例中:testlist
> * 模版中使用:`<p>for循环演示  
		<table border="1">  
			<tr><td>第一行</td><td>第二行</td></tr>  
		{# for item in testlist #}  
			<tr><td>本行内容为:{# item.line1 #}</td>  
			<td>本行内容为:{# item.line2 #}</td></tr>  
		{# endfor #}  
		</table>  
	</p>`
> * Handler中使用:`'for循环演示(只支持map类型的list)这个list也可以是直接从数据库中查询出来的结果  
	Dim lst As List  
	lst.Initialize  
	For i=0 To 20  
		Dim m As Map  
		m.Initialize  
		m.Put("line1","text1:"&i)  
		m.Put("line2","text2:"&Rnd(0,100))  
		lst.Add(m)  
	Next  
	te.putData("testlist",lst)` 
> * 最终输出(markdown的table 格式不会弄，见谅 ^_^):`for循环演示  
第一行    第二行  
本行内容为:text1:0	本行内容为:text2:62  
本行内容为:text1:1	本行内容为:text2:3  
本行内容为:text1:2	本行内容为:text2:58  
本行内容为:text1:3	本行内容为:text2:38  
本行内容为:text1:4	本行内容为:text2:79  
本行内容为:text1:5	本行内容为:text2:74  
本行内容为:text1:6	本行内容为:text2:18  
本行内容为:text1:7	本行内容为:text2:96  
本行内容为:text1:8	本行内容为:text2:1  
本行内容为:text1:9	本行内容为:text2:51  
本行内容为:text1:10	本行内容为:text2:72  
本行内容为:text1:11	本行内容为:text2:72  
本行内容为:text1:12	本行内容为:text2:96  
本行内容为:text1:13	本行内容为:text2:98  
本行内容为:text1:14	本行内容为:text2:8  
本行内容为:text1:15	本行内容为:text2:37  
本行内容为:text1:16	本行内容为:text2:69  
本行内容为:text1:17	本行内容为:text2:75  
本行内容为:text1:18	本行内容为:text2:83  
本行内容为:text1:19	本行内容为:text2:3  
本行内容为:text1:20	本行内容为:text2:74  
`
---
* 代码范例:
> '使用方法 handler（controller）中使用:   
Sub Class_Globals  
    Private te As WPTemplateEngine  
End Sub  
Public Sub Initialize  
    te.Initialize  
End Sub 
Sub Handle(req As ServletRequest, resp As ServletResponse)  
    te.bindResponse(resp)  
	te.putData("headertitle","WebPlusTitle")  
	te.putData("title","网页中的标题")  
	te.putData("bodyhtml","<script>al1ert('test');</script>")  
	te.putData("bodytext","普通的￥文本<br />$3331'")  
	te.putData("my",CreateMap("username":"icefairy","comefrom":"China"))  
	te.putData("footertext","关于我们（尾部）")  
	te.putData("logined",1)  
	te.putData("isadmin",0)  
	te.putData("onlyif",1)  
	te.putData("inta",3)  
	te.putData("stra","aaa")  
	te.putData("onlyiffalse",0)  
	te.renderTPL("/live/live")  
End Sub  
