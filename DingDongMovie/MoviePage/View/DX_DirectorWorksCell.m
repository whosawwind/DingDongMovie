//
//  DX_DirectorWorksCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_DirectorWorksCell.h"
#import "DX_WorksBriefView.h"

#import "UIImageView+WebCache.h"

#define WORKSNUM 5

@interface DX_DirectorWorksCell ()

@property (nonatomic, retain) UILabel *directorWorkLabel;  /**< 导演作品*/

@end

@implementation DX_DirectorWorksCell

- (void)dealloc
{
    Block_release(_skipMovieDetailsBlock);
    [_directorWorkLabel release];
    [_worksArray release];
    [super dealloc];
}

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createDirectorWorksCell];
    }
    return self;
}

#pragma mark - 创建导演相关作品Cell
- (void)createDirectorWorksCell
{
    // 标题
    self.directorWorkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.directorWorkLabel.frame = CGRectMake(10, 10, 80, 30);
    self.directorWorkLabel.text = @"主要作品";
    self.directorWorkLabel.textAlignment = NSTextAlignmentCenter;
    self.directorWorkLabel.font = MovieDetailsFont;
    [self.contentView addSubview:_directorWorkLabel];
    
    // 循环创建自定义视图, 按照设备屏幕尺寸缩放
    for (int i = 0; i < WORKSNUM; i++) {
        DX_WorksBriefView *worksBriefView = [[DX_WorksBriefView alloc] initWithFrame:CGRectMake(10 * OffWidth, self.directorWorkLabel.frame.origin.y + self.directorWorkLabel.frame.size.height + 10 + 150 * i + 5 * i, (375 - 20) * OffWidth, 150)];
        worksBriefView.tag = 1000 + i;
        [worksBriefView addNewTarget:self action:@selector(skipMovieDetailsAction:)];
        [self.contentView addSubview:worksBriefView];
        [worksBriefView release];
    }
}

#pragma mark - UIView响应点击事件
- (void)skipMovieDetailsAction:(DX_WorksBriefView *)sender
{
    self.skipMovieDetailsBlock(sender.tag - 1000);
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    int i = 0;
    for (i = 0; i < self.worksArray.count; i++) {
        DX_WorksBriefView *worksBriefView = (DX_WorksBriefView *)[self viewWithTag:1000 + i];
        // 取出数组中的作品字典
        NSDictionary *worksDic = self.worksArray[i];
        // 获得作品的海报图片
        NSString *posterURLStr = [[[worksDic objectForKey:@"subject"] objectForKey:@"images"] objectForKey:@"large"];
        [worksBriefView.leftPosterImageView sd_setImageWithURL:[NSURL URLWithString:posterURLStr]
                                              placeholderImage:[UIImage imageNamed:@"dx_defaultimage"]];
        // 电影名
        worksBriefView.filmNameLabel.text = [[worksDic objectForKey:@"subject"] objectForKey:@"title"];
        // 评分
        worksBriefView.filmGradeLabel.text = [NSString stringWithFormat:@"评分: %.1f", [[[[worksDic objectForKey:@"subject"] objectForKey:@"rating"] objectForKey:@"average"] floatValue]];
        // 英文电影名
        worksBriefView.filmEnglishNameLabel.text = [[worksDic objectForKey:@"subject"] objectForKey:@"original_title"];
    }
    if (self.worksArray.count < WORKSNUM) {
        for (int j = i; j < WORKSNUM; j++) {
            DX_WorksBriefView *worksBriefView = (DX_WorksBriefView *)[self viewWithTag:1000 + j];
            [worksBriefView removeFromSuperview];
        }
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
