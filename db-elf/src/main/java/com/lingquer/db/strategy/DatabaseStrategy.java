package com.lingquer.db.strategy;

import com.lingquer.db.DBHelper;

public interface DatabaseStrategy {

    TempBean build(String table, String condition);

}
