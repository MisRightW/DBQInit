package com.lingquer.db;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.io.file.FileWriter;
import cn.hutool.core.text.StrBuilder;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.db.Db;
import cn.hutool.db.DbUtil;
import cn.hutool.db.Entity;
import cn.hutool.db.ds.DSFactory;
import lombok.Data;
import lombok.SneakyThrows;
import lombok.experimental.Accessors;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class DBHelper {

    private static final String FILE_NAME = "D:\\programs\\DBQInit\\db-elf\\data\\sql\\【系统生成】删除表+创建表+insert.sql";

    /**
     * 需要生成的表
     */
    private static final List<TempBean> CONFIG_LIST = new ArrayList<TempBean>();

    /**
     * 不需要生成的字段：如虚拟列
     */
    private static final List<String> filedIgnoreList = CollectionUtil.newArrayList(
            "",
            "",
            ""
    );

    public static void main(String[] args) {
        DBHelper.start("test-db-dev", "es-server");
    }

    /**
     * 生成 sql
     *
     * @param dbSetting 配置名 如配置：[test-db-dev]，这里传 test-db-dev
     * @param dbName    数据库名
     */
    @SneakyThrows
    public static void start(String dbSetting, String dbName) {
        Db db = DbUtil.use(DSFactory.get(dbSetting));

        // db查询列出所有的表
        List<Entity> tables = db.query("SHOW TABLES;");
        tables.stream().map(t -> {
            return t.get("tables_in_" + dbName).toString();
        }).collect(Collectors.toList()).forEach(t -> {
            CONFIG_LIST.add(new TempBean().setTable(t));
        });
        // 绑定自定义配置

        FileWriter sqlFileWriter = FileWriter.create(new File(FILE_NAME));
        sqlFileWriter.write("");
        sqlFileWriter.append("USE " + dbName + ";\n");
        sqlFileWriter.append("SET NAMES utf8mb4;\n");
        sqlFileWriter.append("SET FOREIGN_KEY_CHECKS = 0;\n");
        for (TempBean tempBean : CONFIG_LIST) {
            String table = tempBean.table;
            sqlFileWriter.append("\n\n\n");
            if (tempBean.create) {
                // DROP TABLE
                sqlFileWriter.append("DROP TABLE IF EXISTS `" + table + "`;\n");
                // CREATE TABLE
                Entity createTableEntity = db.queryOne("SHOW CREATE TABLE " + table);
                sqlFileWriter.append((String) createTableEntity.get("Create Table"));
                sqlFileWriter.append(";\n");
            }
            // 看配置，是否需要insert语句
            if (tempBean.insert) {
                // INSERT INTO
                List<Entity> dataEntityList = db.query("SELECT * FROM " + table);
                for (Entity dataEntity : dataEntityList) {
                    StrBuilder field = StrBuilder.create();
                    StrBuilder data = StrBuilder.create();

                    dataEntity.forEach((key, valueObj) -> {
                        String valueStr = StrUtil.toStringOrNull(valueObj);
                        // 看配置，某些列不需要
                        if (filedIgnoreList.contains(key)) {
                            return;
                        }
                        field.append("`").append(key).append("`").append(", ");
                        if (ObjectUtil.isNotNull(valueStr)) {
                            // 值包含 ' 转义处理
                            valueStr = StrUtil.replace(valueStr, "'", "\\'");
                            // boolean 值处理
                            if (StrUtil.equals("true", valueStr)) {
                                data.append("b'1'");
                            } else if (StrUtil.equals("false", valueStr)) {
                                data.append("b'0'");
                            } else {
                                data.append("'").append(valueStr).append("'");
                            }
                        } else {
                            data.append("NULL");
                        }
                        data.append(", ");
                    });

                    sqlFileWriter.append("INSERT INTO `" + table + "`(");
                    String fieldStr = field.subString(0, field.length() - 2);
                    sqlFileWriter.append(fieldStr);
                    sqlFileWriter.append(") VALUES (");
                    String dataStr = data.subString(0, data.length() - 2);
                    sqlFileWriter.append(dataStr);
                    sqlFileWriter.append(");\n");
                }
            }
        }
        sqlFileWriter.append("\n\n\n");
        sqlFileWriter.append("SET FOREIGN_KEY_CHECKS = 1;\n");
    }

    @Data
    @Accessors(chain = true)
    static class TempBean {
        /**
         * 表名
         */
        public String table;
        /**
         * 是否需要 create 建表语句，默认需要
         */
        public Boolean create = true;
        /**
         * 是否需要 insert 语句，默认需要
         */
        public Boolean insert = true;
    }

}
