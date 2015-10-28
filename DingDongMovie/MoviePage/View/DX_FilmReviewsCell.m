//
//  DX_FilmReviewsCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_FilmReviewsCell.h"

#import "DX_FilmReviewCardView.h"

#import "DX_PopularCommentsModel.h"

#import "UIImageView+WebCache.h"
#import "HeightForString.h"

@interface DX_FilmReviewsCell ()

@property (nonatomic, retain) UILabel *handpickCommentTitleLabel;  /**< 精选评论标题*/

@end

@implementation DX_FilmReviewsCell

- (void)dealloc
{
    [_movieDetailsModel release];
    [_popularCommentsArray release];
    [_handpickCommentTitleLabel release];
    [super dealloc];
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
    // 精选评论标题
    self.handpickCommentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
    if (MobileDevicesScreenWidth == iPhone4SWidth && MobileDevicesScreenHeight == iPhone4SHeight) {
        self.handpickCommentTitleLabel.text = @"";
    } else {
        self.handpickCommentTitleLabel.text = @"精选评论";
    }
    self.handpickCommentTitleLabel.font = MovieDetailsFont;
    self.handpickCommentTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_handpickCommentTitleLabel];
    
    // 循环创建评论自定义视图, 按照设备屏幕尺寸缩放
    for (int i = 0 ; i < 4; i++) {
        DX_FilmReviewCardView *filmReviewCardView = [[DX_FilmReviewCardView alloc] initWithFrame:CGRectMake(self.handpickCommentTitleLabel.frame.origin.x * OffWidth, (self.handpickCommentTitleLabel.frame.origin.y + self.handpickCommentTitleLabel.frame.size.height + 165 * i + 5 * i) * OffHeight, (iPhone6Width - 20) * OffWidth, 165 * OffHeight)];
        filmReviewCardView.tag = 1000 + i;
        [self.contentView addSubview:filmReviewCardView];
    }
    // 释放
    [_handpickCommentTitleLabel release];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.popularCommentsArray.count == 0) {
        self.handpickCommentTitleLabel.text = @"";
    }
    // 赋值
    for (int i = 0; i < self.popularCommentsArray.count; i++) {
        DX_FilmReviewCardView *filmReviewCardView = (DX_FilmReviewCardView *)[self viewWithTag:1000 + i];
        DX_PopularCommentsModel *model = [self.popularCommentsArray objectAtIndex:i];
        // 用户头像
        [filmReviewCardView.usernameImageView sd_setImageWithURL:[NSURL URLWithString:[model.author objectForKey:@"avatar"]]
                                                placeholderImage:[UIImage imageNamed:@"dx_moviepage_person_placeholder"]];
        // 用户名称
        filmReviewCardView.usernameLabel.text = [model.author objectForKey:@"name"];
        // 评论创建时间
        filmReviewCardView.createAtLabel.text = model.created_at;
        // 评论内容
        filmReviewCardView.contentLabel.text = model.content;
        // 星级
        if ([[model.rating objectForKey:@"value"] intValue] > 0) {
            // 计算星星数量
            int fullStarNum = [[model.rating objectForKey:@"value"] intValue];
            for (int i = 0; i < fullStarNum; i++) {
                UIImageView *fullStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + 15 * i, 0, 15, 15)];
                fullStarImageView.image = [UIImage imageNamed:@"dx_moviepagefilmreview_fullstar_red"];
                [filmReviewCardView.starsLabel addSubview:fullStarImageView];
                [fullStarImageView release];
            }
            for (int i = fullStarNum; i < 5; i++) {
                UIImageView *emptyStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(fullStarNum * 15 + 15 * (i - fullStarNum), 0, 15, 15)];
                emptyStarImageView.image = [UIImage imageNamed:@"dx_moviepagefilmreview_emptystar_red"];
                [filmReviewCardView.starsLabel addSubview:emptyStarImageView];
                [emptyStarImageView release];
            }
        } else {
            filmReviewCardView.starsLabel.text = @"该用户没有对本影片进行评分";
        }
    }
    for (int i = (int)self.popularCommentsArray.count; i < 4; i++) {
        DX_FilmReviewCardView *filmReviewCardView = (DX_FilmReviewCardView *)[self.contentView viewWithTag:1000 + i];
        [filmReviewCardView removeFromSuperview];
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
