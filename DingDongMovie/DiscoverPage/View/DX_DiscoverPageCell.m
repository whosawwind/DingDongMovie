//
//  DX_DiscoverPageCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_DiscoverPageCell.h"

@interface DX_DiscoverPageCell ()

@property (nonatomic, retain) UIButton *videoButton;  /**< 视频按钮*/
@property (nonatomic, retain) UIView *leftCutOffRule;  /**< 左分割线*/
@property (nonatomic, retain) UIButton *interactionButton;  /**< 互动按钮*/
@property (nonatomic, retain) UIView *topCutOffRule;  /**< 上分割线*/
@property (nonatomic, retain) UIButton *shortCommentaryButton;  /**< 短评*/
@property (nonatomic, retain) UIView *bottomCutOffRule;  /**< 下分割线*/
@property (nonatomic, retain) UIButton *filmReviewButton;  /**< 影评*/

@end

@implementation DX_DiscoverPageCell

- (void)dealloc
{
    [_filmReviewButton release];
    [_bottomCutOffRule release];
    [_shortCommentaryButton release];
    [_topCutOffRule release];
    [_interactionButton release];
    [_leftCutOffRule release];
    [_videoButton release];
    [super dealloc];
}

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createDiscoverPageCell];
    }
    return self;
}

#pragma mark - 创建Cell
- (void)createDiscoverPageCell
{
    // 创建视频按钮
    self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoButton.frame = CGRectZero;
    self.videoButton.tag = 1000;
    [self.videoButton setImage:[UIImage imageNamed:@"dx_discoverpage_video"]
                      forState:UIControlStateNormal];
    [self.videoButton setImage:[UIImage imageNamed:@"dx_discoverpage_videoselected"]
                      forState:UIControlStateHighlighted];
    self.videoButton.backgroundColor = [UIColor colorWithRed:1.000
                                                       green:0.266
                                                        blue:0.248
                                                       alpha:1.000];
    self.videoButton.titleLabel.font = DiscoverPageFont;
    [self.videoButton addTarget:self action:@selector(buttonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_videoButton];
    
    // 创建左侧竖线
    self.leftCutOffRule = [[UIView alloc] initWithFrame:CGRectZero];
    self.leftCutOffRule.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_leftCutOffRule];
    
    // 创建互动按钮
    self.interactionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.interactionButton.frame = CGRectZero;
    self.interactionButton.tag = 1001;
    [self.interactionButton setImage:[UIImage imageNamed:@"dx_discoverpage_interaction"]
                            forState:UIControlStateNormal];
    [self.interactionButton setImage:[UIImage imageNamed:@"dx_discoverpage_interactionselected"]
                            forState:UIControlStateHighlighted];
    self.interactionButton.backgroundColor = [UIColor colorWithRed:0.437 green:0.790 blue:0.344 alpha:1.000];
    self.interactionButton.titleLabel.font = DiscoverPageFont;
    [self.interactionButton addTarget:self action:@selector(buttonAction:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_interactionButton];
    
    // 创建上方分割线
    self.topCutOffRule = [[UIView alloc] initWithFrame:CGRectZero];
    self.topCutOffRule.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_topCutOffRule];
    
    // 创建短评按钮
    self.shortCommentaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shortCommentaryButton.frame = CGRectZero;
    self.shortCommentaryButton.tag = 1002;
    [self.shortCommentaryButton setImage:[UIImage imageNamed:@"dx_discoverpage_shortcommentary"]
                                forState:UIControlStateNormal];
    [self.shortCommentaryButton setImage:[UIImage imageNamed:@"dx_discoverpage_shortcommentaryselected"]
                                forState:UIControlStateHighlighted];
    self.shortCommentaryButton.backgroundColor = [UIColor colorWithRed:1.000
                                                                 green:0.661
                                                                  blue:0.215
                                                                 alpha:1.000];
    self.shortCommentaryButton.titleLabel.font = DiscoverPageFont;
    [self.shortCommentaryButton addTarget:self
                                   action:@selector(buttonAction:)
                         forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shortCommentaryButton];
    
    // 创建下部分割线
    self.bottomCutOffRule = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomCutOffRule.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bottomCutOffRule];
    
    // 创建影评按钮
    self.filmReviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filmReviewButton.frame = CGRectZero;
    self.filmReviewButton.tag = 1003;
    [self.filmReviewButton setImage:[UIImage imageNamed:@"dx_discoverpage_filmreview"]
                           forState:UIControlStateNormal];
    [self.filmReviewButton setImage:[UIImage imageNamed:@"dx_discoverpage_filmreviewselected"]
                           forState:UIControlStateHighlighted];
    self.filmReviewButton.backgroundColor = [UIColor colorWithRed:0.433 green:0.878 blue:0.845 alpha:1.000];
    self.filmReviewButton.titleLabel.font = DiscoverPageFont;
    [self.filmReviewButton addTarget:self
                              action:@selector(buttonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_filmReviewButton];
    
    // 释放
    [_bottomCutOffRule release];
    [_topCutOffRule release];
    [_leftCutOffRule release];
}

#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)sender
{
    self.transmitButtonContentBlock(sender.tag);
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 视频按钮
    self.videoButton.frame = CGRectMake(10, 10, self.frame.size.width / 2 - 50, self.frame.size.height - 20);
    [self.videoButton setTitle:@"预告片" forState:UIControlStateNormal];
    
    // 左侧分割线
    self.leftCutOffRule.frame = CGRectMake(self.videoButton.frame.origin.x + self.videoButton.frame.size.width, self.videoButton.frame.origin.y, 1, self.videoButton.frame.size.height);
    
    // 互动按钮
    self.interactionButton.frame = CGRectMake(self.leftCutOffRule.frame.origin.x + self.leftCutOffRule.frame.size.width, self.leftCutOffRule.frame.origin.y, self.frame.size.width - self.videoButton.frame.origin.x - self.videoButton.frame.size.width - 1 - 10, 70);
    [self.interactionButton setTitle:@"互动" forState:UIControlStateNormal];
    
    // 上方分割线
    self.topCutOffRule.frame = CGRectMake(self.leftCutOffRule.frame.origin.x, self.interactionButton.frame.origin.y + self.interactionButton.frame.size.height, self.interactionButton.frame.size.width, 1);
    
    // 短评按钮
    self.shortCommentaryButton.frame = CGRectMake(self.interactionButton.frame.origin.x, self.topCutOffRule.frame.origin.y + self.topCutOffRule.frame.size.height, self.interactionButton.frame.size.width / 2 - 1, self.videoButton.frame.size.height - self.interactionButton.frame.size.height - 1);
    [self.shortCommentaryButton setTitle:@"短评" forState:UIControlStateNormal];
    
    // 下部竖线
    self.bottomCutOffRule.frame = CGRectMake(self.shortCommentaryButton.frame.origin.x + self.shortCommentaryButton.frame.size.width, self.shortCommentaryButton.frame.origin.y, 1, self.shortCommentaryButton.frame.size.height);
    
    // 影评按钮
    self.filmReviewButton.frame = CGRectMake(self.bottomCutOffRule.frame.origin.x + self.bottomCutOffRule.frame.size.width, self.shortCommentaryButton.frame.origin.y, self.shortCommentaryButton.frame.size.width + 1, self.shortCommentaryButton.frame.size.height);
    [self.filmReviewButton setTitle:@"影评" forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
