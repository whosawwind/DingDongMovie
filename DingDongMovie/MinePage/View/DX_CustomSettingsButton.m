//
//  DX_CustomSettingsButton.m
//  DingDongMovie
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_CustomSettingsButton.h"

@implementation DX_CustomSettingsButton

- (void)dealloc
{
    [_settingsLabel release];
    [_settingsImageView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCustomSettingsButton];
    }
    return self;
}

- (void)createCustomSettingsButton
{
    // 创建设置图标
    self.settingsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 7, self.frame.size.height - 14, self.frame.size.height - 14)];
    self.settingsImageView.userInteractionEnabled = NO;
    [self addSubview:_settingsImageView];
    // 创建设置文字
    self.settingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.settingsImageView.frame.origin.x + self.settingsImageView.frame.size.width + 20, self.settingsImageView.frame.origin.y, 150, self.settingsImageView.frame.size.height)];
    self.settingsLabel.textColor = [UIColor blackColor];
    self.settingsLabel.userInteractionEnabled = NO;
    [self addSubview:_settingsLabel];
    
    // 释放
    [_settingsLabel release];
    [_settingsImageView release];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
