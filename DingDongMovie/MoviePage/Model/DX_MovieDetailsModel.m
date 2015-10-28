//
//  DX_MovieDetailsModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/12.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_MovieDetailsModel.h"

@implementation DX_MovieDetailsModel

- (void)dealloc
{
    [_mobile_url release];
    [_popular_reviews release];
    [_popular_comments release];
    [_photos release];
    [_clips release];
    [_casts release];
    [_directors release];
    [_summary release];
    [_genres release];
    [_durations release];
    [_pubdate release];
    [_rating release];
    [_countries release];
    [_title release];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.images = [NSDictionary dictionary];
        self.countries = [NSArray array];
        self.rating = [NSDictionary dictionary];
        self.durations = [NSArray array];
        self.genres = [NSArray array];
        self.directors = [NSArray array];
        self.casts = [NSArray array];
        self.clips = [NSArray array];
        self.photos = [NSArray array];
        self.popular_comments = [NSArray array];
        self.popular_reviews = [NSArray array];
        
        // 默认没有点击summary
        self.isClickSummary = NO;
    }
    return self;
}

@end
