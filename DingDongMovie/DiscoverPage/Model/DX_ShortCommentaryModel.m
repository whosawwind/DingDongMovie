//
//  DX_ShortCommentaryModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_ShortCommentaryModel.h"

@implementation DX_ShortCommentaryModel

- (void)dealloc
{
    [_content release];
    [_author release];
    [_rating release];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rating = [NSDictionary dictionary];
        self.author = [NSDictionary dictionary];
    }
    return self;
}

@end
