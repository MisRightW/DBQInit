package com.lingquer.db.strategy;


/**
 * @author fengl
 */

public enum DataType {

    ALL("all", "全部数据"), BY_CONDITION("by_condition", "根据条件筛选数据"), ONLY_STRUCTURE("only_structure", "仅结构");

    private final String code;

    private final String desc;

    DataType(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }
}
