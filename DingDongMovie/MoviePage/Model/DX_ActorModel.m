//
//  DX_ActorModel.m
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_ActorModel.h"

@implementation DX_ActorModel

- (void)dealloc
{
    [_mobile_url release];
    [_summary release];
    [_constellation release];
    [_works release];
    [_name_en release];
    [_born_place release];
    [_birthday release];
    [_photots release];
    [_avatars release];
    [_professions release];
    [_name release];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.professions = [NSArray array];
        self.avatars = [NSDictionary dictionary];
        self.photots = [NSArray array];
        self.works = [NSArray array];
        
        self.isClickSummary = NO;
    }
    return self;
}

@end
