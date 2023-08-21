package com.lingquer.db.strategy;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author fengl
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TempBean {

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
    /**
     * 需要的初始数据是多少条
     */
    public int size = 10;
    /**
     * 需要初始化数据的条件 - 按照sql条件来
     */
    public String condition;

}
