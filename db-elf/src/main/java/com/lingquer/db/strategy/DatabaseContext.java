package com.lingquer.db.strategy;

/**
 * @author fengl
 */
public class DatabaseContext {

    /**
     * 策略接口
     */
    private DatabaseStrategy strategy;

    public DatabaseContext(DatabaseStrategy strategy) {
        this.strategy = strategy;
    }

    public TempBean executeStrategy(String table, String condition) {
        return strategy.build(table, condition);
    }

}
