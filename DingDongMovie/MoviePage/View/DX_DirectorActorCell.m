//
//  DirectorActorCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_DirectorActorCell.h"

#import "DX_MovieDetailsModel.h"
#import "DX_ActorsModel.h"

#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@interface DX_DirectorActorCell ()

@property (nonatomic, retain) UILabel *titleLabel;  /**< 标题*/
@property (nonatomic, retain) UILabel *directorLabel;  /**< 导演标签*/
@property (nonatomic, retain) UIButton *directorButton;  /**< 导演*/
@property (nonatomic, retain) UIView *line;  /**< 分割线*/
@property (nonatomic, retain) UILabel *actorLabel;  /**< 演员标签*/

@end

@implementation DX_DirectorActorCell

- (void)dealloc
{
    Block_release(_transmitDirectorInfoBlock);
    Block_release(_transmitActorInfoBlock);
    [_actorsArray release];
    [_movieDetailsModel release];
    [_actorLabel release];
    [_line release];
    [_directorButton release];
    [_directorLabel release];
    [_titleLabel release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createDirectorAndActorCell];
    }
    return self;
}

- (void)createDirectorAndActorCell
{
    // 标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text = @"演职人员";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = MovieDetailsFont;
    [self.contentView addSubview:_titleLabel];
    
    // 导演标签
    self.directorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.directorLabel.text = @"导演";
    self.directorLabel.textAlignment = NSTextAlignmentLeft;
    self.directorLabel.textColor = [UIColor grayColor];
    self.directorLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_directorLabel];
    
    // 导演
    self.directorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.directorButton.frame = CGRectZero;
    self.directorButton.titleLabel.font = [UIFont systemFontOfSize:8];
    [self.directorButton addTarget:self
                            action:@selector(directorButtonAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_directorButton];
    // 导演姓名标签
    for (int i = 0; i < 2; i++) {
        UILabel *directorName = [[UILabel alloc] initWithFrame:CGRectZero];
        directorName.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        directorName.tag = 2000 + i;
        directorName.textColor = FilmTypeLabelColor;
        directorName.textAlignment = NSTextAlignmentCenter;
        directorName.font = [UIFont systemFontOfSize:12];
        directorName.userInteractionEnabled = NO;
        [self.directorButton addSubview:directorName];
    }
    
    // 分割线
    self.line = [[UIView alloc] initWithFrame:CGRectZero];
    self.line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_line];
    
    // 演员标签
    self.actorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.actorLabel.text = @"领衔主演";
    self.actorLabel.textAlignment = NSTextAlignmentLeft;
    self.actorLabel.textColor = [UIColor grayColor];
    self.actorLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_actorLabel];
    
    // 演员
    for (int i = 0; i < 4; i++) {
        UIButton *actorsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actorsButton.frame = CGRectZero;
        actorsButton.tag = 1000 + i;
        [self.contentView addSubview:actorsButton];
        // 演员标签
        for (int j = 0; j < 2; j++) {
            UILabel *actorsNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            actorsNameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
            actorsNameLabel.tag = 1000 + i + 10 * (10 + j);
            actorsNameLabel.textAlignment = NSTextAlignmentCenter;
            actorsNameLabel.textColor = FilmTypeLabelColor;
            actorsNameLabel.font = [UIFont systemFontOfSize:12];
            actorsNameLabel.userInteractionEnabled = NO;
            [actorsButton addSubview:actorsNameLabel];
        }
    }
    
    // 释放
    [_actorLabel release];
    [_line release];
    [_directorLabel release];
    [_titleLabel release];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 标题
    self.titleLabel.frame = CGRectMake(10, 10, 80, 30);
    
    // 导演标签
    self.directorLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, 35, 30);
    
    // 导演
    self.directorButton.frame = CGRectMake(self.directorLabel.frame.origin.x, self.directorLabel.frame.origin.y + self.directorLabel.frame.size.height, 120, self.frame.size.height / 2 + 20);
    // 若导演数组不为空, 创建导演信息Button; 否则显示暂无信息
    if (self.movieDetailsModel.directors.count > 0) {
        UILabel *label = (UILabel *)[self.directorButton viewWithTag:1111];
        label.frame = CGRectMake(0, self.directorButton.frame.size.height - 30, self.directorButton.frame.size.width, 30);
        // 导演照片网址
        NSString *directorImageViewURLString = [NSString string];
        // 判断导演数组avatars字典是否为空
        if ([[[self.movieDetailsModel.directors objectAtIndex:0] objectForKey:@"avatars"] class] == [NSNull class]) {
        } else {
            directorImageViewURLString = [[[self.movieDetailsModel.directors objectAtIndex:0] objectForKey:@"avatars"] objectForKey:@"large"];
        }
        // 获取导演照片
        [self.directorButton sd_setImageWithURL:[NSURL URLWithString:directorImageViewURLString]
                                       forState:UIControlStateNormal
                               placeholderImage:[UIImage imageNamed:@"dx_moviepage_person_placeholder"]];
        // 导演中文, 英文姓名数组
        NSArray *directorNameArray = [NSArray arrayWithObjects:[self.movieDetailsModel.directors[0] objectForKey:@"name"], [self.movieDetailsModel.directors[0] objectForKey:@"name_en"], nil];
        // 导演姓名标签
        for (int i = 0; i < 2; i++) {
            UILabel *directorName = (UILabel *)[self.directorButton viewWithTag:2000 + i];
            directorName.frame = CGRectMake(0, self.directorButton.frame.size.height - 30 + 15 * i, self.directorButton.frame.size.width, 15);
            directorName.text = directorNameArray[i];
            
        }
    } else {
        [self.directorButton setTitle:@"暂无导演信息" forState:UIControlStateNormal];
    }
    
    // 分割线
    self.line.frame = CGRectMake(self.directorButton.frame.origin.x + self.directorButton.frame.size.width + 10, self.directorLabel.frame.origin.y, 1, self.frame.size.height - self.titleLabel.frame.origin.y - self.titleLabel.frame.size.height - 20);
    
    // 演员标签
    self.actorLabel.frame = CGRectMake(self.line.frame.origin.x + self.line.frame.size.width + 10, self.directorLabel.frame.origin.y, 65, self.directorLabel.frame.size.height);
    // 演员照片宽度
    CGFloat actorsButtonWidth = (self.frame.size.width - self.directorButton.frame.size.width - self.line.frame.size.width - 30) / 2;
    // 演员照片赋值
    int actorsPhotosNum = (int)self.actorsArray.count;
    /*
     floor(2.5) = 2
     floor(-2.5) = -3
     ceil(2.5) = 3
     ceil(-2.5) = -2
     */
    // 若演员照片少于2张
    if (actorsPhotosNum <= 2) {
        for (int i = 0; i < (int)actorsPhotosNum; i++) {
            UIButton *actorsButton = (UIButton *)[self viewWithTag:1000 + i];
            actorsButton.frame = CGRectMake(self.actorLabel.frame.origin.x + (actorsButtonWidth - 10) * i + 10 * i, self.actorLabel.frame.origin.y + self.actorLabel.frame.size.height, (actorsButtonWidth - 10), (actorsButtonWidth - 10));
            // 演员照片网址
            NSString *actorsImageView = [[self.actorsArray[i] avatars] objectForKey:@"large"];
            // 获取演员照片
            [actorsButton sd_setImageWithURL:[NSURL URLWithString:actorsImageView]
                                    forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:@"dx_moviepage_person_placeholder"]];
            // 演员中文, 英文标签
            NSArray *actorsNameArray = [NSArray arrayWithObjects:[self.actorsArray[i] name], [self.actorsArray[i] name_en],  nil];
            for (int j = 0; j < actorsPhotosNum; j++) {
                UILabel *actorsNameLabel = (UILabel *)[actorsButton viewWithTag:1000 + i + 10 * (10 + j)];
                actorsNameLabel.frame = CGRectMake(0, actorsButton.frame.size.height - 30 + 15 * j, actorsButton.frame.size.width, 15);
                actorsNameLabel.text = actorsNameArray[j];
            }
        }
    } else {
        for (int i = 0; i < (int)ceil(actorsPhotosNum / 2.0); i++) {
            UIButton *actorsButton = (UIButton *)[self viewWithTag:1000 + i];
            actorsButton.frame = CGRectMake(self.actorLabel.frame.origin.x + (actorsButtonWidth - 10) * i + 10 * i, self.actorLabel.frame.origin.y + self.actorLabel.frame.size.height, (actorsButtonWidth - 10), (actorsButtonWidth - 10));
            // 添加点击事件
            [actorsButton addTarget:self
                             action:@selector(actorsButtonAction:)
                   forControlEvents:UIControlEventTouchUpInside];
            // 演员照片网址
            NSString *actorsImageView = [[self.actorsArray[i] avatars] objectForKey:@"large"];
            // 获取演员照片
            [actorsButton sd_setImageWithURL:[NSURL URLWithString:actorsImageView]
                                    forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:@"dx_moviepage_person_placeholder"]];
            // 演员中文, 英文标签
            NSArray *actorsNameArray = [NSArray arrayWithObjects:[self.actorsArray[i] name], [self.actorsArray[i] name_en],  nil];
            for (int j = 0; j < actorsPhotosNum - 2; j++) {
                UILabel *actorsNameLabel = (UILabel *)[actorsButton viewWithTag:1000 + i + 10 * (10 + j)];
                actorsNameLabel.frame = CGRectMake(0, actorsButton.frame.size.height - 30 + 15 * j, actorsButton.frame.size.width, 15);
                actorsNameLabel.text = actorsNameArray[j];
            }
        }
        for (int i = (int)ceil(actorsPhotosNum / 2.0); i < actorsPhotosNum; i++) {
            UIButton *actorsButton = (UIButton *)[self viewWithTag:1000 + i];
            actorsButton.frame = CGRectMake(self.actorLabel.frame.origin.x + (actorsButtonWidth - 10) * (i - 2) + 10 * (i - 2), self.actorLabel.frame.origin.y + self.actorLabel.frame.size.height + actorsButtonWidth + 2, (actorsButtonWidth - 10), (actorsButtonWidth - 10));
            // 添加点击事件
            [actorsButton addTarget:self
                             action:@selector(actorsButtonAction:)
                   forControlEvents:UIControlEventTouchUpInside];
            // 演员照片网址
            NSString *actorsImageView = [[self.actorsArray[i] avatars] objectForKey:@"large"];
            // 获取演员照片
            [actorsButton sd_setImageWithURL:[NSURL URLWithString:actorsImageView]
                                    forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:@"dx_moviepage_person_placeholder"]];
            // 演员中文, 英文标签
            NSArray *actorsNameArray = [NSArray arrayWithObjects:[self.actorsArray[i] name], [self.actorsArray[i] name_en],  nil];
            for (int j = 0; j < actorsPhotosNum - 2; j++) {
                UILabel *actorsNameLabel = (UILabel *)[actorsButton viewWithTag:1000 + i + 10 * (10 + j)];
                actorsNameLabel.frame = CGRectMake(0, actorsButton.frame.size.height - 30 + 15 * j, actorsButton.frame.size.width, 15);
                actorsNameLabel.text = actorsNameArray[j];
            }
        }
    }
}

#pragma mark - directorButtonAction
- (void)directorButtonAction:(UIButton *)sender
{
    NSLog(@"点击导演%ld", (long)sender.tag);
    self.transmitDirectorInfoBlock(self.movieDetailsModel.directors[0]);
}

#pragma mark - actorsButtonAction
- (void)actorsButtonAction:(UIButton *)sender
{
    NSLog(@"点击演员%ld", (long)sender.tag);
    self.transmitActorInfoBlock(self.actorsArray[sender.tag - 1000]);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
