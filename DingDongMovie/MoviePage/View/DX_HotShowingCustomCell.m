//
//  DX_HotShowingCustomCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/10.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_HotShowingCustomCell.h"

@implementation DX_HotShowingCustomCell

- (void)dealloc
{
    [_filmGradeLabel release];
    [_filmStarsView release];
    [_filmNameLabel release];
    [_filmPosterImageView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHotShowingCustomCell];
    }
    return self;
}

- (void)createHotShowingCustomCell
{
    // 海报
    self.filmPosterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
 
    [self.contentView addSubview:_filmPosterImageView];
    
    // 影片名称
    self.filmNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    self.filmNameLabel.textAlignment = NSTextAlignmentCenter;
    self.filmNameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_filmNameLabel];
    
    // 星级
    self.filmStarsView = [[UILabel alloc] initWithFrame:CGRectZero];

    self.filmStarsView.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_filmStarsView];
    
    // 影片评分
    self.filmGradeLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    self.filmGradeLabel.textAlignment = NSTextAlignmentCenter;
    self.filmGradeLabel.textColor = FilmTypeLabelColor;
    self.filmGradeLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_filmGradeLabel];
    
    // 释放
    [_filmGradeLabel release];
    [_filmStarsView release];
    [_filmNameLabel release];
    [_filmPosterImageView release];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    // 海报
    self.filmPosterImageView.frame = CGRectMake(2, 2, self.frame.size.width, self.frame.size.height - 60);
    
    // 影片名称
    self.filmNameLabel.frame = CGRectMake(self.filmPosterImageView.frame.origin.x, self.filmPosterImageView.frame.origin.y + self.filmPosterImageView.frame.size.height, self.frame.size.width, 30);
    self.filmNameLabel.text = @"影片名称";
    
    // 星级
    if (MobileDevicesScreenWidth == iPhone6Width && MobileDevicesScreenHeight == iPhone6Height) {
        self.filmStarsView.frame = CGRectMake(self.filmNameLabel.frame.origin.x + 20, self.filmNameLabel.frame.origin.y + self.filmNameLabel.frame.size.height, self.filmNameLabel.frame.size.width - 80, 20);
    } else if (MobileDevicesScreenWidth == iPhone6PlusWidth && MobileDevicesScreenHeight == iPhone6PlusHeight) {
        self.filmStarsView.frame = CGRectMake(self.filmNameLabel.frame.origin.x + 40, self.filmNameLabel.frame.origin.y + self.filmNameLabel.frame.size.height, self.filmNameLabel.frame.size.width - 100, 20);
    } else {
        self.filmStarsView.frame = CGRectMake(self.filmNameLabel.frame.origin.x + 20, self.filmNameLabel.frame.origin.y + self.filmNameLabel.frame.size.height, self.filmNameLabel.frame.size.width - 60, 20);
    }
    
    // 影片评价
    self.filmGradeLabel.frame = CGRectMake(self.filmStarsView.frame.origin.x + self.filmStarsView.frame.size.width, self.filmNameLabel.frame.origin.y + self.filmNameLabel.frame.size.height + 1, 27, self.filmStarsView.frame.size.height);
}

@end
