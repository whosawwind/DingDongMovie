//
//  DX_NightModeSingleton.m
//  DingDongMovie
//
//  Created by dllo on 15/9/22.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_NightModeSingleton.h"

// 定义静态全局变量
static DX_NightModeSingleton *nightModeFlag = nil;

@implementation DX_NightModeSingleton

- (void)dealloc
{
    [super dealloc];
}

// 重写alloc 方法封堵创建方法(调用alloc方法时 默认会走allocWithZone这个方法 所以只需封堵allocWithZone 方法即可)
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    // 定义一个标识
    // 确保Block里的代码只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nightModeFlag = [super allocWithZone:zone];
    });
    return nightModeFlag;
}

+ (instancetype)shareNightMode
{
    return [[self alloc] init];
}

@end
