//
//  DX_SearchListModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/19.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_SearchListModel.h"

@implementation DX_SearchListModel

- (void)dealloc
{
    [_id release];
    [_title release];
    [super dealloc];
}

@end
