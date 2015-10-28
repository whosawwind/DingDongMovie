//
//  DX_BaseModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/9.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@implementation DX_BaseModel

- (void)dealloc
{
    [super dealloc];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

+ (instancetype)baseModelWithDictionary:(NSDictionary *)dictionary
{
    // 利用多态封装初始化方法
    id object = [[[[self class] alloc] initWithDictionary:dictionary] autorelease];
    return object;
}

+ (NSMutableArray *)baseModelArrayWithArray:(NSArray *)array
{
    // 创建可变数组保存Model, 并返回结果
    NSMutableArray *resultMutableArray = [NSMutableArray array];
    // 遍历array数组
    for (NSDictionary *dictionary in array) {
        // 创建对象
        id model = [[self class] baseModelWithDictionary:dictionary];
        // 添加至数组
        [resultMutableArray addObject:model];
    }
    return resultMutableArray;
}

// 纠错方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
