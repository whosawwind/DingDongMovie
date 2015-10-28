//
//  DX_HotShowingModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/10.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_HotShowingModel.h"

@implementation DX_HotShowingModel

- (void)dealloc
{
    [_id release];
    [_images release];
    [_title release];
    [_rating release];
    [_stars release];
    [super dealloc];
}

@end
