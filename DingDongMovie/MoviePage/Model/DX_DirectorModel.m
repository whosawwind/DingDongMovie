//
//  DX_DirectorModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_DirectorModel.h"

@implementation DX_DirectorModel

- (void)dealloc
{
    [_mobile_url release];
    [_works release];
    [_summary release];
    [_professions release];
    [_born_place release];
    [_birthday release];
    [_name_en release];
    [_name release];
    [_avatars release];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.avatars = [NSDictionary dictionary];
        self.professions = [NSMutableArray array];
        self.works = [NSMutableArray array];
        self.isClickSummary = NO;
    }
    return self;
}

@end
