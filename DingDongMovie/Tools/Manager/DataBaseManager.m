//
//  DataBaseManager.m
//  UI18_SQLite
//
//  Created by dllo on 15/8/31.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DataBaseManager.h"

@interface DataBaseManager ()

// 根据数据库名查找数据库路径
- (NSString *)searchDataBaseWithName:(NSString *)dataBaseName;

@end

@implementation DataBaseManager

// 全局静态的DataBase指针变量用来确保数据库的唯一性
static sqlite3 *dataBase = NULL;

- (NSString *)searchDataBaseWithName:(NSString *)dataBaseName
{
    // 获取Documents路径
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 返回数据库路径
    return [documents stringByAppendingPathComponent:dataBaseName];
}

// 单例创建数据库
+ (id)shareDataBaseManager
{
    static DataBaseManager *dataBaseManager = nil;
    if (!dataBaseManager) {
        dataBaseManager = [[DataBaseManager alloc] init];
    }
    return dataBaseManager;
}

// 连接数据库
- (void)connectDataBase:(NSString *)dataBaseName
{
    // 获得沙盒下数据库路径
    NSString *dataBasePaths = [self searchDataBaseWithName:dataBaseName];
    NSLog(@"%@", dataBasePaths);
    /**
     * 打开数据库
     *
     * 参数1: 打开数据库路径
     * 参数2: 数据库的指针对象
     */
    sqlite3_open(dataBasePaths.UTF8String, &dataBase);
}

// 执行SQL语句
- (BOOL)executeSQLStatement:(NSString *)sqlStatement
{
    /**
     * 参数1: 执行SQL语句的数据库
     * 参数2: SQL语句
     */
    int result = sqlite3_exec(dataBase, sqlStatement.UTF8String, NULL, NULL, NULL);
    // 判断SQl语句是否执行成功, 成功YES, 失败NO
    if (result == SQLITE_OK) {
        NSLog(@"SQL语句执行成功");
        return YES;
    }
    return NO;
}

// 执行查询语句
- (NSArray *)execuateQuerySQL:(NSString *)sqlStatement
{
    // 声明数据集指针(数据库的替身,避免对数据库进行操作)
    sqlite3_stmt *statment = NULL;
    // 验证SQL语句并绑定给数据集(根据数据库语句将对sqlite操作赋给替身)
    sqlite3_prepare(dataBase, sqlStatement.UTF8String, -1, &statment, NULL);
    // 创建一个数组来保存返回的记录
    NSMutableArray *array = [NSMutableArray array];
    while (sqlite3_step(statment) == SQLITE_ROW) {
        //通过step函数执行操作，如果返回结果为SQLITE_ROW表示还有下一行记录, 当前的到的记录就会被statment保存
        /*
         #define SQLITE_INTEGER  1
         #define SQLITE_FLOAT    2
         #define SQLITE_BLOB     4
         #define SQLITE_NULL     5
         #ifdef SQLITE_TEXT
         # undef SQLITE_TEXT
         #else
         # define SQLITE_TEXT     3
         #endif
         #define SQLITE3_TEXT     3
         */
        // 获取字段的数量或者列数
        int count = sqlite3_column_count(statment);
        // 用字典来封装每一条记录的各个字段以及其值
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (int i = 0; i < count; i++) {
            // 通过for循环来循环列号
            // 获取当前列的类型，通过swicth来确定获取对应字段数据的函数
            int type = sqlite3_column_type(statment, i);
            switch (type) {
                case SQLITE_INTEGER:
                    // 获取当前字段对应的值以及字段名，用字段名做键，将字段以及其值保存在字典中
                {
                    int intValue = sqlite3_column_int(statment, i);
                    const char *name = sqlite3_column_name(statment, i);
                    [dic setObject:@(intValue) forKey:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]];
                    break;
                }
                case SQLITE_TEXT:
                {
                    const unsigned char *textValue = sqlite3_column_text(statment, i);
                    const char *name = sqlite3_column_name(statment, i);
                    [dic setObject:[NSString stringWithCString:(const char *)textValue
                                                      encoding:NSUTF8StringEncoding]
                            forKey:[NSString stringWithCString:name
                                                      encoding:NSUTF8StringEncoding]];
                    break;
                }
                case SQLITE_FLOAT:
                {
                    double floatValue = sqlite3_column_double(statment, i);
                    const char *name = sqlite3_column_name(statment, i);
                    [dic setObject:@(floatValue) forKey:[NSString stringWithCString:name
                                                                           encoding:NSUTF8StringEncoding]];
                    break;
                }
                case SQLITE_BLOB:
                {
                    const void *blobValue = sqlite3_column_blob(statment, i);
                    const char *name = sqlite3_column_name(statment, i);
                    NSData *data = [NSData dataWithBytes:blobValue
                                                  length:sqlite3_column_bytes(statment, i)];
                    [dic setObject:data forKey:[NSString stringWithCString:name
                                                                  encoding:NSUTF8StringEncoding]];
                    break;
                }
                default:
                    break;
            }
        }
        // for循环结束，表示一条记录获取完成，一条记录影射一个字典，将字典保存在数组中
        [array addObject:dic];
    }
    // 通过数据库的操作函数将statment指针占用的资源释放掉
    sqlite3_finalize(statment);
    return array;
}

// 关闭数据库
- (void)closeDataBase
{
    if (dataBase) {
        sqlite3_close(dataBase);
        dataBase = NULL;
        NSLog(@"数据库关闭");
    }
}

@end
