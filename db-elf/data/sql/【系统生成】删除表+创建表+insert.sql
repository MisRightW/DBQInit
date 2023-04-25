USE es-server;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `es_examination`;
CREATE TABLE `es_examination` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `title` varchar(255) NOT NULL COMMENT '考试名称',
  `content` varchar(255) NOT NULL COMMENT '考试描述',
  `open` tinyint(3) NOT NULL DEFAULT '1' COMMENT '是否公开',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '口令密码',
  `state` int(11) NOT NULL DEFAULT '1' COMMENT '课程状态',
  `rule_id` bigint(20) NOT NULL COMMENT '考试规则ID',
  `time_limit` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否限时',
  `start_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `end_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '结束时间',
  `subj_score` int(11) NOT NULL DEFAULT '0' COMMENT '主观题分数',
  `obj_score` int(11) NOT NULL DEFAULT '0' COMMENT '客观题分数',
  `total_score` int(11) NOT NULL DEFAULT '0' COMMENT '总分数',
  `total_time` int(11) NOT NULL DEFAULT '0' COMMENT '总时长（分钟）',
  `qualify_score` int(11) NOT NULL DEFAULT '0' COMMENT '及格分数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程';



DROP TABLE IF EXISTS `es_examination_person`;
CREATE TABLE `es_examination_person` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `user_name` varchar(255) NOT NULL DEFAULT '' COMMENT '用户名',
  `exam_id` bigint(20) NOT NULL COMMENT '考试ID',
  `max_score` int(11) NOT NULL DEFAULT '0' COMMENT '最高分数',
  `is_pass` tinyint(11) NOT NULL DEFAULT '0' COMMENT '是否合格',
  `exam_count` int(11) NOT NULL DEFAULT '0' COMMENT '考试次数',
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



DROP TABLE IF EXISTS `es_paper`;
CREATE TABLE `es_paper` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `exam_id` bigint(20) NOT NULL COMMENT '规则ID',
  `title` varchar(64) NOT NULL COMMENT '考试标题',
  `total_time` int(11) NOT NULL DEFAULT '0' COMMENT '考试时长',
  `user_time` int(11) NOT NULL DEFAULT '0' COMMENT '用户时长',
  `total_score` int(11) NOT NULL DEFAULT '0' COMMENT '试卷总分',
  `qualify_score` int(11) NOT NULL DEFAULT '0' COMMENT '及格分',
  `obj_score` int(11) NOT NULL DEFAULT '0' COMMENT '客观分',
  `subj_score` int(11) NOT NULL DEFAULT '0' COMMENT '主观分',
  `user_score` int(11) NOT NULL COMMENT '用户得分',
  `has_saq` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否包含简答题',
  `state` int(11) NOT NULL DEFAULT '1' COMMENT '试卷状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试卷';



DROP TABLE IF EXISTS `es_paper_question`;
CREATE TABLE `es_paper_question` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `paper_id` bigint(20) NOT NULL COMMENT '试卷ID',
  `question_id` bigint(20) NOT NULL COMMENT '题目ID',
  `question_type` int(11) NOT NULL COMMENT '题目类型',
  `answered` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否已答',
  `answer` varchar(5000) NOT NULL DEFAULT '' COMMENT '主观答案',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '问题排序',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '单题分分值',
  `actual_score` int(11) NOT NULL DEFAULT '0' COMMENT '实际得分(主观题)',
  `is_right` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否答对',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试卷考题';



DROP TABLE IF EXISTS `es_paper_question_answer`;
CREATE TABLE `es_paper_question_answer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `paper_id` bigint(20) NOT NULL COMMENT '试卷ID',
  `answer_id` bigint(20) NOT NULL COMMENT '回答项ID',
  `question_id` bigint(20) NOT NULL COMMENT '题目ID',
  `is_right` tinyint(11) NOT NULL DEFAULT '0' COMMENT '是否正确项',
  `checked` tinyint(11) NOT NULL DEFAULT '0' COMMENT '是否选中',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `type` varchar(64) NOT NULL DEFAULT '' COMMENT '选项标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试卷考题备选答案';



DROP TABLE IF EXISTS `es_paper_rule`;
CREATE TABLE `es_paper_rule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `title` varchar(255) NOT NULL COMMENT '规则名称',
  `subj_score` int(11) NOT NULL DEFAULT '0' COMMENT '主观题分数',
  `obj_score` int(11) NOT NULL DEFAULT '0' COMMENT '客观题分数',
  `total_score` int(11) NOT NULL DEFAULT '0' COMMENT '总分',
  `total_time` int(65) NOT NULL DEFAULT '0' COMMENT '时长(分钟)',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注信息',
  `code` varchar(64) NOT NULL DEFAULT '' COMMENT '规则编号',
  `state` int(11) NOT NULL DEFAULT '0' COMMENT '状态',
  `qualify_score` int(11) NOT NULL DEFAULT '0' COMMENT '合格分数线',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试卷规则';



