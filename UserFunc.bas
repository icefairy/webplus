Type=StaticCode
Version=5
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'用户管理模块
Sub Process_Globals
	Type typUser(QQ As String,gid As String,salt As String,address As String,pass As String,created As String,mobile As String,head As String,deleted As Int,phone As String,name As String,id As String,updated As String,email As String)
	Type typUserGroup(deleted As Int,created As String,name As String,id As String,updated As String)
	Public colUser,colGroup As MongoCollection
End Sub
Public Sub Initialize
	colUser=MgoUtils.getTable("user")
	colGroup=MgoUtils.getTable("group")
End Sub
Public Sub getUserList As List
	Return colUser.Find(CreateMap("deleted":0),Null,Null)
End Sub
public Sub getUserGroupList As List
	Return colGroup.Find(CreateMap("deleted":0),Null,Null)
End Sub
public Sub getUserGroupById(gid As String) As typUserGroup
	Dim ret As typUserGroup
	Dim lst As List=colGroup.Find(CreateMap("deleted":0,"_id":gid),Null,Null)
	If lst.IsInitialized And lst.Size>0 Then
		ret=lst.Get(0)
	End If
	Return ret
End Sub
public Sub getUserById(uid As String) As typUser
	Dim ret As typUser
	Dim lst As List=colUser.Find(CreateMap("deleted":0,"_id":uid),Null,Null)
	If lst.IsInitialized And lst.Size>0 Then
		ret=lst.Get(0)
	End If
	Return ret
End Sub
Public Sub create(item As typUser)
	item.created=G.getdatetime
	colUser.Insert(Array(typUser2Map(item)))
End Sub
Public Sub update(item As typUser)
	item.updated=G.getdatetime
	colUser.Update(CreateMap("_id":item.id),CreateMap("$set":typUser2Map(item)))
End Sub
Public Sub replace(item As typUser)
	update(item)
End Sub
'deleted=1
Public Sub delete(item As typUser)
	item.deleted=1
	item.updated=G.getdatetime
	update(item)
End Sub
'real delete
Public Sub delete2(item As typUser)
	colUser.Delete(CreateMap("_id":item.id))
End Sub
Public Sub checkLogin(username As String,password As String) As Boolean
	Dim u As typUser=getUserByAny("name",username)
	If u.IsInitialized=False Then Return False
	Return G.getMd5(password&u.salt).CompareTo(u.pass)
End Sub
Public Sub checkUserExistByUsername(username As String) As Boolean
	Dim u As typUser=getUserByAny("name",username)
	Return u.IsInitialized
End Sub
Public Sub checkUserExistByEmail(email As String) As Boolean
	Dim u As typUser=getUserByAny("email",email)
	Return u.IsInitialized
End Sub
Public Sub checkUserExistByMobile(mobile As String) As Boolean
	Dim u As typUser=getUserByAny("mobile",mobile)
	Return u.IsInitialized
End Sub
'如果返回的typUser没有初始化就说明不存在
Public Sub getUserByAny(key As String,val As String) As typUser
	Dim lst As List= colUser.Find(CreateMap(key:val),Null,Null)
	Dim u As typUser
	If lst.IsInitialized And lst.Size>0 Then
		u= map2typUser(lst.Get(0))
	End If
	Return u
End Sub
Public Sub isLogin(req As ServletRequest) As Boolean
	Return req.GetSession.HasAttribute("cuser")
End Sub
Public Sub setCurUser(req As ServletRequest,u As typUser)
	req.GetSession.SetAttribute("cuser",u)
End Sub
Public Sub getCurUser(req As ServletRequest) As typUser
	Return req.GetSession.GetAttribute2("cuser",Null)
End Sub
Public Sub parseStr2typUser(str As String) As typUser
	Dim parser As JSONParser
	parser.Initialize(str)
	Return map2typUser(parser.NextObject)
End Sub
Public Sub map2typUser(m As Map) As typUser
	Dim ret As typUser
	ret.Initialize
	ret.QQ=m.GetDefault("QQ","")
	ret.gid=m.GetDefault("gid","")
	ret.salt=m.GetDefault("salt","")
	ret.address=m.GetDefault("address","")
	ret.pass=m.GetDefault("pass","")
	ret.created=m.GetDefault("created","")
	ret.mobile=m.GetDefault("mobile","")
	ret.head=m.GetDefault("head","")
	ret.deleted=m.GetDefault("deleted",0)
	ret.phone=m.GetDefault("phone","")
	ret.name=m.GetDefault("name","")
	ret.id=m.GetDefault("_id","")
	ret.updated=m.GetDefault("updated","")
	ret.email=m.GetDefault("email","")
	Return ret
End Sub
Public Sub typUser2Map(typ As typUser) As Map
	Dim ret As Map
	ret.Initialize
	ret.Put("QQ",typ.QQ)
	ret.Put("gid",typ.gid)
	ret.Put("salt",typ.salt)
	ret.Put("address",typ.address)
	ret.Put("pass",typ.pass)
	ret.Put("created",typ.created)
	ret.Put("mobile",typ.mobile)
	ret.Put("head",typ.head)
	ret.Put("deleted",typ.deleted)
	ret.Put("phone",typ.phone)
	ret.Put("name",typ.name)
	ret.Put("_id",typ.id)
	ret.Put("updated",typ.updated)
	ret.Put("email",typ.email)
	Return ret
End Sub

Public Sub parseStr2typUserGroup(str As String) As typUserGroup
	Dim parser As JSONParser
	parser.Initialize(str)
	Return map2typUserGroup(parser.NextObject)
End Sub
Public Sub map2typUserGroup(m As Map) As typUserGroup
	Dim ret As typUserGroup
	ret.Initialize
	ret.deleted=m.GetDefault("deleted",0)
	ret.created=m.GetDefault("created","")
	ret.name=m.GetDefault("name","")
	ret.id=m.GetDefault("_id","")
	ret.updated=m.GetDefault("updated","")
	Return ret
End Sub
Public Sub typUserGroup2Map(typ As typUserGroup) As Map
	Dim ret As Map
	ret.Initialize
	ret.Put("deleted",typ.deleted)
	ret.Put("created",typ.created)
	ret.Put("name",typ.name)
	ret.Put("_id",typ.id)
	ret.Put("updated",typ.updated)
	Return ret
End Sub