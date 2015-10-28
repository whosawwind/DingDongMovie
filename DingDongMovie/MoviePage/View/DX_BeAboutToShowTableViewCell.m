//
//  DX_BeAboutToShowTableViewCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/10.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BeAboutToShowTableViewCell.h"
#import "DX_BeAboutToShowModel.h"

#import "UIImageView+WebCache.h"

#import "DataBaseManager.h"

@interface DX_BeAboutToShowTableViewCell ()

@property (nonatomic, retain) UIView *bottomView;  /**< 底部图片*/
@property (nonatomic, retain) UIImageView *filmPosterImageView;  /**< 影片海报*/
@property (nonatomic, retain) UILabel *filmNameLabel;  /**< 影片名称*/
@property (nonatomic, retain) UILabel *wishNumberLabel;  /**< 想看数量*/
@property (nonatomic, retain) UILabel *wishTextLabel;  /**< 想看*/
@property (nonatomic, retain) UILabel *showTimeLabel;  /**< 上映时间*/
@property (nonatomic, retain) UIButton *wishButton;  /**< 想看收藏*/

@end

@implementation DX_BeAboutToShowTableViewCell

- (void)dealloc
{
    [_bottomView release];
    [_beAboutToShowModel release];
    [_wishButton release];
    [_showTimeLabel release];
    [_wishNumberLabel release];
    [_filmNameLabel release];
    [_filmPosterImageView release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createBeAboutToShowTableViewCell];
    }
    return self;
}

- (void)createBeAboutToShowTableViewCell
{
    // 底部视图
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = [UIColor colorWithRed:0.835
                                                      green:1.000
                                                       blue:0.997
                                                      alpha:1.000];
    self.bottomView.layer.cornerRadius = 5;
    [self.contentView addSubview:_bottomView];
    
    // 左侧海报
    self.filmPosterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bottomView addSubview:_filmPosterImageView];
    
    // 影片名称
    self.filmNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.filmNameLabel.font = [UIFont systemFontOfSize:20];
    self.filmNameLabel.textColor = [UIColor blackColor];
    self.filmNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:_filmNameLabel];
    
    // 上映时间
    self.showTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.showTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.showTimeLabel.font = [UIFont systemFontOfSize:17];
    self.showTimeLabel.textColor = [UIColor grayColor];
    self.showTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:_showTimeLabel];
    
    // 想看数量
    self.wishNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.wishNumberLabel.font = [UIFont systemFontOfSize:18];
    self.wishNumberLabel.textColor = FilmTypeLabelColor;
    self.wishNumberLabel.textAlignment = NSTextAlignmentRight;
    [self.bottomView addSubview:_wishNumberLabel];
    
    // 想看
    self.wishTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.wishTextLabel.font = [UIFont systemFontOfSize:13];
    self.wishTextLabel.textColor = FilmTypeLabelColor;
    self.wishTextLabel.text = @"人期待";
    self.wishTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:_wishTextLabel];
    
    // 想看收藏
    self.wishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.wishButton.frame = CGRectZero;
    self.wishButton.backgroundColor = [UIColor colorWithRed:0.835
                                                      green:1.000
                                                       blue:0.997
                                                      alpha:1.000];
    self.wishButton.layer.borderColor = [UIColor redColor].CGColor;
    self.wishButton.layer.borderWidth = 0.8;
    self.wishButton.layer.cornerRadius = 5;
    [self.wishButton setTitle:@"想看" forState:UIControlStateNormal];
    [self.wishButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.wishButton setImage:[UIImage imageNamed:@"dx_beabouttoshow_heart"]
                     forState:UIControlStateNormal];
    self.wishButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.wishButton addTarget:self
                        action:@selector(wishButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_wishButton];
    
    // 释放
    [_wishTextLabel release];
    [_wishNumberLabel release];
    [_showTimeLabel release];
    [_filmNameLabel release];
    [_filmPosterImageView release];
    [_bottomView release];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 宽
    CGFloat cellWidth = self.frame.size.width;
    
    // 底部视图
    self.bottomView.frame = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 5);
    
    // 左侧海报
    self.filmPosterImageView.frame = CGRectMake(5, 5, 100, self.frame.size.height - 15);
    NSString *imageName = self.beAboutToShowModel.large;
    [self.filmPosterImageView sd_setImageWithURL:[NSURL URLWithString:imageName]
                                placeholderImage:[UIImage imageNamed:@"dx_homepage_movieplaceholder"]];
    
    // 影片名称
    self.filmNameLabel.frame = CGRectMake(self.filmPosterImageView.frame.origin.x + self.filmPosterImageView.frame.size.width + 10, self.filmPosterImageView.frame.origin.y, cellWidth - self.filmPosterImageView.frame.size.width - 30, 40);
    self.filmNameLabel.text = self.beAboutToShowModel.title;
    
    // 上映日期
    self.showTimeLabel.frame = CGRectMake(self.filmNameLabel.frame.origin.x, self.filmNameLabel.frame.origin.y + self.filmNameLabel.frame.size.height + 5, self.filmNameLabel.frame.size.width, 30);
    self.showTimeLabel.text = [NSString stringWithFormat:@"%@ 上映", self.beAboutToShowModel.pubdate];
    
    // 想看数量
    self.wishNumberLabel.frame = CGRectMake(self.filmNameLabel.frame.origin.x, self.showTimeLabel.frame.origin.y + self.showTimeLabel.frame.size.height + 10, 60, self.filmPosterImageView.frame.size.height - self.filmNameLabel.frame.size.height - self.showTimeLabel.frame.size.height - 15);
    self.wishNumberLabel.text = [NSString stringWithFormat:@"%d", [self.beAboutToShowModel.wish intValue]];
    
    // 想看
    self.wishTextLabel.frame = CGRectMake(self.wishNumberLabel.frame.origin.x + self.wishNumberLabel.frame.size.width, self.wishNumberLabel.frame.origin.y, 40, self.wishNumberLabel.frame.size.height);
    
    // 想看收藏
    self.wishButton.frame = CGRectMake(self.frame.size.width - 80, self.wishNumberLabel.frame.origin.y, 65, self.wishNumberLabel.frame.size.height - 3);
    if (self.beAboutToShowModel.wishButtonClickFlag) {
        [self.wishButton setImage:[UIImage imageNamed:@"dx_beabouttoshow_heartselected"]
                         forState:UIControlStateNormal];
    } else {
        [self.wishButton setImage:[UIImage imageNamed:@"dx_beabouttoshow_heart"]
                         forState:UIControlStateNormal];
    }
}

