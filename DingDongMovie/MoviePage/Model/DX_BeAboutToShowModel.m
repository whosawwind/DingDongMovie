//
//  DX_BeAboutToShowModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BeAboutToShowModel.h"

@implementation DX_BeAboutToShowModel

- (void)dealloc
{
    [_id release];
    [_wish release];
    [_pubdate release];
    [_title release];
    [_large release];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wishButtonClickFlag = NO;
    }
    return self;
}

@end
