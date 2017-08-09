Type=Class
Version=5.8
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'WPTemplateEngine Class module
Sub Class_Globals
	Public ThemeName,ViewBasePath,TPLFileExt As String
	Private bc As ByteConverter
	'一个全局的map适用于放置通用的参数集
	Public gMap As Map
	Private mapData As Map '用于存储将要应用到本页面的各种变量数据
	Private res As ServletResponse
	Private jsg As JSONGenerator2
End Sub
'Version:1.00
'LastUpdate:2017-4-5 12:25:42
'this class modify by WebUtils
'using library:ByteConverter
'模版变量使用说明(以代码设置的为主，如果代码没有设置，模版中的就不会被替换):
'代码中设置变量:putData("test","teststr123") 其中变量名不应包含"."否则会影响模版中对于map的正常解析
'TPL模版中调用变量{# $test #}将替换{# $test #}为:teststr123 提示:模版中"amap.title"表示获取名为amap的map对象中的title的值
'TPL模版中引用其他模版:{# include "/header" #} 引用的模版路径加文件名可以不用带后缀（带上也可以）
Public Sub Initialize
	bc.LittleEndian = True
	g.devMode=True
	mapData.Initialize
	ThemeName="default"
	ViewBasePath="view"
	TPLFileExt=".html"
	getTPLPath
	If File.Exists(G.staticFilesFolder,G.uploadFolder)=False Or File.IsDirectory(G.staticFilesFolder,G.uploadFolder)=False Then
		File.MakeDir(G.staticFilesFolder,G.uploadFolder)
	End If
	initgmap
	clearMapData
End Sub
Private Sub initgmap
	gMap.Initialize
	gMap.Put("headertitle","考评系统")
	gMap.Put("keywords","怡利科技 领导考评系统")
	gMap.Put("description","怡利科技 领导考评系统")
	gMap.Put("themedir","/"&ThemeName)
	gMap.Put("uploaddir","/"&G.uploadFolder)
End Sub
Private Sub copygmap
	If mapData.IsInitialized=False Then mapData.Initialize
	For Each k As String In gMap.Keys
		mapData.Put(k,gMap.GetDefault(k,""))
	Next
End Sub
#Region methods
'清理模版数据
Public Sub clearMapData
	mapData.Clear
	mapData=G.copyMap(gMap)
End Sub
'设置主题名称
Public Sub setThemeName(tn As String)
	ThemeName=tn
	gMap.Put("themedir","/"&ThemeName)
	copygmap
End Sub
'填充模版数据（填充完成后调用render进行渲染）
'保留字段:{# $themedir #}=/themename/
'保留字段:{# $uploaddir #}=/uploads/
Public Sub putData(key As String,val As Object)
	mapData.Put(key,val)
End Sub
Public Sub putDatas(m As Map)
	For Each k As String In m.Keys
		mapData.Put(k,m.GetDefault(k,""))
	Next
End Sub
'获取已经填充的数据，不存在返回空文本""
Public Sub getData(key As String) As Object
	If mapData.ContainsKey(key) Then Return mapData.Get(key) Else Return ""
End Sub
'绑定返回对象
Public Sub bindResponse(resp As ServletResponse)
	res=resp
End Sub
'直接返回网页文本(需要html编码的请自行调用EscapeHtml),调用之前确保已经绑定了response对象
Public Sub renderText(htmlsrc As String)
	res.ContentType="text/html"
	res.CharacterEncoding="UTF-8"
	res.Write(htmlsrc)
End Sub
'直接返回json对象，格式为:{code:200,data:"msg"}其中data中可能是对象、列表、值,调用之前确保已经绑定了response对象
Public Sub renderJson(success As Boolean,data As Object)
	res.ContentType="application/json"
	res.CharacterEncoding="UTF-8"
	Dim ret As Map
	ret.Initialize
	If success Then ret.Put("code",200) Else ret.Put("code",500)
	ret.Put("data",data)
	jsg.Initialize(ret)
	res.Write(jsg.ToString())
End Sub
'渲染模版并返回给客户端,确保调用之前绑定了response对象
'传入模版文件路径（不包括主题名称）
Public Sub renderTPL(TPLFilePath As String)
	Log("rending:"&TPLFilePath)
	Dim begints As Long=DateTime.Now
	Dim htmlsrc As String= getTPLContent(TPLFilePath)
	Log("rending:"&TPLFilePath&" complete within:"&(DateTime.Now-begints)&"ms")
	renderText(htmlsrc)
