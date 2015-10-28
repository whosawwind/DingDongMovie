//
//  DX_FilmReviewModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/16.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_FilmReviewModel.h"

@implementation DX_FilmReviewModel

- (void)dealloc
{
    [_alt release];
    [_content release];
    [_summary release];
    [_author release];
    [_rating release];
    [_title release];
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
