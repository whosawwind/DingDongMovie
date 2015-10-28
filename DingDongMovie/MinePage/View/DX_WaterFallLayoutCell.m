//
//  DX_WaterFallLayoutCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_WaterFallLayoutCell.h"

#import "UIImageView+WebCache.h"

@interface DX_WaterFallLayoutCell ()

@property (nonatomic, retain) UIView *waterFallCard;  /**< 瀑布流卡片*/
@property (nonatomic, retain) UIImageView *filmPosterImageView;  /**< 推荐电影海报*/
@property (nonatomic, retain) UILabel *filmChineseNameLabel;  /**< 电影中文名*/
@property (nonatomic, retain) UILabel *filmEnglishNameLabel;  /**< 电影英文名*/
@property (nonatomic, retain) UILabel *filmRankingLabel;  /**< 电影排名*/

@end

@implementation DX_WaterFallLayoutCell

- (void)dealloc
{
    [_topMovieModel release];
    [_filmRankingLabel release];
    [_filmEnglishNameLabel release];
    [_filmChineseNameLabel release];
    [_filmPosterImageView release];
    [_waterFallCard release];
    [super dealloc];
}

- (void)setTopMovieModel:(DX_TopMovieModel *)topMovieModel
{
    if (_topMovieModel != topMovieModel) {
        [_topMovieModel release];
        _topMovieModel = [topMovieModel retain];
    }
    [self.filmPosterImageView sd_setImageWithURL:[NSURL URLWithString:[self.topMovieModel.images objectForKey:@"large"]]];
    self.filmRankingLabel.text = [NSString stringWithFormat:@"%d", self.topMovieModel.filmNum];
    self.filmChineseNameLabel.text = self.topMovieModel.title;
    self.filmEnglishNameLabel.text = self.topMovieModel.original_title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createWaterFallLayoutCell];
    }
    return self;
}

- (void)createWaterFallLayoutCell
{
    // 创建背景视图
    self.waterFallCard = [[UIView alloc] initWithFrame:CGRectZero];
    self.waterFallCard.backgroundColor = [UIColor colorWithRed:(arc4random() % 256) / 255.0
                                                         green:(arc4random() % 256) / 255.0
                                                          blue:(arc4random() % 256) / 255.0
                                                         alpha:0.7];
    self.waterFallCard.layer.cornerRadius = 8;
    self.waterFallCard.clipsToBounds = YES;
    self.waterFallCard.layer.shadowOpacity = 0.8;  // 阴影透明度
    self.waterFallCard.layer.cornerRadius = 5;  // 阴影半径
    self.waterFallCard.layer.shadowOffset = CGSizeMake(0, 3);  // 阴影偏移
    self.waterFallCard.layer.shadowColor = [UIColor blackColor].CGColor;  // 阴影颜色
    [self.contentView addSubview:_waterFallCard];
    // 创建电影海报
    self.filmPosterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.filmPosterImageView.backgroundColor = [UIColor clearColor];
    [self.waterFallCard addSubview:_filmPosterImageView];
    // 创建影片排名
    self.filmRankingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.filmRankingLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.filmRankingLabel.textColor = FilmTypeLabelColor;
    self.filmRankingLabel.textAlignment = NSTextAlignmentCenter;
    [self.filmPosterImageView addSubview:_filmRankingLabel];
    // 创建电影中文名
    self.filmChineseNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.filmChineseNameLabel.backgroundColor = [UIColor whiteColor];
    self.filmChineseNameLabel.textAlignment = NSTextAlignmentCenter;
    self.filmChineseNameLabel.font = [UIFont systemFontOfSize:16];
    [self.waterFallCard addSubview:_filmChineseNameLabel];
    // 创建电影英文名
    self.filmEnglishNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.filmEnglishNameLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.filmEnglishNameLabel.layer.borderWidth = 0.5;
    self.filmEnglishNameLabel.backgroundColor = [UIColor whiteColor];
    self.filmEnglishNameLabel.textAlignment = NSTextAlignmentCenter;
    self.filmEnglishNameLabel.textColor = [UIColor grayColor];
    self.filmEnglishNameLabel.font = [UIFont systemFontOfSize:13];
    [self.waterFallCard addSubview:_filmEnglishNameLabel];
    // 释放
    [_filmEnglishNameLabel release];
    [_filmChineseNameLabel release];
    [_filmRankingLabel release];
    [_filmPosterImageView release];
    [_waterFallCard release];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    // 背景视图
    self.waterFallCard.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    // 电影海报
    self.filmPosterImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 50);
    // 电影排名
    self.filmRankingLabel.frame = CGRectMake(self.filmPosterImageView.frame.origin.x + 10, self.filmPosterImageView.frame.origin.y + self.filmPosterImageView.frame.size.height - 35, 35, 25);
    // 电影中文名
    self.filmChineseNameLabel.frame = CGRectMake(self.filmPosterImageView.frame.origin.x, self.filmPosterImageView.frame.origin.y + self.filmPosterImageView.frame.size.height, self.frame.size.width, 30);
    // 电影英文名
    self.filmEnglishNameLabel.frame = CGRectMake(self.filmChineseNameLabel.frame.origin.x, self.filmChineseNameLabel.frame.origin.y + self.filmChineseNameLabel.frame.size.height, self.filmChineseNameLabel.frame.size.width, 20);
}

@end
