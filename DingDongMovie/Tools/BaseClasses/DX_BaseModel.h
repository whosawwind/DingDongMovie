//
//  DX_BaseModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/9.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DX_BaseModel : NSObject

/**
 *  @brief 实例方法KVC
 *
 *  @param dictionary 传入的字典
 *
 *  @return 返回Model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  @brief 类方法KVC
 *
 *  @param dictionary 传入的字典
 *
 *  @return 返回Model
 */
+ (instancetype)baseModelWithDictionary:(NSDictionary *)dictionary;

/**
 *  @brief 数组套字典转化为数组套Model
 *
 *  @param array 传入的数组(套字典)
 *
 *  @return 返回的Model
 */
+ (NSMutableArray *)baseModelArrayWithArray:(NSArray *)array;

@end