DROP TABLE IF EXISTS `es_paper_rule_repo`;
CREATE TABLE `es_paper_rule_repo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `rule_id` bigint(20) NOT NULL COMMENT '规则ID',
  `repo_id` bigint(20) NOT NULL COMMENT '题库ID',
  `radio_count` int(11) NOT NULL DEFAULT '0' COMMENT '单选题数量',
  `radio_score` int(11) NOT NULL DEFAULT '0' COMMENT '单选题分数',
  `multi_count` int(11) NOT NULL DEFAULT '0' COMMENT '多选题数量',
  `multi_score` int(11) NOT NULL DEFAULT '0' COMMENT '多选题分数',
  `judge_count` int(11) NOT NULL DEFAULT '0' COMMENT '判断题数量',
  `judge_score` int(11) NOT NULL DEFAULT '0' COMMENT '判断题分数',
  `saq_count` int(11) NOT NULL DEFAULT '0' COMMENT '简答题数量',
  `saq_score` int(11) NOT NULL DEFAULT '0' COMMENT '简答题分数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='规则题库';



DROP TABLE IF EXISTS `es_question`;
CREATE TABLE `es_question` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `question_type` int(11) NOT NULL COMMENT '题目类型',
  `content` varchar(2000) NOT NULL COMMENT '题目内容',
  `image` varchar(500) NOT NULL DEFAULT '' COMMENT '题目图片',
  `video` varchar(500) NOT NULL DEFAULT '' COMMENT '题目视频',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '题目备注',
  `analysis` varchar(2000) NOT NULL DEFAULT '' COMMENT '整题解析',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='问题题目';



DROP TABLE IF EXISTS `es_question_answer`;
CREATE TABLE `es_question_answer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `question_id` bigint(20) NOT NULL COMMENT '问题ID',
  `is_right` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否正确',
  `content` varchar(5000) NOT NULL DEFAULT '' COMMENT '答案内容',
  `image` varchar(500) NOT NULL DEFAULT '' COMMENT '图片地址',
  `analysis` varchar(5000) NOT NULL DEFAULT '' COMMENT '答案分析',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='候选答案';



DROP TABLE IF EXISTS `es_question_repo`;
CREATE TABLE `es_question_repo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `code` varchar(255) NOT NULL DEFAULT '' COMMENT '题库编号',
  `title` varchar(255) NOT NULL COMMENT '题库名称',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '题库备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='题库';



DROP TABLE IF EXISTS `es_question_repo_ref`;
CREATE TABLE `es_question_repo_ref` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `question_id` bigint(20) NOT NULL COMMENT '试题',
  `repo_id` bigint(20) NOT NULL COMMENT '归属题库',
  `question_type` int(11) NOT NULL DEFAULT '0' COMMENT '题目类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试题题库';



DROP TABLE IF EXISTS `es_question_tag`;
CREATE TABLE `es_question_tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `tag_type` int(11) DEFAULT '0' COMMENT '标签类型',
  `tag_name` varchar(255) NOT NULL DEFAULT '' COMMENT '标签名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签';



DROP TABLE IF EXISTS `es_question_tag_ref`;
CREATE TABLE `es_question_tag_ref` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `question_id` bigint(20) NOT NULL COMMENT '问题',
  `tag_id` bigint(20) NOT NULL COMMENT '标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题目标签';



DROP TABLE IF EXISTS `es_role`;
CREATE TABLE `es_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `role_name` varchar(255) NOT NULL DEFAULT '' COMMENT '角色名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='角色';
INSERT INTO `es_role`(`id`, `gmt_create`, `gmt_modified`, `creator`, `modifier`, `deleted`, `role_name`) VALUES ('1', '2020-04-20 13:51:03.0', '2020-04-20 13:51:03.0', 'system', 'system', '0', '超级管理员');
INSERT INTO `es_role`(`id`, `gmt_create`, `gmt_modified`, `creator`, `modifier`, `deleted`, `role_name`) VALUES ('2', '2020-04-20 13:51:03.0', '2020-04-20 13:51:03.0', 'system', 'system', '0', '学员');
INSERT INTO `es_role`(`id`, `gmt_create`, `gmt_modified`, `creator`, `modifier`, `deleted`, `role_name`) VALUES ('3', '2020-04-20 13:51:03.0', '2020-04-20 13:51:03.0', 'system', 'system', '0', '老师');



DROP TABLE IF EXISTS `es_system_config`;
CREATE TABLE `es_system_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `prepare` int(11) NOT NULL COMMENT '预热时长',
  `rest_start` time NOT NULL COMMENT '休市开始时间',
  `rest_end` time NOT NULL COMMENT '休市结束时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通用配置';



