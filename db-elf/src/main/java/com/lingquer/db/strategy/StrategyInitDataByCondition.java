package com.lingquer.db.strategy;

/**
 * 策略3 ：结构 + 数据（通过条件限定）
 *
 * @author fengl
 */
public class StrategyInitDataByCondition implements DatabaseStrategy{
    @Override
    public TempBean build(String table, String condition) {
        return new TempBean.TempBeanBuilder().table(table).insert(true).condition(condition).build();
    }
}
