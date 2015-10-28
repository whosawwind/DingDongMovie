
//
//  DX_ActorInfoCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_ActorInfoCell.h"
#import "DX_ActorModel.h"

#import "UIImageView+WebCache.h"

@interface DX_ActorInfoCell ()

@property (nonatomic, retain) UIImageView *actorPhotoImageView;  /**< 导演照片*/
@property (nonatomic, retain) UILabel *actorNameLabel;  /**< 导演中文名*/
@property (nonatomic, retain) UILabel *actorNameEnLabel; /**< 导演英文名*/

@end

@implementation DX_ActorInfoCell

- (void)dealloc
{
    [_actorNameEnLabel release];
    [_actorNameLabel release];
    [_actorPhotoImageView release];
    [_actorModel release];
    [super dealloc];
}

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createActorInfoCell];
    }
    return self;
}

#pragma mark - 创建演员简介Cell
- (void)createActorInfoCell
{
    // 演员照片
    self.actorPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.actorPhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actorPhotoImageView.layer.borderWidth = 0.5;
    [self.contentView addSubview:_actorPhotoImageView];
    
    // 演员中文名
    self.actorNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.actorNameLabel.textAlignment = NSTextAlignmentLeft;
    self.actorNameLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:_actorNameLabel];
    
    // 演员英文名
    self.actorNameEnLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.actorNameEnLabel.textAlignment = NSTextAlignmentLeft;
    self.actorNameEnLabel.font = [UIFont systemFontOfSize:18];
    self.actorNameEnLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_actorNameEnLabel];
    
    // 演员出生地(星座), 出生日期, 职业
    for (int i = 0; i < 3; i++) {
        UILabel *actorInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        actorInfoLabel.tag = 1000 + i;
        actorInfoLabel.textAlignment = NSTextAlignmentLeft;
        actorInfoLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:actorInfoLabel];
        [actorInfoLabel release];
    }
    
    // 释放
    [_actorNameEnLabel release];
    [_actorNameLabel release];
    [_actorPhotoImageView release];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 演员中文名
    self.actorNameLabel.frame = CGRectMake(10, 10, self.frame.size.width - 30 - 120, 44);
    self.actorNameLabel.text = self.actorModel.name;
    
    // 演员英文名
    self.actorNameEnLabel.frame = CGRectMake(self.actorNameLabel.frame.origin.x, self.actorNameLabel.frame.origin.y + self.actorNameLabel.frame.size.height, self.actorNameLabel.frame.size.width, 30);
    self.actorNameEnLabel.text = self.actorModel.name_en;
    
    // 演员的职业数组是否为空
    // 拼接演员职业
    NSMutableString *actorWorksString = [NSMutableString string];
    if (self.actorModel.professions.count > 0) {
        actorWorksString = [NSMutableString stringWithFormat:@"%@", self.actorModel.professions[0]];
        for (int i = 1; i < [self.actorModel.professions count]; i++) {
            [actorWorksString appendString:[NSString stringWithFormat:@" %@", self.actorModel.professions[i]]];
        }
    } else {
        [actorWorksString appendString:@"暂无相关信息"];
    }
    // 拼接出生日期和星座
    NSString *birthdayAndConstellation = [NSString stringWithFormat:@"%@ %@", self.actorModel.birthday, self.actorModel.constellation];
    NSArray *actorInfoArray = [NSArray arrayWithObjects:self.actorModel.born_place, birthdayAndConstellation, actorWorksString, nil];
    // 演员出生日期, 出生地, 职业
    for (int i = 0; i < 3; i++) {
        UILabel *actorInfoLabel = (UILabel *)[self viewWithTag:1000 + i];
        actorInfoLabel.frame = CGRectMake(self.actorNameEnLabel.frame.origin.x, self.actorNameEnLabel.frame.origin.y + self.actorNameEnLabel.frame.size.height + 15 + 30 * i, self.actorNameEnLabel.frame.size.width, 30);
        actorInfoLabel.text = actorInfoArray[i];
    }
    
    // 演员照片
    self.actorPhotoImageView.frame = CGRectMake(self.actorNameLabel.frame.origin.x + self.actorNameLabel.frame.size.width + 10, self.actorNameLabel.frame.origin.y, 120, self.frame.size.height - 20);
    [self.actorPhotoImageView sd_setImageWithURL:[NSURL URLWithString:[self.actorModel.avatars objectForKey:@"large"]]
                                placeholderImage:[UIImage imageNamed:@"dx_moviepage_person_placeholder"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
