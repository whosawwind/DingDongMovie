//
//  DX_NightModeSingleton.h
//  DingDongMovie
//
//  Created by dllo on 15/9/22.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DX_NightModeSingleton : NSObject

@property (nonatomic, assign) BOOL modeTransform;  /**< 模式转换*/

/**
 *  @brief 类方法创建单例
 *
 *  @return 单例对象
 */
+ (instancetype)shareNightMode;

@end
