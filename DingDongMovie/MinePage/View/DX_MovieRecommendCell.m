
//
//  DX_MovieRecommendCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_MovieRecommendCell.h"
#import "DX_CustomSettingsButton.h"

@interface DX_MovieRecommendCell ()

@property (nonatomic, retain) DX_CustomSettingsButton *movieRecommendButton;  /**< 推荐电影按钮*/

@end

@implementation DX_MovieRecommendCell

- (void)dealloc
{
    [_movieRecommendButton release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createMovieRecommendCell];
    }
    return self;
}

- (void)createMovieRecommendCell
{
    self.movieRecommendButton = [[DX_CustomSettingsButton alloc] initWithFrame:CGRectMake(0, 0, 375 * OffWidth, 44 * OffHeight)];
    self.movieRecommendButton.tag = 1000;
    self.movieRecommendButton.settingsImageView.image = [UIImage imageNamed:@"dx_minepage_movierecommend"];
    self.movieRecommendButton.settingsLabel.text = @"推荐电影TOP";
    [self.movieRecommendButton addTarget:self
                                  action:@selector(movieRecommendButtonAction:)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_movieRecommendButton];
}

// button点击事件
- (void)movieRecommendButtonAction:(UIButton *)sender
{
    [self skipMovieRecommendInterface];
}

// 3. 通知代理人调用方法
- (void)skipMovieRecommendInterface
{
    [self.delegate showMovieRecommendInterface];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
