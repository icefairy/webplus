#WebPlus B4J web开发增强框架
---
> 
本项目基于B4J v5.0开发  
常用模块的配套数据模块方便起见采用[MongoDB]<https://www.mongodb.com/download-center>（不用手工创建表啥的很好用~）  
QQ群:244038794  

欢迎提供优化建议，或贡献代码 ^_^
---
### initscanner模块  
* 作用:项目启动时候自动扫描本项目中所有的handler并添加到server中，从此你不需要每写一个handler就去main里添加一次了；  
* 用法:  
* * 在Class_Global中定义一个名为actionkey的字符串，启动器会自动读取作为url映射路径；  
* * 如果你想添加一个非线程安全的handler只需要在Class_Global中定义一个名为sth的boolean并设置为true，启动器添加映射时候自动设置为SingleThreadHandler。

### jarUtils模块
* 此模块中封装了一些反射用的方法，比如获取当前项目的包名、获取某包名下的所有类、获取某个类下的所有方法以及字段、根据字符串的类名获取类 等等，具体在请自行查看源码



   
### 模版引擎特性说明
* 支持多套模版
> * 模版中使用:{# $themedir #} 可以被自动替换成"/模板名称/",方便将css或者js以不同模版进行存放，安全起见view文件夹另外放置了一个目录，以免被直接从浏览器访问到，需要被直接访问的静态页面请放在public(由G.staticFolder设置，默认public)目录下即可;其中themedir和uploaddir为保留变量名，请不要在模版中除了要调用主题目录或上传目录之外的情况下使用；

* 支持include引入其他模版，方便对页面进行模块化拆分
> * 模版中使用方法:_# include "/header" #_
> * 其中模版后缀名可以省略，开头和结尾的(#号旁边)有个空格。

* 支持变量替换  
> * 使用方法见下面范例中的:title
> * 模版文件中使用:`<div id='header'><h1>$title$}</h1></div>`<br>
> * 最终将生成:`<div id='header'><h1>网页中的标题</h1></div>`

* 其他复杂类型的输出建议采用vuejs在前端页面进行渲染，参考test2

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
