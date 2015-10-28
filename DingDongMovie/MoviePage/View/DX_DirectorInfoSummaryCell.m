//
//  DX_DirectorInfoSummaryCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_DirectorInfoSummaryCell.h"
#import "DX_DirectorModel.h"
#import "DX_ActorModel.h"

#import "HeightForString.h"

@interface DX_DirectorInfoSummaryCell ()

@property (nonatomic, retain) UILabel *summaryLabel;  /**< 简介*/

@end

@implementation DX_DirectorInfoSummaryCell

- (void)dealloc
{
    [_directorModel release];
    [_summaryLabel release];
    [super dealloc];
}

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createDirectorInfoSummaryCell];
    }
    return self;
}

#pragma mark - 创建导演简介Cell
- (void)createDirectorInfoSummaryCell
{
    // 简介
    self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.summaryLabel.backgroundColor = DirectorCardColor;
    self.summaryLabel.textAlignment = NSTextAlignmentLeft;
    self.summaryLabel.numberOfLines = 0;
    [self.contentView addSubview:_summaryLabel];
    
    // 释放
    [_summaryLabel release];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.directorModel.summary length] > 0) {
        // 简介
        CGFloat summaryHeight = [HeightForString heightWithString:self.directorModel.summary width:self.frame.size.width - 20 fontSize:17];
        if (self.directorModel.isClickSummary) {
            self.summaryLabel.frame = CGRectMake(10, 10, self.frame.size.width - 20, summaryHeight);
        } else {
            self.summaryLabel.frame = CGRectMake(10, 10, self.frame.size.width - 20, 80);
        }
        self.summaryLabel.text = self.directorModel.summary;
    } else {
        self.summaryLabel.frame = CGRectMake(10, 10, self.frame.size.width - 20, 80);
        self.summaryLabel.text = @"暂无相关信息";
        self.summaryLabel.textColor = [UIColor grayColor];
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
