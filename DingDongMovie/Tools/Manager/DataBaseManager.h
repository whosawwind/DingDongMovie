//
//  DataBaseManager.h
//  UI18_SQLite
//
//  Created by dllo on 15/8/31.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
// 导入 <sqlite3.h>
#import <sqlite3.h>

@interface DataBaseManager : NSObject

/**
 * @brief 单例创建数据库
 */
+ (id)shareDataBaseManager;

/**
 * @brief 连接数据库
 * 
 * @param dataBaseName 数据库名
 */
- (void)connectDataBase:(NSString *)dataBaseName;

/**
 * @brief 执行数据库
 *
 * @param sqlStatement SQL语句
 * @return YES 执行成功 NO 执行失败
 */
- (BOOL)executeSQLStatement:(NSString *)sqlStatement;

/**
 * @brief 关闭数据库
 */
- (void)closeDataBase;

/**
 * @brief 查询数据库
 */
- (NSArray *)execuateQuerySQL:(NSString *)sqlStatement;

@end
