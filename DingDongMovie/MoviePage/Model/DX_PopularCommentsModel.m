//
//  DX_PopularCommentsModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/12.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_PopularCommentsModel.h"

@implementation DX_PopularCommentsModel

- (void)dealloc
{
    [_rating release];
    [_content release];
    [_created_at release];
    [_author release];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.author = [NSDictionary dictionary];
        self.rating = [NSDictionary dictionary];
    }
    return self;
}

@end
