//
//  DX_TopMovieModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_TopMovieModel.h"

@implementation DX_TopMovieModel

- (void)dealloc
{
    [_original_title release];
    [_id release];
    [_images release];
    [_title release];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.images = [NSDictionary dictionary];
    }
    return self;
}

@end
