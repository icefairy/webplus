#WebPlus B4J web开发增强框架

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
* FOR循环暂未实现

---
本项目基于B4J v5.0开发
QQ群:244038794
欢迎提供优化建议，最好直接贡献代码^_^
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
