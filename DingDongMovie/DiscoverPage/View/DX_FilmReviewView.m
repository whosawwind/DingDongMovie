//
//  DX_FilmReviewView.m
//  DingDongMovie
//
//  Created by dllo on 15/9/16.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_FilmReviewView.h"

@implementation DX_FilmReviewView

- (void)dealloc
{
    [_contentLabel release];
    [_starsLabel release];
    [_usernameLabel release];
    [_filmTitleLabel release];
    [_filmBackgroundView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createFilmReviewView];
    }
    return self;
}

// 创建子视图
- (void)createFilmReviewView
{
    // 背景视图
    self.filmBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.filmBackgroundView.backgroundColor = DiscoverFilmReviewCardColor;
    self.filmBackgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.filmBackgroundView.layer.shadowOffset = CGSizeMake(1, 3);
    self.filmBackgroundView.layer.shadowOpacity = 0.5;
    self.filmBackgroundView.layer.shadowRadius = 5;
    [self addSubview:_filmBackgroundView];
    
    // 影评标题
    self.filmTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 40 * OffHeight)];
    self.filmTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.filmTitleLabel.font = [UIFont systemFontOfSize:19];
    [self.filmBackgroundView addSubview:_filmTitleLabel];
    
    // 用户名称
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.filmTitleLabel.frame.origin.x, self.filmTitleLabel.frame.origin.y + self.filmTitleLabel.frame.size.height, self.filmTitleLabel.frame.size.width - 80, 20 * OffHeight)];
    self.usernameLabel.textColor = [UIColor colorWithWhite:0.121 alpha:1.000];
    self.usernameLabel.textAlignment = NSTextAlignmentLeft;
    [self.filmBackgroundView addSubview:_usernameLabel];
    
    // 星级
    self.starsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.usernameLabel.frame.origin.x + self.usernameLabel.frame.size.width + 5, self.usernameLabel.frame.origin.y + 2, 80, self.usernameLabel.frame.size.height * OffHeight)];
    self.starsLabel.textAlignment = NSTextAlignmentLeft;
    self.starsLabel.textColor = [UIColor grayColor];
    [self.filmBackgroundView addSubview:_starsLabel];
    
    // 内容
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.usernameLabel.frame.origin.x, self.usernameLabel.frame.origin.y + self.usernameLabel.frame.size.height + 5, self.frame.size.width - 20, 80 * OffHeight)];
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.numberOfLines = 0;
    [self.filmBackgroundView addSubview:_contentLabel];
    
    // 释放
    [_starsLabel release];
    [_contentLabel release];
    [_usernameLabel release];
    [_filmTitleLabel release];
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
