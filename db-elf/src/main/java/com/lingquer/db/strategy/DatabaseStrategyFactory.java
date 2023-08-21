package com.lingquer.db.strategy;

/**
 * @author fengl
 */
public class DatabaseStrategyFactory {

    public static DatabaseStrategy createStrategy(String type) {
        if (DataType.ALL.getCode().equals(type)) {
            return new StrategyInitData();
        } else if (DataType.BY_CONDITION.getCode().equals(type)) {
            return new StrategyInitDataByCondition();
        } else {
            return new StrategyOnlyStructure();
        }
    }

}
