# Host: localhost  (Version: 5.5.53)
# Date: 2017-05-04 17:58:43
# Generator: MySQL-Front 5.3  (Build 4.234)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "wp_department"
#

DROP TABLE IF EXISTS `wp_department`;
CREATE TABLE `wp_department` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='部门表';

#
# Data for table "wp_department"
#


#
# Structure for table "wp_dict"
#

DROP TABLE IF EXISTS `wp_dict`;
CREATE TABLE `wp_dict` (
  `Id` varchar(255) NOT NULL DEFAULT '',
  `val` varchar(500) DEFAULT '',
  `name` varchar(255) DEFAULT '',
  `parentid` varchar(255) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `create` datetime DEFAULT NULL,
  `update` datetime DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='基础资料表';

#
# Data for table "wp_dict"
#


#
# Structure for table "wp_function"
#

DROP TABLE IF EXISTS `wp_function`;
CREATE TABLE `wp_function` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '' COMMENT '功能名称',
  `url` varchar(500) DEFAULT '' COMMENT '功能url',
  `parentid` int(11) DEFAULT '0' COMMENT '父类ID',
  `order` int(11) DEFAULT '0' COMMENT '排序',
  `create` datetime DEFAULT NULL COMMENT '创建时间',
  `update` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='功能列表';

#
# Data for table "wp_function"
#

INSERT INTO `wp_function` VALUES (1,'用户管理','',0,0,'2017-05-04 13:26:57',NULL),(2,'更新用户','/user/update',1,0,'2017-05-04 13:27:03',NULL),(3,'创建用户','/user/save',1,0,'2017-05-04 13:27:12',NULL),(4,'删除用户','/user/delete',1,0,'2017-05-04 13:27:18',NULL),(5,'用户列表','/user/list',1,0,'2017-05-04 13:29:10',NULL),(6,'查询用户','/user/find',1,0,'2017-05-04 13:29:23',NULL),(7,'分组管理',NULL,0,0,'2017-05-04 15:01:27',NULL),(8,'菜单管理','',0,0,'2017-05-04 15:02:13',NULL),(9,'创建菜单','/menu/save',8,0,'2017-05-04 15:03:38',NULL),(10,'更新菜单','/menu/update',8,0,'2017-05-04 15:03:42',NULL),(11,'菜单列表','/menu/list',8,0,'2017-05-04 15:03:47',NULL),(12,'删除菜单','/menu/delete',8,0,'2017-05-04 15:04:02',NULL),(13,'删除分组','/group/delete',7,0,'2017-05-04 15:21:37',NULL),(14,'创建分组','/group/save',7,0,'2017-05-04 15:24:03',NULL),(15,'更新分组','/group/update',7,0,'2017-05-04 15:24:40',NULL),(16,'分组列表','/group/list',7,0,'2017-05-04 15:25:02',NULL);

#
# Structure for table "wp_group"
#

DROP TABLE IF EXISTS `wp_group`;
CREATE TABLE `wp_group` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户分组表';

#
# Data for table "wp_group"
#


#
# Structure for table "wp_menu"
#

DROP TABLE IF EXISTS `wp_menu`;
CREATE TABLE `wp_menu` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `orderid` int(11) DEFAULT '0',
  `create` datetime DEFAULT NULL,
  `update` datetime DEFAULT NULL,
  `title` varchar(255) DEFAULT '',
  `functionid` int(11) DEFAULT '0',
  `parentid` int(11) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL COMMENT 'top|left',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='菜单表';

#
# Data for table "wp_menu"
#


#
# Structure for table "wp_role"
#

DROP TABLE IF EXISTS `wp_role`;
CREATE TABLE `wp_role` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `rolename` varchar(255) DEFAULT '' COMMENT '角色名称',
  `create` datetime DEFAULT NULL,
  `update` datetime DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户角色表';

#
# Data for table "wp_role"
#


#
# Structure for table "wp_user"
#

DROP TABLE IF EXISTS `wp_user`;
CREATE TABLE `wp_user` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT '',
  `password` varchar(32) DEFAULT '',
  `salt` varchar(32) DEFAULT '',
  `nickname` varchar(64) DEFAULT '',
  `qq` varchar(16) DEFAULT '',
  `email` varchar(255) DEFAULT '',
  `phone` varchar(16) DEFAULT '',
  `address` varchar(512) DEFAULT '',
  `groupid` int(11) DEFAULT NULL,
  `departmentid` int(11) DEFAULT NULL,
  `roleid` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

#
# Data for table "wp_user"
#


#
# Structure for table "wp_userrole"
#

DROP TABLE IF EXISTS `wp_userrole`;
CREATE TABLE `wp_userrole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rid` int(11) DEFAULT NULL COMMENT '角色id',
  `fid` int(11) DEFAULT NULL COMMENT '功能id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户角色对应表';

#
# Data for table "wp_userrole"
#

