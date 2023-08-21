package com.lingquer.db.strategy;

/**
 * 策略1：仅结构
 *
 * @author fengl
 */
public class StrategyOnlyStructure implements DatabaseStrategy{
    @Override
    public TempBean build(String table, String condition) {
        return new TempBean.TempBeanBuilder().table(table).insert(false).build();
    }
}
