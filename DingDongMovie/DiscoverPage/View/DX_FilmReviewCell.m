//
//  DX_FilmReviewCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/16.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_FilmReviewCell.h"
#import "DX_FilmReviewView.h"

#import "DX_FilmReviewModel.h"

#import "HeightForString.h"
#import "WidthForString.h"

@interface DX_FilmReviewCell ()

@property (nonatomic, retain) DX_FilmReviewView *filmReviewView;  /**< 影评自定义视图*/

@end

@implementation DX_FilmReviewCell

- (void)dealloc
{
    [_filmReviewModel release];
    [_filmReviewView release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createFilmReviewCell];
    }
    return self;
}

- (void)createFilmReviewCell
{
    // 创建评论自定义视图, 按照设备屏幕尺寸缩放
    self.filmReviewView = [[DX_FilmReviewView alloc] initWithFrame:CGRectMake(10, 10, (iPhone6Width - 20) * OffWidth, 165 * OffHeight)];
    [self.contentView addSubview:_filmReviewView];
    [_filmReviewView release];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 影评标题
    self.filmReviewView.filmTitleLabel.text = self.filmReviewModel.title;
    
    // 用户名称
    self.filmReviewView.usernameLabel.text = [self.filmReviewModel.author objectForKey:@"name"];
    CGFloat usernameLabelWidth = [WidthForString widthWithString:[self.filmReviewModel.author objectForKey:@"name"]
                                                          height:20 * OffHeight
                                                        fontSize:17];
    self.filmReviewView.usernameLabel.frame = CGRectMake(self.filmReviewView.filmTitleLabel.frame.origin.x, self.filmReviewView.filmTitleLabel.frame.origin.y + self.filmReviewView.filmTitleLabel.frame.size.height, usernameLabelWidth, 20 * OffHeight);
    
    // 评论内容
    CGFloat contentHeight = [HeightForString heightWithString:self.filmReviewModel.summary width:self.frame.size.width - 20 fontSize:16];
    self.filmReviewView.contentLabel.text = self.filmReviewModel.summary;
    
    self.filmReviewView.contentLabel.frame = CGRectMake(self.filmReviewView.usernameLabel.frame.origin.x, self.filmReviewView.usernameLabel.frame.origin.y + self.filmReviewView.usernameLabel.frame.size.height + 5, self.filmReviewView.frame.size.width - 20, contentHeight * OffHeight);
    self.filmReviewView.filmBackgroundView.frame = CGRectMake(0, 0, (iPhone6Width - 20) * OffWidth, (contentHeight + 80) * OffHeight);
    
    // 星级
    self.filmReviewView.starsLabel.frame = CGRectMake(self.filmReviewView.usernameLabel.frame.origin.x + self.filmReviewView.usernameLabel.frame.size.width + 5, self.filmReviewView.usernameLabel.frame.origin.y + 2, 80, self.filmReviewView.usernameLabel.frame.size.height * OffHeight);
    for (UIView *view in [self.filmReviewView.starsLabel subviews]) {
        [view removeFromSuperview];
    }
    // 计算星星数量
    int fullStarNum = [[self.filmReviewModel.rating objectForKey:@"value"] intValue];
    for (int i = 0; i < fullStarNum; i++) {
        UIImageView *fullStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + 15 * i, 0, 15, 15)];
        fullStarImageView.image = [UIImage imageNamed:@"dx_moviepagefilmreview_fullstar_red"];
        [self.filmReviewView.starsLabel addSubview:fullStarImageView];
        [fullStarImageView release];
    }
    for (int i = fullStarNum; i < 5; i++) {
        UIImageView *emptyStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(fullStarNum * 15 + 15 * (i - fullStarNum), 0, 15, 15)];
        emptyStarImageView.image = [UIImage imageNamed:@"dx_moviepagefilmreview_emptystar_red"];
        [self.filmReviewView.starsLabel addSubview:emptyStarImageView];
        [emptyStarImageView release];
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
