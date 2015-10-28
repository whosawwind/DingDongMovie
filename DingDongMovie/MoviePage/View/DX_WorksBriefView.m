//
//  DX_WorksBriefView.m
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_WorksBriefView.h"

@implementation DX_WorksBriefView

- (void)dealloc
{
    [_filmEnglishNameLabel release];
    [_filmGradeLabel release];
    [_filmNameLabel release];
    [_leftPosterImageView release];
    [_photographicPlateView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createWorksBriefView];
    }
    return self;
}

- (void)createWorksBriefView
{
    // 背景视图
    self.photographicPlateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.photographicPlateView.backgroundColor = DirectorCardColor;
    self.photographicPlateView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.photographicPlateView.layer.shadowOffset = CGSizeMake(1, 3);
    self.photographicPlateView.layer.shadowOpacity = 0.5;
    self.photographicPlateView.layer.shadowRadius = 5;
    [self addSubview:_photographicPlateView];
    
    // 左侧图片
    self.leftPosterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, (self.frame.size.height - 20))];
    self.leftPosterImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.leftPosterImageView.layer.borderWidth = 0.5;
    [self.photographicPlateView addSubview:_leftPosterImageView];
    
    // 电影名
    self.filmNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftPosterImageView.frame.origin.x + self.leftPosterImageView.frame.size.width + 10, self.leftPosterImageView.frame.origin.y * OffHeight, self.frame.size.width - self.leftPosterImageView.frame.origin.x - self.leftPosterImageView.frame.size.width - 10 - 10, 40 * OffHeight)];
    self.filmNameLabel.textAlignment = NSTextAlignmentLeft;
    self.filmNameLabel.font = [UIFont systemFontOfSize:17];
    [self.photographicPlateView addSubview:_filmNameLabel];
    
    // 电影外文名
    self.filmEnglishNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.filmNameLabel.frame.origin.x, (self.filmNameLabel.frame.origin.y + self.filmNameLabel.frame.size.height), self.filmNameLabel.frame.size.width, 40 * OffHeight)];
    self.filmEnglishNameLabel.numberOfLines = 0;
    self.filmEnglishNameLabel.textAlignment = NSTextAlignmentLeft;
    self.filmEnglishNameLabel.font = [UIFont systemFontOfSize:15];
    self.filmEnglishNameLabel.textColor = [UIColor grayColor];
    [self.photographicPlateView addSubview:_filmEnglishNameLabel];
    
    // 评分
    self.filmGradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.filmEnglishNameLabel.frame.origin.x, self.filmEnglishNameLabel.frame.origin.y + self.filmEnglishNameLabel.frame.size.height, 100, 40)];
    self.filmGradeLabel.font = [UIFont systemFontOfSize:18];
    self.filmGradeLabel.textColor = FilmTypeLabelColor;
    self.filmGradeLabel.textAlignment = NSTextAlignmentLeft;
    [self.photographicPlateView addSubview:_filmGradeLabel];
    
    // 释放
    [_filmGradeLabel release];
    [_filmEnglishNameLabel release];
    [_filmNameLabel release];
    [_leftPosterImageView release];
    [_photographicPlateView release];
}

- (void)addNewTarget:(id)target action:(SEL)action
{
    // 保存target和action
    self.target = target;
    self.action = action;
}

// 触发协议方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.target performSelector:self.action withObject:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
