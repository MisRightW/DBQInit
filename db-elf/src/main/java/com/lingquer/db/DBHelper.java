package com.lingquer.db;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.io.file.FileWriter;
import cn.hutool.core.lang.TypeReference;
import cn.hutool.core.lang.UUID;
import cn.hutool.core.map.MapUtil;
import cn.hutool.core.text.StrBuilder;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.db.Db;
import cn.hutool.db.DbUtil;
import cn.hutool.db.Entity;
import cn.hutool.db.ds.DSFactory;
import cn.hutool.json.JSONUtil;
import com.lingquer.db.strategy.*;
import lombok.*;

import java.io.File;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author fengl
 */
public class DBHelper {

    //    private static final String FILE_NAME = "D:\\programs\\DBQInit\\db-elf\\data\\sql\\【系统生成】删除表+创建表+insert.sql";
    private static final String FILE_NAME = "service_" + UUID.randomUUID() + ".sql";


    /**
     * 默认的生成策略
     */
    private static Map<String, List<String>> GENERATION_STRATEGY = new HashMap<String, List<String>>() {{
        put(DataType.ALL.getCode(), Arrays.asList("flyway_exception_log", "flyway_schema_history"));
        put(DataType.BY_CONDITION.getCode(), Arrays.asList("kyubi_config_item:config_group='pageConfig'", "kyubi_user_info:phone='13634184519'"));
    }};

    /**
     * 需要生成的表
     */
    private static List<TempBean> CONFIG_LIST = new ArrayList<>();

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
     * 查询所有表结构的方法  -  建议把dbSetting扩展成页面可视化配置
     * @param dbSetting
     * @return
     * @throws SQLException
     */
    public static List<Entity> queryAllTables(String dbSetting) throws SQLException {
        Db db = DbUtil.use(DSFactory.get(dbSetting));

        // db查询列出所有的表
        try {
            List<Entity> tables = db.query("SHOW TABLES;");
            return tables;
        } catch (SQLException e) {
            // 抛个业务异常 - 数据库查询失败，请确认链接情况
            throw new SQLException(e);
        }
    }

    /**
     * 提交在自定义配置的策略方法
     * @param strategy
     * @return
     */
    public static boolean submit(String strategy) {
        Map<String, List<String>> o = JSONUtil.toBean(strategy, new TypeReference<Map<String, List<String>>>() {
        }.getType(), true);
        // 构建好集合
        o.forEach((k, v) -> {
            if (DataType.ALL.getCode().equals(k)) {
                final List<String> list = GENERATION_STRATEGY.get(k);
                list.addAll(v);
                GENERATION_STRATEGY.put(DataType.ALL.getCode(), list);
            } else if (DataType.BY_CONDITION.getCode().equals(k)) {
                final List<String> list = GENERATION_STRATEGY.get(k);
                list.addAll(v);
                GENERATION_STRATEGY.put(DataType.BY_CONDITION.getCode(), list);
            } else {
                final List<String> list = GENERATION_STRATEGY.get(k);
                list.addAll(v);
                GENERATION_STRATEGY.put(DataType.ONLY_STRUCTURE.getCode(), list);
            }
        });

        // 如果需要 可以 加个线上redis缓存
        return true;
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
        final List<String> all_tables = GENERATION_STRATEGY.get(DataType.ALL.getCode());
        final List<String> by_tables = GENERATION_STRATEGY.get(DataType.BY_CONDITION.getCode());
        final List<String> only_tables = GENERATION_STRATEGY.get(DataType.ONLY_STRUCTURE.getCode());

        // 构建CONFIG_LIST
        all_tables.stream().forEach(t -> buildData(DataType.ALL.getCode(), t, ""));
        by_tables.stream().forEach(t -> {
            String table = t.split(":")[0];
            String condition = t.split(":")[1];
            buildData(DataType.BY_CONDITION.getCode(), table, condition);
        });
        only_tables.stream().forEach(t -> buildData(DataType.ONLY_STRUCTURE.getCode(), t, ""));
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
                List<Entity> dataEntityList = null;
                if (StrUtil.isNotEmpty(tempBean.getCondition())) {
                    // 要限制一下 condition 必须为正确的condition
                    dataEntityList = db.query("SELECT * FROM " + table + "WHERE " + tempBean.getCondition());
                } else {
                    dataEntityList = db.query("SELECT * FROM " + table);
                }
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

    private static void buildData(String type, String table, String condition) {
        DatabaseStrategy strategy = DatabaseStrategyFactory.createStrategy(type);
        DatabaseContext context = new DatabaseContext(strategy);
        TempBean tb = context.executeStrategy(table, condition);
        CONFIG_LIST.add(tb);
    }

}
