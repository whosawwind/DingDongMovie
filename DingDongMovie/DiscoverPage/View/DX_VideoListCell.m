//
//  DX_VideoListCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/26.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_VideoListCell.h"

#import "DX_VideosResourceModel.h"

#import "UIButton+WebCache.h"

@interface DX_VideoListCell ()

@property (nonatomic, retain) UIButton *mediumButton;  /**< 视频图片*/
@property (nonatomic, retain) UILabel *titleLabel;  /**< 标题*/

@end

@implementation DX_VideoListCell

- (void)dealloc
{
    Block_release(_videoPlayerCallBackBlock);
    [_titleLabel release];
    [_mediumButton release];
    [_videoModel release];
    [super dealloc];
}

- (void)setVideoModel:(DX_VideosResourceModel *)videoModel
{
    if (_videoModel != videoModel) {
        [_videoModel release];
        _videoModel = [videoModel retain];
    }
    [self.mediumButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.videoModel.medium]
                                           forState:UIControlStateNormal
                                   placeholderImage:[UIImage imageNamed:@"dx_homepage_movieplaceholder"]];
    [self.mediumButton setImage:[UIImage imageNamed:@"dx_discoverpage_play"]
                       forState:UIControlStateNormal];
    self.titleLabel.text = self.videoModel.title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createVideoCell];
    }
    return self;
}

- (void)createVideoCell
{
    self.mediumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = CGRectZero;
    [self.mediumButton addTarget:self
                          action:@selector(mediumButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_mediumButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.backgroundColor = [UIColor colorWithRed:1.000
                                                      green:0.965
                                                       blue:0.820
                                                      alpha:1.000];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:9];
    self.titleLabel.textColor = [UIColor grayColor];
    [self addSubview:_titleLabel];
    
    [_titleLabel release];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.mediumButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20);
    self.titleLabel.frame = CGRectMake(self.mediumButton.frame.origin.x, self.mediumButton.frame.origin.y + self.mediumButton.frame.size.height, self.mediumButton.frame.size.width, 20);
}

// Button点击事件
- (void)mediumButtonAction:(UIButton *)sender
{
    self.videoPlayerCallBackBlock(self.videoModel.resource_url);
}

@end