End Sub
'流程：1、解析include；2、解析if条件；3、解析for循环；、4.解析变量（2,3中的变量已经被处理不会反复解析）
Private Sub getTPLContent(TPLFilePath As String) As String
	'判断文件路径是否是模版后缀结束
	Dim tmp0 As String
	If TPLFilePath.EndsWith(TPLFileExt)=False Then TPLFilePath=TPLFilePath&TPLFileExt
	Dim tplpath As String=getTPLPath
	'读入第一级模版内容
	If File.Exists(tplpath,TPLFilePath) Then
		tmp0=File.ReadString(tplpath,TPLFilePath)
		tmp0=processIncludes(tmp0)
		'		tmp0=processIF(tmp0)
		'		tmp0=processFOR(tmp0)
		''		tmp0=processMapVar(tmp0)
		'		tmp0=processVar(tmp0)
		tmp0=ReplaceMap(tmp0,mapData)
	Else
		Log("Error:TPLFile:"&getTPLPath& TPLFilePath&" Not exist!")
	End If
	Return tmp0
End Sub
'解析FOR循环
Private Sub processFOR(tmpinput As String) As String
	Dim tmp0 As String=tmpinput
	Dim sb As StringBuilder
	sb.Initialize
	Dim signs(2) As String=Array As String("{# for ","{# endfor #}")
	Dim flg As String=G.getText2(tmp0,signs(0),signs(1))
	Do While flg.Length>0
		Dim match0 As String=G.getText2(tmp0,signs(0),signs(1))
		'		g.mLog(match0)
		Dim forhead As String=G.getText(match0,signs(0),"#}",True).Trim
		Dim itemname As String=forhead.SubString2(0,forhead.IndexOf(" in ")).Trim
		Dim tplcontent As String=match0.SubString2(forhead.Length+signs(0).Length+4,match0.Length-signs(1).Length)
		Dim listname As String=forhead.SubString(forhead.IndexOf("in ")+3).Trim
		If listname.Length>0 And mapData.ContainsKey(listname) Then
			Dim obj As Object=mapData.Get(listname)
			If obj Is List Then
				Dim tmplist As List=obj
				If tmplist.IsInitialized And tmplist.Size>0 Then
					For Each itm As Map In tmplist
						Dim tmpcontent As String=processVar(tplcontent)
						tmpcontent=processMapVar2(tmpcontent,itm,itemname)
						sb.Append(tmpcontent)
					Next
				Else
					G.mLog("tmplist size:0")
				End If
			End If
			tmp0=Regex.Replace(replaceRegexSpecal(match0),tmp0,sb.ToString)
		Else
			tmp0=Regex.Replace(replaceRegexSpecal(match0),tmp0,"")
		End If
		flg=G.getText2(tmp0,signs(0),signs(1))
	Loop
	Return tmp0
End Sub
'解析IF条件语句
Private Sub processIF(tmpinput As String) As String
	Dim tmp0 As String=tmpinput
	Dim signs(2) As String=Array As String("{# if ","{# endif #}","{# else #}")
	Dim flg As String=G.getText2(tmp0,signs(0),signs(1))
	Do While flg.Length>0
		Dim match0 As String=G.getText2(tmp0,signs(0),signs(1))
		'		Log(match0)
		'		tmp0=tmp0.Replace(replaceRegexSpecal(signs(0)),"").Replace(replaceRegexSpecal(signs(1)),"")
		Dim tiaojian As String=G.getText(match0,signs(0),"#}",True).Trim
		Dim ifelsestrs() As String=Regex.Split(replaceRegexSpecal(signs(2)),match0)
		Dim iftrue As String=ifelsestrs(0).SubString(ifelsestrs(0).IndexOf("#}")+2)
		Dim iffalse As String
		If ifelsestrs.Length>1 Then
			iffalse=ifelsestrs(1).SubString2(0,ifelsestrs(1).Length-11)
		Else
			iffalse=""
			iftrue=iftrue.SubString2(0,iftrue.Length-11)
		End If
		If tiaojian.IndexOf("=")>-1 Then
			'其他值判断
			tiaojian=tiaojian.Replace("==","=")'==换成=
			Dim pds() As String=Regex.Split("=",tiaojian)
			If pds(1).IndexOf(QUOTE)>-1 Then
				'文本判断
				Dim val As String=pds(1).Replace(QUOTE,"")
				If val.CompareTo(mapData.GetDefault(pds(0),""))=0 Then
					'条件成立
					tmp0=Regex.Replace(replaceRegexSpecal(match0),tmp0,replaceRegexSpecal(iftrue))
				Else
					'条件不成立
					tmp0=Regex.Replace(replaceRegexSpecal(match0),tmp0,iffalse)
				End If
			Else
				'数值判断
				Dim mathval As Int=pds(1)
				If mapData.GetDefault(pds(0),0)=mathval Then
					'条件成立
					tmp0=Regex.Replace(replaceRegexSpecal(match0),tmp0,replaceRegexSpecal(iftrue))
				Else
					'条件不成立
					tmp0=Regex.Replace(replaceRegexSpecal(match0),tmp0,iffalse)
				End If
			End If
		Else
			'逻辑值判断
			If mapData.GetDefault(tiaojian,0)=1 Then
				tmp0=Regex.Replace(replaceRegexSpecal(match0),tmp0,replaceRegexSpecal(iftrue))
			Else
				tmp0=Regex.Replace(replaceRegexSpecal(match0),tmp0,iffalse)
			End If
		End If
		flg=G.getText2(tmp0,signs(0),signs(1))
	Loop
	Return tmp0
