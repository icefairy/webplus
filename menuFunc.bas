Type=StaticCode
Version=5
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'菜单管理模块
Sub Process_Globals
	Type typMenu(deleted As Int,created As String,name As String,pid As String,id As String,updated As String,url As String,submenu As List)
	Public colMenu As MongoCollection
End Sub
'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	MgoUtils.init("",0,"")
	colMenu=MgoUtils.getTable("menu")
	If colMenu.Count=0 Then
		Dim menu As typMenu
		menu.Initialize
		menu.id=0
		menu.created=G.getdatetime
		menu.pid=0
		menu.name="根菜单"
		menu.url="/"
		colMenu.Insert(Array(typMenu2Map(menu)))
	End If
End Sub
'获取顶级菜单列表，这里返回的list中成员是map，需要转换的话自己单独调用typ2Map进行转换
Public Sub getRootMenus As List
	Return colMenu.Find(CreateMap("pid":0),Null,CreateMap("id":1))
End Sub
Public Sub getSubMenus(pid  As Int) As List
	Return colMenu.Find(CreateMap("pid":pid),Null,CreateMap("id":1))
End Sub
Public Sub getMenuTree As List
	Dim ret As List=getRootMenus
	For i=0 To ret.Size-1
		Dim mi As typMenu=ret.Get(i)
		Dim lst As List=getSubMenus(mi.id)
		If lst<>Null And lst.IsInitialized Then
		Else
			lst.Initialize
		End If
		mi.submenu=lst
		ret.Set(i,mi)
	Next
	Return ret
End Sub
Public Sub create(item As typMenu)
	item.created=G.getdatetime
	colMenu.Insert(Array(typMenu2Map(item)))
End Sub
Public Sub update(item As typMenu)
	item.updated=G.getdatetime
	colMenu.Update(CreateMap("_id":item.id),CreateMap("$set":typMenu2Map(item)))
End Sub
Public Sub replace(item As typMenu)
	update(item)
End Sub
Public Sub delete(item As typMenu)
	item.deleted=1
	item.updated=G.getdatetime
	update(item)
End Sub
Public Sub delete2(item As typMenu)
	colMenu.Delete(CreateMap("_id":item.id))
End Sub
Public Sub parseStr2typMenu(str As String) As typMenu
	Dim parser As JSONParser
	parser.Initialize(str)
	Return map2typMenu(parser.NextObject)
End Sub
Public Sub map2typMenu(m As Map) As typMenu
	Dim ret As typMenu
	ret.Initialize
	ret.deleted=m.GetDefault("deleted",0)
	ret.created=m.GetDefault("created","")
	ret.name=m.GetDefault("name","")
	ret.pid=m.GetDefault("pid","")
	ret.id=m.GetDefault("_id","")
	ret.updated=m.GetDefault("updated","")
	ret.url=m.GetDefault("url","")
	Return ret
End Sub
Public Sub typMenu2Map(typ As typMenu) As Map
	Dim ret As Map
	ret.Initialize
	ret.Put("deleted",typ.deleted)
	ret.Put("created",typ.created)
	ret.Put("name",typ.name)
	ret.Put("pid",typ.pid)
	ret.Put("_id",typ.id)
	ret.Put("updated",typ.updated)
	ret.Put("url",typ.url)
	Return ret
End Sub
