//
//  DX_ActorWorksCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_ActorWorksCell.h"
#import "DX_ActorModel.h"

#import "UIButton+WebCache.h"

#define WORKSNUM 5

@interface DX_ActorWorksCell ()

@property (nonatomic, retain) UILabel *workTitleLabel;  /**< 主要作品标题*/
@property (nonatomic, retain) UIScrollView *scrollView;  /**< 底片滚动视图*/

@end

@implementation DX_ActorWorksCell

- (void)dealloc
{
    [_scrollView release];
    [_workTitleLabel release];
    [_actorModel release];
    [super dealloc];
}

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createActorWorksCell];
    }
    return self;
}

#pragma mark - 创建演员作品Cell
- (void)createActorWorksCell
{
    // 标题
    self.workTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.workTitleLabel.text = @"主要作品";
    self.workTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.workTitleLabel.font = MovieDetailsFont;
    [self.contentView addSubview:_workTitleLabel];
    
    // 底片滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    // 隐藏滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 边界回弹关闭
    self.scrollView.bounces = NO;
    [self.contentView addSubview:_scrollView];
    
    for (int i = 0; i < WORKSNUM; i++) {
        UIButton *workButton = [UIButton buttonWithType:UIButtonTypeCustom];
        workButton.frame = CGRectZero;
        workButton.tag = 1000 + i;
        [workButton addTarget:self
                       action:@selector(workButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:workButton];
        
        for (int j = 0; j < 3; j++) {
            UILabel *workNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            workNameLabel.tag = 2000 + 100 * i + j;
            workNameLabel.textAlignment = NSTextAlignmentCenter;
            if (j == 0) {
                workNameLabel.font = [UIFont systemFontOfSize:15];
            } else if (j == 1) {
                workNameLabel.font = [UIFont systemFontOfSize:13];
                workNameLabel.textColor = [UIColor grayColor];
            } else {
                workNameLabel.textColor = [UIColor grayColor];
            }
            [self.scrollView addSubview:workNameLabel];
            [workNameLabel release];
        }
    }
    
    // 释放
    [_scrollView release];
    [_workTitleLabel release];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 标题
    self.workTitleLabel.frame = CGRectMake(10, 10, 80, 30);
    
    self.scrollView.frame = CGRectMake(0, self.workTitleLabel.frame.origin.y + self.workTitleLabel.frame.size.height, self.frame.size.width, self.frame.size.height - 50);
    // 若作品数组不为空, 创建主要作品
    if ([self.actorModel.works count] > 0) {
        for (int i = 0; i < [self.actorModel.works count]; i++) {
            UIButton *actorWorkButton = (UIButton *)[self.scrollView viewWithTag:1000 + i];
            actorWorkButton.frame = CGRectMake(10 + 140 * i + 10 * i, 10, 140, self.scrollView.frame.size.height - 80);
            
            NSString *imageName = [[[self.actorModel.works[i] objectForKey:@"subject"] objectForKey:@"images" ] objectForKey:@"large"];
            [actorWorkButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageName]
                                                 forState:UIControlStateNormal
                                         placeholderImage:[UIImage imageNamed:@"dx_defaultimage"]];
            
            // 创建相关作品数组(中文名, 英文名, 年份)
            NSString *workChineseName = [[self.actorModel.works[i] objectForKey:@"subject"] objectForKey:@"title"];
            NSString *workEnglishName = [[self.actorModel.works[i] objectForKey:@"subject"] objectForKey:@"original_title"];
            NSString *workYear = [[self.actorModel.works[i] objectForKey:@"subject"] objectForKey:@"year"];
            NSArray *workNameArray = [NSArray arrayWithObjects:workChineseName, workEnglishName, workYear, nil];
            for (int j = 0; j < 3; j++) {
                UILabel *workNameLabel = (UILabel *)[self.scrollView viewWithTag:2000 + 100 * i + j];
                workNameLabel.frame = CGRectMake(actorWorkButton.frame.origin.x, actorWorkButton.frame.origin.y + actorWorkButton.frame.size.height + 20 * j, actorWorkButton.frame.size.width, 20);
                workNameLabel.text = workNameArray[j];
            }
        }
        for (NSInteger i = [self.actorModel.works count]; i < WORKSNUM; i++) {
            UIButton *actorWorkButton = (UIButton *)[self.scrollView viewWithTag:1000 + i];
            [actorWorkButton removeFromSuperview];
        }
        // 设置滚动范围
        self.scrollView.contentSize = CGSizeMake(150 * [self.actorModel.works count] + 10, 0);
    } else {
        UILabel *scrollViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        scrollViewLabel.text = @"暂无相关信息";
        scrollViewLabel.textColor = [UIColor grayColor];
        scrollViewLabel.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:scrollViewLabel];
        [scrollViewLabel release];
    }
}

#pragma mark - Button点击事件
- (void)workButtonAction:(UIButton *)sender
{
    self.skipMovieDetailsBlock(sender.tag - 1000);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