End Sub
Private Sub processIncludes(tmp0 As String) As String
	'开始解析嵌入模版，regex:{#\s*include.*?\s*#}
	Dim regsign0 As String=$"_#\s*include.*?\s*#_"$
	Dim tplincludes As Matcher= Regex.Matcher(regsign0,tmp0)
	Do While tplincludes.Find
		Dim match0 As String=tplincludes.Match&""
		Dim matchpath As String=match0
		matchpath=G.getText(matchpath,QUOTE,QUOTE,True)'替换双引号为单引号
		Dim matchcontent As String= getTPLContent(matchpath)
		match0=replaceRegexSpecal(match0)
		tmp0=Regex.Replace(match0,tmp0,replaceRegexSpecal(matchcontent))
		'			mLog("替换引入:"&match0)
	Loop
	Return tmp0
End Sub
'解析Map变量
Private Sub processMapVar(tmp0 As String) As String
	Return processMapVar2(tmp0,mapData,"")
End Sub
'解析Map变量
Private Sub processMapVar2(tmp0 As String,map As Map,itemname As String) As String
	'开始解析变量，regex:{#\s*\$.*?\s*#}
	Dim regsign0 As String=$"{#\s*[a-zA-z]+\.+[^\s]*\s*#}"$
	regsign0=replaceRegexSpecal(regsign0)
	Dim tplvars As Matcher=Regex.Matcher(regsign0,tmp0)
	Do While tplvars.Find
		Dim match0 As String=tplvars.Match
		'		g.mLog(match0)
		Dim needhtml As Boolean=False
		Dim matchedvarname As String=match0.Replace("{","").Replace("}","").Replace("#","").Replace("$","").Trim
		needhtml=matchedvarname.StartsWith("h_")'如果变量名以h_开头则自动进行html编码后输出
		matchedvarname=matchedvarname.Replace("h_","")
		Dim varcontent As String
		If itemname.Length>0 Then
			matchedvarname=Regex.Replace(itemname&"\.",matchedvarname,"")
			If map.ContainsKey(matchedvarname) Then
				varcontent=map.GetDefault(matchedvarname,matchedvarname)
				If needhtml Then varcontent=EscapeHtml(varcontent)
			Else
				varcontent="unknown var:"&matchedvarname
			End If
		Else
			Dim matchedvarnames() As String=Regex.Split("\.",matchedvarname)
			If matchedvarnames.Length>0 Then
				If map.ContainsKey(matchedvarnames(0)) Then
					Dim m As Map=map.Get(matchedvarnames(0))
					varcontent=m.GetDefault(matchedvarnames(1),matchedvarnames(1))
				Else
					varcontent="map:"&matchedvarnames(0)&" not exist"
				End If
			Else
				If map.ContainsKey(matchedvarname) Then
					varcontent= map.GetDefault(matchedvarname,matchedvarname)
					If needhtml Then varcontent=EscapeHtml(varcontent)
				Else
					'					mLog("未知变量:"&matchedvarname)
					varcontent="unknown var:"&matchedvarname
				End If
			End If
		End If
		
		match0=replaceRegexSpecal(match0)
		tmp0=Regex.Replace(match0,tmp0,replaceRegexSpecal(varcontent))
	Loop
	Return tmp0
