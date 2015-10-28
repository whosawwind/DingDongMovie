//
//  CharacterIntroduceCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_CharacterIntroduceCell.h"
#import "DX_MovieDetailsModel.h"

#import "HeightForString.h"

@interface DX_CharacterIntroduceCell ()

@property (nonatomic, retain) UILabel *characterIntroduceLabel;  /**< 文字介绍*/
@property (nonatomic, retain) UIButton *downwardCornerButton;  /**< 向下尖角号*/

@end

@implementation DX_CharacterIntroduceCell

- (void)dealloc
{
    [_movieDetailsModel release];
    [_downwardCornerButton release];
    [_characterIntroduceLabel release];
    [super dealloc];
}

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCharacterIntroduceCell];
    }
    return self;
}

#pragma mark - 创建影片介绍Cell
- (void)createCharacterIntroduceCell
{
    // 文字介绍
    self.characterIntroduceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.characterIntroduceLabel.textColor = [UIColor blackColor];
    self.characterIntroduceLabel.font = [UIFont systemFontOfSize:18];
    self.characterIntroduceLabel.numberOfLines = 0;
    [self.contentView addSubview:_characterIntroduceLabel];
    
    // 向下尖角号
    self.downwardCornerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // 关闭用户交互
    self.downwardCornerButton.userInteractionEnabled = NO;
    [self.downwardCornerButton setImage:[UIImage imageNamed:@"dx_characterintroduce_downwardcorner"]
                               forState:UIControlStateNormal];
    [self.contentView addSubview:_downwardCornerButton];
    
    // 释放
    [_characterIntroduceLabel release];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 剧情简介
    if ([self.movieDetailsModel.summary hasSuffix:@"豆瓣"]) {
        self.movieDetailsModel.summary = [self.movieDetailsModel.summary stringByReplacingCharactersInRange:NSMakeRange(self.movieDetailsModel.summary.length - 2, 2) withString:@"叮咚影讯"];
    }
    
    // 文字高度
    CGFloat characterHeight = [HeightForString heightWithString:self.movieDetailsModel.summary width:self.frame.size.width - 20 fontSize:18];
    
    // 文字介绍
    if (self.movieDetailsModel.isClickSummary) {
        self.characterIntroduceLabel.frame = CGRectMake(10, 10, self.frame.size.width - 20, characterHeight);
        [self.downwardCornerButton setImage:[UIImage imageNamed:@"dx_characterintroduce_upwardcorner"]
                                   forState:UIControlStateNormal];
    } else {
        self.characterIntroduceLabel.frame = CGRectMake(10, 10, self.frame.size.width - 20, 170);
        [self.downwardCornerButton setImage:[UIImage imageNamed:@"dx_characterintroduce_downwardcorner"]
                                   forState:UIControlStateNormal];
    }
    self.characterIntroduceLabel.text = self.movieDetailsModel.summary;
    
    // 向下尖角号
    self.downwardCornerButton.frame = CGRectMake(self.frame.size.width / 2 - 10, self.characterIntroduceLabel.frame.size.height, 30, 30);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
