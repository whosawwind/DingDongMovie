//
//  MovieDetailsInfoCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_MovieDetailsInfoCell.h"

#import "UIImageView+WebCache.h"

#import "DX_MovieDetailsModel.h"

@interface DX_MovieDetailsInfoCell ()

@property (nonatomic, retain) UIImageView *detailsPosterImage;  /**< 海报*/
@property (nonatomic, retain) UILabel *filmNameLabel;  /**< 电影名称*/
@property (nonatomic, retain) UILabel *countriesLabel;  /**< 国家*/
@property (nonatomic, retain) UILabel *filmStarsLabel;  /**< 星级*/
@property (nonatomic, retain) UILabel *filmGradeLabel;  /**< 评分*/

@end

@implementation DX_MovieDetailsInfoCell

- (void)dealloc
{
    [_movieDetailsModel release];
    [_filmGradeLabel release];
    [_filmStarsLabel release];
    [_countriesLabel release];
    [_filmNameLabel release];
    [_detailsPosterImage release];
    [super dealloc];
}

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createMovieDetailsInfoCell];
    }
    return self;
}

#pragma mark - 创建影片详情Cell
- (void)createMovieDetailsInfoCell
{
    // 电影海报
    self.detailsPosterImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.detailsPosterImage.layer.shadowColor = [UIColor blackColor].CGColor;  // 阴影颜色
    self.detailsPosterImage.layer.shadowOffset = CGSizeMake(0.5, 2);  // 阴影偏移
    self.detailsPosterImage.layer.shadowOpacity = 0.8;  // 阴影透明度
    self.detailsPosterImage.layer.shadowRadius = 5;  // 阴影半径
    [self.contentView addSubview:_detailsPosterImage];

    // 影片名
    self.filmNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.filmNameLabel.font = [UIFont systemFontOfSize:18];
    self.filmNameLabel.textColor = [UIColor blackColor];
    self.filmNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_filmNameLabel];
    
    // 国家
    self.countriesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.countriesLabel.font = [UIFont systemFontOfSize:15];
    self.countriesLabel.textColor = [UIColor grayColor];
    self.countriesLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_countriesLabel];

    // 星级
    self.filmStarsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_filmStarsLabel];
    
    // 评分
    self.filmGradeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.filmGradeLabel.backgroundColor = [UIColor colorWithString:@"#548F0E"];
    self.filmGradeLabel.textAlignment = NSTextAlignmentCenter;
    self.filmGradeLabel.textColor = [UIColor whiteColor];
    self.filmGradeLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:_filmGradeLabel];
    
    // 上映时间, 影片时长, 影片类型
    for (int i = 0; i < 3; i++) {
        UILabel *filmLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        filmLabel.tag = 1000 + i;
        filmLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:filmLabel];
        [filmLabel release];
    }
    
    // 释放
    [_filmGradeLabel release];
    [_filmStarsLabel release];
    [_countriesLabel release];
    [_filmNameLabel release];
    [_detailsPosterImage release];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 海报
    self.detailsPosterImage.frame = CGRectMake(10, 10, 120, self.frame.size.height - 20);
    
    NSString *url = [self.movieDetailsModel.images objectForKey:@"large"];
    [self.detailsPosterImage sd_setImageWithURL:[NSURL URLWithString:url]
                               placeholderImage:[UIImage imageNamed:@"dx_homepage_movieplaceholder"]];
    
    // 影片名称
    self.filmNameLabel.frame = CGRectMake(self.detailsPosterImage.frame.origin.x + self.detailsPosterImage.frame.size.width + 5, self.detailsPosterImage.frame.origin.y, self.frame.size.width - self.detailsPosterImage.frame.origin.x - self.detailsPosterImage.frame.size.width - 5, 30);
    self.filmNameLabel.text = self.movieDetailsModel.title;
    
    // 国家
    self.countriesLabel.frame = CGRectMake(self.filmNameLabel.frame.origin.x, self.filmNameLabel.frame.origin.y + self.filmNameLabel.frame.size.height, self.filmNameLabel.frame.size.width, 20);
    self.countriesLabel.text = [NSString stringWithFormat:@"国家/地区: %@", self.movieDetailsModel.countries[0]];
    
    // 影片星级
    self.filmStarsLabel.frame = CGRectMake(self.countriesLabel.frame.origin.x, self.countriesLabel.frame.origin.y + self.countriesLabel.frame.size.height, self.countriesLabel.frame.size.width - 50, self.countriesLabel.frame.size.height + 10);
    // 计算星星数量
    int starNum = ([[self.movieDetailsModel.rating objectForKey:@"stars"] intValue] - 5);
    int fullStarNum = starNum / 10;
    int halfStarNum = (starNum - fullStarNum * 10) / 5;
    int emptyStarNum = 5 - fullStarNum - halfStarNum;
    if (starNum >= 0) {
        for (int i = 0; i < fullStarNum; i++) {
            UIImageView *fullStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.countriesLabel.frame.size.width / 2 - 70 + 15 * i, 7, 15, 15)];
            fullStarImageView.image = [UIImage imageNamed:@"dx_hotshowingcollectionviewcell_star_red"];
            [self.filmStarsLabel addSubview:fullStarImageView];
            [fullStarImageView release];
        }
        for (int i = fullStarNum; i < 5 - emptyStarNum; i++) {
            UIImageView *halfStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.countriesLabel.frame.size.width / 2 - 70 + fullStarNum * 15 + 15 * (i - fullStarNum), 7, 15, 15)];
            halfStarImageView.image = [UIImage imageNamed:@"dx_hotshowingcollectionviewcell_star_half"];
            [self.filmStarsLabel addSubview:halfStarImageView];
            [halfStarImageView release];
        }
        for (int i = fullStarNum + halfStarNum; i < 5; i++) {
            UIImageView *emptyStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.countriesLabel.frame.size.width / 2 - 70 + fullStarNum * 15 + halfStarNum * 15 + 15 * (i - fullStarNum - halfStarNum), 7, 15, 15)];
            emptyStarImageView.image = [UIImage imageNamed:@"dx_hotshowingcollectionviewcell_star_gray"];
            [self.filmStarsLabel addSubview:emptyStarImageView];
            [emptyStarImageView release];
        }
    } else {
        self.filmStarsLabel.text = @"暂无信息";
    }
    
    // 影片评分
    self.filmGradeLabel.frame = CGRectMake(self.filmStarsLabel.frame.origin.x + self.filmStarsLabel.frame.size.width, self.filmStarsLabel.frame.origin.y, 40, self.filmStarsLabel.frame.size.height);
    float filmGrade = [[self.movieDetailsModel.rating objectForKey:@"average"] floatValue];
    self.filmGradeLabel.text = [NSString stringWithFormat:@"%.1f", filmGrade];
    
    // 上映时间字符串
    NSString *pubdateStr = [NSString string];
    if (self.movieDetailsModel.pubdate.length == 0) {
        pubdateStr = @"";
    } else {
        pubdateStr = [NSString stringWithFormat:@"%@ 上映", self.movieDetailsModel.pubdate];
    }
    // 影片类型字符串
    // 如果影片类型数组不为空, 赋值; 否则不赋值
    NSMutableString *filmTags = [NSMutableString string];
    if ([self.movieDetailsModel.genres count] > 0) {
        filmTags = [NSMutableString stringWithFormat:@"%@", self.movieDetailsModel.genres[0]];
        for (int i = 1; i < [self.movieDetailsModel.genres count]; i++) {
            [filmTags appendString:[NSString stringWithFormat:@"/%@", self.movieDetailsModel.genres[i]]];
        }
    }
    // 上映时间, 影片时长, 影片类型数组
    NSArray *movieInfoArray = [NSArray array];
    if ([self.movieDetailsModel.durations count] > 0) {
        movieInfoArray = [NSArray arrayWithObjects:pubdateStr, self.movieDetailsModel.durations[0], filmTags, nil];
    } else {
        movieInfoArray = [NSArray arrayWithObjects:pubdateStr, @"", filmTags, nil];
    }
    // 影片相关信息标签, 循环赋值
    for (int i = 0; i < 3; i++) {
        UILabel *filmLabel = (UILabel *)[self viewWithTag:1000 + i];
        filmLabel.frame = CGRectMake(self.filmNameLabel.frame.origin.x, self.filmStarsLabel.frame.origin.y + self.filmStarsLabel.frame.size.height + 10 + self.filmNameLabel.frame.size.height * i, self.frame.size.width - self.detailsPosterImage.frame.size.width - 15, self.filmNameLabel.frame.size.height);
        filmLabel.text = movieInfoArray[i];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
