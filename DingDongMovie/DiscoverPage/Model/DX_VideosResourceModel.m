//
//  DX_TrailersModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/26.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_VideosResourceModel.h"

@implementation DX_VideosResourceModel

- (void)dealloc
{
    [_resource_url release];
    [_title release];
    [_medium release];
    [super dealloc];
}

@end