DROP TABLE IF EXISTS `es_system_log`;
CREATE TABLE `es_system_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `title` varchar(255) NOT NULL COMMENT '日志名称',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `user_name` varchar(32) NOT NULL DEFAULT '' COMMENT '用户名称',
  `ip` varchar(255) NOT NULL DEFAULT '' COMMENT 'IP地址',
  `ip_region` varchar(255) NOT NULL DEFAULT '' COMMENT 'IP归属地',
  `detail` text NOT NULL COMMENT '日志明细',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统日志';



DROP TABLE IF EXISTS `es_user`;
CREATE TABLE `es_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `user_name` varchar(255) NOT NULL DEFAULT '' COMMENT '用户名',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `real_name` varchar(255) NOT NULL DEFAULT '' COMMENT '真实姓名',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(255) NOT NULL DEFAULT '' COMMENT '密码盐',
  `role_ids` varchar(500) NOT NULL DEFAULT '' COMMENT '角色列表',
  `state` int(11) NOT NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='管理用户';
INSERT INTO `es_user`(`id`, `gmt_create`, `gmt_modified`, `creator`, `modifier`, `deleted`, `user_name`, `avatar`, `real_name`, `password`, `salt`, `role_ids`, `state`) VALUES ('1', '2020-04-20 13:51:03.0', '2020-04-20 13:51:03.0', 'system', 'system', '0', 'admin', 'https://face-files.oss-cn-shenzhen.aliyuncs.com/logo.png', '超管A', '18c000b5a1d9f21afd1bc254c33de7fb', 'ibzeHD', 'sa', '0');
INSERT INTO `es_user`(`id`, `gmt_create`, `gmt_modified`, `creator`, `modifier`, `deleted`, `user_name`, `avatar`, `real_name`, `password`, `salt`, `role_ids`, `state`) VALUES ('2', '2020-04-20 13:51:03.0', '2020-04-20 13:51:03.0', 'system', 'system', '0', 'student', 'https://file.meetboxs.com/2020/04-20/1252131827962134529.jpeg', '学员A', 'c87b067e2e4f63e93d962f422a392003', 'rfeGHz', 'student', '0');



DROP TABLE IF EXISTS `es_user_course`;
CREATE TABLE `es_user_course` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `course_id` bigint(20) NOT NULL COMMENT '课程ID',
  `study_state` int(11) NOT NULL DEFAULT '0' COMMENT '学习状态',
  `exam_state` int(11) NOT NULL COMMENT '考试状态',
  `exam_result` int(11) NOT NULL COMMENT '考试结果',
  `exam_score` int(11) NOT NULL COMMENT '最高分数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `index_uq_uc` (`course_id`,`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户课程状态';



DROP TABLE IF EXISTS `es_user_role`;
CREATE TABLE `es_user_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='用户角色';
INSERT INTO `es_user_role`(`id`, `gmt_create`, `gmt_modified`, `creator`, `modifier`, `deleted`, `user_id`, `role_id`) VALUES ('1', '2020-04-20 13:51:03.0', '2020-04-20 13:51:03.0', 'system', 'system', '0', '1', '1');
INSERT INTO `es_user_role`(`id`, `gmt_create`, `gmt_modified`, `creator`, `modifier`, `deleted`, `user_id`, `role_id`) VALUES ('2', '2020-04-20 13:51:03.0', '2020-04-20 13:51:03.0', 'system', 'system', '0', '2', '2');



DROP TABLE IF EXISTS `es_user_ware`;
CREATE TABLE `es_user_ware` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `course_id` bigint(20) NOT NULL COMMENT '课程ID',
  `ware_id` bigint(20) NOT NULL COMMENT '课件ID',
  `need_min` int(11) NOT NULL DEFAULT '0' COMMENT '需要分钟',
  `learn_sec` int(11) NOT NULL DEFAULT '0' COMMENT '已读秒数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `index_wq` (`ware_id`,`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课件阅读记录';



DROP TABLE IF EXISTS `es_user_wrong_book`;
CREATE TABLE `es_user_wrong_book` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(32) DEFAULT NULL COMMENT '修改人',
  `deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `question_id` varchar(64) NOT NULL COMMENT '题目ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最近错误时间',
  `wrong_count` int(11) NOT NULL COMMENT '错误时间',
  `title` varchar(255) NOT NULL COMMENT '题目标题',
  `sort` int(11) NOT NULL COMMENT '错题序号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='错题本';



SET FOREIGN_KEY_CHECKS = 1;
