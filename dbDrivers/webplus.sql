# Host: 127.0.0.1  (Version: 5.5.53)
# Date: 2017-11-27 11:05:02
# Generator: MySQL-Front 5.3  (Build 4.234)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "wp_department"
#

DROP TABLE IF EXISTS `wp_department`;
CREATE TABLE `wp_department` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` int(11) DEFAULT '0' COMMENT '上级部门id',
  `name` varchar(255) DEFAULT '' COMMENT '部门名称',
  `create` datetime DEFAULT NULL COMMENT '创建时间',
  `update` datetime DEFAULT NULL COMMENT '修改时间',
  `deleted` int(1) DEFAULT '0' COMMENT '已删除',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='部门表';

#
# Data for table "wp_department"
#

INSERT INTO `wp_department` VALUES (1,0,'销售部','2017-11-27 10:48:54',NULL,0);

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
  `deleted` int(1) DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='功能列表';

#
# Data for table "wp_function"
#

/*!40000 ALTER TABLE `wp_function` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_function` ENABLE KEYS */;

#
# Structure for table "wp_group"
#

DROP TABLE IF EXISTS `wp_group`;
CREATE TABLE `wp_group` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '' COMMENT '组名',
  `parent_id` int(11) DEFAULT '0' COMMENT '上级组id',
  `create` datetime DEFAULT NULL COMMENT '创建时间',
  `update` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` int(1) DEFAULT '0' COMMENT '已删除',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户分组表';

#
# Data for table "wp_group"
#


#
# Structure for table "wp_groupfunctions"
#

DROP TABLE IF EXISTS `wp_groupfunctions`;
CREATE TABLE `wp_groupfunctions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='分组权限表';

#
# Data for table "wp_groupfunctions"
#

/*!40000 ALTER TABLE `wp_groupfunctions` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_groupfunctions` ENABLE KEYS */;

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='用户角色表';

#
# Data for table "wp_role"
#

INSERT INTO `wp_role` VALUES (1,'管理员','2017-11-27 10:53:27',NULL,0),(2,'普通用户','2017-11-27 10:53:41',NULL,1),(3,'普通管理员','2017-11-27 10:54:28',NULL,2);

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
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='用户表';

#
# Data for table "wp_user"
#

INSERT INTO `wp_user` VALUES (1,'admin','579d9ec9d0c3d687aaa91289ac2854e4','123','管理员','','','','');

#
# Structure for table "wp_usergroup"
#

DROP TABLE IF EXISTS `wp_usergroup`;
CREATE TABLE `wp_usergroup` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户分组表';

#
# Data for table "wp_usergroup"
#


#
# Structure for table "wp_userrole"
#

DROP TABLE IF EXISTS `wp_userrole`;
CREATE TABLE `wp_userrole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rid` int(11) DEFAULT NULL COMMENT '角色id',
  `uid` int(11) DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='用户角色对应表';

#
# Data for table "wp_userrole"
#

INSERT INTO `wp_userrole` VALUES (1,1,1);