#pragma mark - wishButtonAction点击事件
- (void)wishButtonAction:(UIButton *)sender
{
    sender.selected = self.beAboutToShowModel.wishButtonClickFlag;
    sender.selected = !sender.selected;
    self.beAboutToShowModel.wishButtonClickFlag = sender.selected;
    
    // 1. 创建数据库对象
    DataBaseManager *dataBaseManager = [DataBaseManager shareDataBaseManager];
    // 2. 连接数据库
    [dataBaseManager connectDataBase:@"DingDongDataBase.sqlite"];
    // 3. 执行SQL语句
    [dataBaseManager executeSQLStatement:@"create table if not exists BeAboutToShowMovieInfo(title text primary key, pubdate text, wish integer, id text, large text)"];
    
    // 选中状态为真
    if (sender.selected) {
        NSLog(@"收藏 %@", self.beAboutToShowModel);
        // 4. 插入
        [dataBaseManager executeSQLStatement:[NSString stringWithFormat:@"insert into BeAboutToShowMovieInfo(title, pubdate, wish, id, large) values('%@', '%@', %@, '%@', '%@')", self.beAboutToShowModel.title, self.beAboutToShowModel.pubdate, self.beAboutToShowModel.wish, self.beAboutToShowModel.id, self.beAboutToShowModel.large]];
        [self.wishButton setImage:[UIImage imageNamed:@"dx_beabouttoshow_heartselected"]
                         forState:UIControlStateNormal];
    } else {
        NSLog(@"取消收藏 %@", self.beAboutToShowModel);
        // 5. 删除
        [dataBaseManager executeSQLStatement:[NSString stringWithFormat:@"delete from BeAboutToShowMovieInfo where id = '%@'", self.beAboutToShowModel.id]];
        [self.wishButton setImage:[UIImage imageNamed:@"dx_beabouttoshow_heart"]
                         forState:UIControlStateNormal];
    }
    // 6. 关闭数据库
    [dataBaseManager closeDataBase];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
