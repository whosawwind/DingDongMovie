
//
//  DX_ActorsModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/12.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_ActorsModel.h"

@implementation DX_ActorsModel

- (void)dealloc
{
    [_id release];
    [_name_en release];
    [_name release];
    [_avatars release];
    [super dealloc];
}

- (instancetype)init
{
    self = [self init];
    if (self) {
        self.avatars = [NSDictionary dictionary];
    }
    return self;
}

@end
