//
//  DX_ShortCommentaryView.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_ShortCommentaryView.h"

@implementation DX_ShortCommentaryView

- (void)dealloc
{
    [_starsLabel release];
    [_contentLabel release];
    [_usernameLabel release];
    [_usernameImageView release];
    [_filmBackgroundView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createShortCommentaryView];
    }
    return self;
}

// 创建子视图
- (void)createShortCommentaryView
{
    // 背景视图
    self.filmBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.filmBackgroundView.backgroundColor = [UIColor colorWithWhite:0.925 alpha:1.000];
    self.filmBackgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.filmBackgroundView.layer.shadowOffset = CGSizeMake(1, 3);
    self.filmBackgroundView.layer.shadowOpacity = 0.5;
    self.filmBackgroundView.layer.shadowRadius = 5;
    [self addSubview:_filmBackgroundView];
    
    // 用户头像
    self.usernameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40 * OffHeight, 40 * OffHeight)];
    self.usernameImageView.layer.cornerRadius = (40 * OffHeight) / 2;
    self.usernameImageView.clipsToBounds = YES;
    [self.filmBackgroundView addSubview:_usernameImageView];
    
    // 用户名称
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.usernameImageView.frame.origin.x + self.usernameImageView.frame.size.width + 10, self.usernameImageView.frame.origin.y, self.frame.size.width - 10 - self.usernameImageView.frame.size.width - 10 - 10, 20 * OffHeight)];
    self.usernameLabel.textColor = [UIColor grayColor];
    self.usernameLabel.font = [UIFont systemFontOfSize:17];
    self.usernameLabel.textAlignment = NSTextAlignmentLeft;
    [self.filmBackgroundView addSubview:_usernameLabel];
    
    // 星级
    self.starsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.usernameLabel.frame.origin.x, self.usernameLabel.frame.origin.y + self.usernameLabel.frame.size.height, self.usernameLabel.frame.size.width, self.usernameLabel.frame.size.height * OffHeight)];
    self.starsLabel.textAlignment = NSTextAlignmentLeft;
    self.starsLabel.textColor = [UIColor grayColor];
    [self.filmBackgroundView addSubview:_starsLabel];
    
    // 内容
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.usernameImageView.frame.origin.x, self.usernameImageView.frame.origin.y + self.usernameImageView.frame.size.height + 5, self.frame.size.width - 20, 80 * OffHeight)];
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.numberOfLines = 0;
    [self.filmBackgroundView addSubview:_contentLabel];
    
    // 释放
    [_starsLabel release];
    [_contentLabel release];
    [_usernameLabel release];
    [_usernameImageView release];
    [_filmBackgroundView release];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
