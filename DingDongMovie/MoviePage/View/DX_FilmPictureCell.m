//
//  DX_FilmPictureCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_FilmPictureCell.h"
#import "DX_MovieDetailsModel.h"

#import "UIImageView+WebCache.h"

@interface DX_FilmPictureCell ()

@property (nonatomic, retain) UILabel *splendidHighlightsLabel;  /**< 精彩片段标题*/
@property (nonatomic, retain) UIButton *rightwardsButton;  /**< 向右按钮*/

@end

@implementation DX_FilmPictureCell

- (void)dealloc
{
    [_movieDetailsModel release];
    [_rightwardsButton release];
    [_splendidHighlightsLabel release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createFilmPictureCell];
    }
    return self;
}

- (void)createFilmPictureCell
{
    // 精彩片段标题
    self.splendidHighlightsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.splendidHighlightsLabel.text = @"精彩片段";
    self.splendidHighlightsLabel.font = MovieDetailsFont;
    self.splendidHighlightsLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_splendidHighlightsLabel];
    
    // 图片
    for (int i = 0; i < 4; i++) {
        UIImageView *images = [[UIImageView alloc] initWithFrame:CGRectZero];
        images.tag = 1000 + i;
        [self.contentView addSubview:images];
    }
    
    // 向右按钮
    self.rightwardsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightwardsButton.frame = CGRectZero;
    // 关闭用户交互
    self.rightwardsButton.userInteractionEnabled = NO;
    [self.rightwardsButton setImage:[UIImage imageNamed:@"dx_filmpicturecell_rightwards"]
                           forState:UIControlStateNormal];
    [self.rightwardsButton setImage:[UIImage imageNamed:@"dx_filmpicturecell_rightwardshighlight"]
                           forState:UIControlStateHighlighted];
    [self.contentView addSubview:_rightwardsButton];
    
    // 释放
    [_splendidHighlightsLabel release];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 精彩片段标题
    self.splendidHighlightsLabel.frame = CGRectMake(10, 10, 80, 30);
    
    // 图片
    for (int i = 0; i < self.movieDetailsModel.photos.count; i++) {
        UIImageView *images = (UIImageView *)[self viewWithTag:1000 + i];
        images.frame = CGRectMake((self.splendidHighlightsLabel.frame.origin.x + 70 * i + 5 * i) * OffWidth, (self.splendidHighlightsLabel.frame.origin.y + self.splendidHighlightsLabel.frame.size.height + 10) * OffHeight, 70 * OffHeight, 70 * OffHeight);
        NSString *urlString = [[self.movieDetailsModel.photos objectAtIndex:i] objectForKey:@"image"];
        [images sd_setImageWithURL:[NSURL URLWithString:urlString]
                  placeholderImage:[UIImage imageNamed:@"dx_defaultimage"]];
    }
    
    // 向右按钮
    self.rightwardsButton.frame = CGRectMake(self.frame.size.width - 40, self.splendidHighlightsLabel.frame.origin.y + self.splendidHighlightsLabel.frame.size.height, 30, 50);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
