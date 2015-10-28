//
//  DX_ShortCommentaryCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_ShortCommentaryCell.h"

#import "DX_ShortCommentaryView.h"

#import "DX_ShortCommentaryModel.h"

#import "UIImageView+WebCache.h"
#import "HeightForString.h"

@interface DX_ShortCommentaryCell ()

@property (nonatomic, retain) DX_ShortCommentaryView *shortCommentaryView;  /**< 自定义视图*/

@end

@implementation DX_ShortCommentaryCell

- (void)dealloc
{
    [_shortCommentaryModel release];
    [_shortCommentaryView release];
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createFilmReviewsCell];
    }
    return self;
}

- (void)createFilmReviewsCell
{
    // 创建评论自定义视图, 按照设备屏幕尺寸缩放
    self.shortCommentaryView = [[DX_ShortCommentaryView alloc] initWithFrame:CGRectMake(10, 10, (iPhone6Width - 20) * OffWidth, 165 * OffHeight)];
    [self.contentView addSubview:_shortCommentaryView];
    [_shortCommentaryView release];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 用户头像
    [self.shortCommentaryView.usernameImageView sd_setImageWithURL:[NSURL URLWithString:[self.shortCommentaryModel.author objectForKey:@"avatar"]]
                                                  placeholderImage:[UIImage imageNamed:@"dx_homepage_hotshowing"]];
    
    // 用户名称
    self.shortCommentaryView.usernameLabel.text = [self.shortCommentaryModel.author objectForKey:@"name"];
    
    // 评论内容
    CGFloat contentHeight = [HeightForString heightWithString:self.shortCommentaryModel.content
                                                        width:self.frame.size.width - 20
                                                     fontSize:16];
    self.shortCommentaryView.contentLabel.text = self.shortCommentaryModel.content;
    self.shortCommentaryView.contentLabel.frame = CGRectMake(self.shortCommentaryView.usernameImageView.frame.origin.x, self.shortCommentaryView.usernameImageView.frame.origin.y + self.shortCommentaryView.usernameImageView.frame.size.height + 5, self.shortCommentaryView.frame.size.width - 20, (contentHeight + 100) * OffHeight);
    self.shortCommentaryView.filmBackgroundView.frame = CGRectMake(0, 0, (iPhone6Width - 20) * OffWidth, (contentHeight + 120 + 50) * OffHeight);
    
    // 星级
    for (UIView *view in [self.shortCommentaryView.starsLabel subviews]) {
        [view removeFromSuperview];
    }
    // 计算星星数量
    int fullStarNum = [[self.shortCommentaryModel.rating objectForKey:@"value"] intValue];
    for (int i = 0; i < fullStarNum; i++) {
        UIImageView *fullStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + 15 * i, 0, 15, 15)];
        fullStarImageView.image = [UIImage imageNamed:@"dx_moviepagefilmreview_fullstar_red"];
        [self.shortCommentaryView.starsLabel addSubview:fullStarImageView];
        [fullStarImageView release];
    }
    for (int i = fullStarNum; i < 5; i++) {
        UIImageView *emptyStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(fullStarNum * 15 + 15 * (i - fullStarNum), 0, 15, 15)];
        emptyStarImageView.image = [UIImage imageNamed:@"dx_moviepagefilmreview_emptystar_red"];
        [self.shortCommentaryView.starsLabel addSubview:emptyStarImageView];
        [emptyStarImageView release];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