End Sub
'解析普通变量
Private Sub processVar(tmp0 As String) As String
	'开始解析变量，regex:{#\s*\$.*?\s*#}
	Dim regsign0 As String=$"_#\s*.*?\s*#_"$
	regsign0=replaceRegexSpecal(regsign0)
	Dim tplvars As Matcher=Regex.Matcher(regsign0,tmp0)
	Do While tplvars.Find
		Dim match0 As String=tplvars.Match
		'		g.mLog(match0)
		Dim needhtml As Boolean=False
		Dim matchedvarname As String=match0.Replace("_","").Replace("_","").Replace("#","").Trim
		needhtml=matchedvarname.StartsWith("h_")'如果变量名以h_开头则自动进行html编码后输出
		matchedvarname=matchedvarname.Replace("h_","")
		Dim varcontent As String
		Dim matchedvarnames() As String=Regex.Split(".",matchedvarname)
		If matchedvarnames.Length>0 Then
			If mapData.ContainsKey(matchedvarnames(0)) Then
				Dim m As Map=mapData.Get(matchedvarnames(0))
				varcontent=m.GetDefault(matchedvarnames(1),matchedvarnames(1))
			Else
				varcontent="map:"&matchedvarnames(0)&" not exist"
			End If
		Else
			If mapData.ContainsKey(matchedvarname) Then
				
				varcontent= mapData.GetDefault(matchedvarname,matchedvarname)
				If needhtml Then varcontent=EscapeHtml(varcontent)
				match0=replaceRegexSpecal(match0)
				tmp0=Regex.Replace(match0,tmp0,replaceRegexSpecal(varcontent))
			Else
				'					mLog("未知变量:"&matchedvarname)
				varcontent="unknown var:"&matchedvarname
				tmp0=Regex.Replace(replaceRegexSpecal(match0),tmp0,varcontent)
			End If
		End If
		tmp0=Regex.Replace(match0,tmp0,replaceRegexSpecal(varcontent))
	Loop
	Return tmp0
End Sub
'对正则表达式特殊字符进行转义
Private Sub replaceRegexSpecal(str As String) As String
	'	Return str.Replace("$","\$")
	Return str
	'	Return str.Replace("{","\{").Replace("}","\}").Replace("$","\$").Replace("<","\<").Replace(">","\>").Replace("/","\/")
End Sub
'根据主题名称获取模版目录
Private Sub getTPLPath As String
	Dim tplpath As String=File.Combine(File.DirApp,ViewBasePath)
	If ThemeName.Length>0 Then
		If File.Exists(tplpath,ThemeName)=False Or File.IsDirectory(tplpath,ThemeName)=False Then
			File.MakeDir(tplpath,ThemeName)
		End If
		tplpath=File.Combine(tplpath,ThemeName)
	End If
	Return tplpath
End Sub
Public Sub EscapeHtml(Raw As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To Raw.Length - 1
		Dim C As Char = Raw.CharAt(i)
		Select C
			Case QUOTE
				sb.Append("&quot;")
			Case "'"
				sb.Append("&#39;")
			Case "<"
				sb.Append("&lt;")
			Case ">"
				sb.Append("&gt;")
			Case "&"
				sb.Append("&amp;")
			Case " "
				sb.Append("&nbsp;")
			Case CRLF
				sb.Append("<br>")
			Case Else
				sb.Append(C)
		End Select
	Next
	Return sb.ToString
End Sub
Public Sub ReplaceMap(Base As String, Replacements As Map) As String
	Dim pattern As StringBuilder
	pattern.Initialize
	For Each k As String In Replacements.Keys
		If pattern.Length > 0 Then pattern.Append("|")
		pattern.Append("\$").Append(k).Append("\$")
	Next
	Dim m As Matcher = Regex.Matcher(pattern.ToString, Base)
	Dim result As StringBuilder
	result.Initialize
	Dim lastIndex As Int
	Do While m.Find
		result.Append(Base.SubString2(lastIndex, m.GetStart(0)))
		Dim replace As String = Replacements.Get(m.Match.SubString2(1, m.Match.Length - 1))
		If m.Match.ToLowerCase.StartsWith("$h_") Then replace = EscapeHtml(replace)
		result.Append(replace)
		lastIndex = m.GetEnd(0)
	Loop
	If lastIndex < Base.Length Then result.Append(Base.SubString(lastIndex))
	Return result.ToString
End Sub
#End Region
