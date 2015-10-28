//
//  DX_headerView.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_HeaderView.h"

@implementation DX_HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:_headerView];
        [_headerView release];
        self.alphaView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:_alphaView];
        [_alphaView release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
