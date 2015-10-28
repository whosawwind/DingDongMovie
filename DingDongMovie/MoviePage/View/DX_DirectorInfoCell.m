//
//  DX_DirectorInfoCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_DirectorInfoCell.h"
#import "DX_DirectorModel.h"

#import "UIImageView+WebCache.h"

@interface DX_DirectorInfoCell ()

@property (nonatomic, retain) UIImageView *directorPhoto;  /**< 导演照片*/
@property (nonatomic, retain) UILabel *directorNameLabel;  /**< 导演中文名*/
@property (nonatomic, retain) UILabel *directorNameEnLabel; /**< 导演英文名*/

@end

@implementation DX_DirectorInfoCell

- (void)dealloc
{
    [_directorModel release];
    [_directorNameEnLabel release];
    [_directorNameLabel release];
    [_directorPhoto release];
    [super dealloc];
}

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createDirectorInfoCell];
    }
    return self;
}

#pragma mark - 创建导演简介Cell
- (void)createDirectorInfoCell
{
    // 导演照片
    self.directorPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.directorPhoto.layer.shadowColor = [UIColor grayColor].CGColor;  // 阴影颜色
    self.directorPhoto.layer.shadowOffset = CGSizeMake(0.5, 2);  //阴影偏移
    self.directorPhoto.layer.shadowOpacity = 0.8;  // 阴影透明度
    self.directorPhoto.layer.shadowRadius = 5;  // 阴影半径
    [self.contentView addSubview:_directorPhoto];
    
    // 导演中文名
    self.directorNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.directorNameLabel.textAlignment = NSTextAlignmentLeft;
    self.directorNameLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:_directorNameLabel];
    
    // 导演英文名
    self.directorNameEnLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.directorNameEnLabel.textColor = [UIColor grayColor];
    self.directorNameEnLabel.textAlignment = NSTextAlignmentLeft;
    self.directorNameEnLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_directorNameEnLabel];
    
    // 导演出生日期, 出生地, 职业
    for (int i = 0; i < 3; i++) {
        UILabel *directorInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        directorInfoLabel.tag = 1000 + i;
        directorInfoLabel.textAlignment = NSTextAlignmentLeft;
        directorInfoLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:directorInfoLabel];
        [directorInfoLabel release];
    }
    
    // 释放
    [_directorNameEnLabel release];
    [_directorNameLabel release];
    [_directorPhoto release];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 导演照片
    self.directorPhoto.frame = CGRectMake(10, 10, 120, self.frame.size.height - 20);
    [self.directorPhoto sd_setImageWithURL:[NSURL URLWithString:[self.directorModel.avatars objectForKey:@"large"]]
                          placeholderImage:[UIImage imageNamed:@"dx_moviepage_person_placeholder"]];
    
    // 导演中文名
    self.directorNameLabel.frame = CGRectMake(self.directorPhoto.frame.origin.x + self.directorPhoto.frame.size.width + 10, self.directorPhoto.frame.origin.y, self.frame.size.width - self.directorPhoto.frame.origin.x - self.directorPhoto.frame.size.width - 10 - 10, 44);
    self.directorNameLabel.text = self.directorModel.name;
    
    // 导演英文名
    self.directorNameEnLabel.frame = CGRectMake(self.directorNameLabel.frame.origin.x, self.directorNameLabel.frame.origin.y + self.directorNameLabel.frame.size.height, self.directorNameLabel.frame.size.width, 30);
    self.directorNameEnLabel.text = self.directorModel.name_en;
    
    // 导演的职业数组是否为空
    NSMutableString *directorWorksString = [NSMutableString string];
    if (self.directorModel.professions.count > 0) {
        directorWorksString = [NSMutableString stringWithFormat:@"%@", self.directorModel.professions[0]];
        for (int i = 1; i < [self.directorModel.professions count]; i++) {
            [directorWorksString appendString:[NSString stringWithFormat:@" %@", self.directorModel.professions[i]]];
        }
    } else {
        [directorWorksString appendString:@"暂无相关信息"];
    }
    NSArray *directorInfoArray = [NSArray arrayWithObjects:self.directorModel.birthday, self.directorModel.born_place, directorWorksString, nil];
    
    // 导演出生日期, 出生地, 职业
    for (int i = 0; i < 3; i++) {
        UILabel *directorInfoLabel = (UILabel *)[self viewWithTag:1000 + i];
        directorInfoLabel.frame = CGRectMake(self.directorNameEnLabel.frame.origin.x, self.directorNameEnLabel.frame.origin.y + self.directorNameEnLabel.frame.size.height + 15 + 30 * i, self.directorNameEnLabel.frame.size.width, 30);
        if (i == 1 || i == 2) {
            directorInfoLabel.font = [UIFont systemFontOfSize:15];
        }
        directorInfoLabel.text = directorInfoArray[i];
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
