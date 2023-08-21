package com.lingquer.db.strategy;

/**
 * 策略2 ：结构 + 数据（默认导出所有记录）
 *
 * @author fengl
 */
public class StrategyInitData  implements DatabaseStrategy{
    @Override
    public TempBean build(String table, String condition) {
        return new TempBean.TempBeanBuilder().table(table).insert(true).build();
    }
}
