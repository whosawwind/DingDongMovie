//
//  DX_CollectAndNightModeCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_DoubleDeckFunctionCell.h"
#import "DX_CustomSettingsButton.h"

#import "MBProgressHUD.h"

#import "DX_NightModeSingleton.h"

@interface DX_DoubleDeckFunctionCell ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) DX_CustomSettingsButton *superstratumButton;  /**< 收藏按钮*/
@property (nonatomic, retain) UIView *lineView;  /**< 分割线*/
@property (nonatomic, retain) DX_CustomSettingsButton *substratumButton;  /**< 夜间模式按钮*/

@end

@implementation DX_DoubleDeckFunctionCell

- (void)dealloc
{
    [HUD release];
    [_substratumButton release];
    [_lineView release];
    [_superstratumButton release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createDoubleDeckFunctionCell];
    }
    return self;
}

- (void)createDoubleDeckFunctionCell
{
    // 创建我的收藏 | 清除缓存按钮
    self.superstratumButton = [[DX_CustomSettingsButton alloc] initWithFrame:CGRectMake(0, 0, 375 * OffWidth, 44 * OffHeight)];
    [self.superstratumButton addTarget:self
                                action:@selector(superstratumButtonAction:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_superstratumButton];
    // 创建分割线
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.superstratumButton.frame.origin.y + self.superstratumButton.frame.size.height, (375 - 40) * OffWidth, 1)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_lineView];
    // 创建夜间模式 | 关于按钮
    self.substratumButton = [[DX_CustomSettingsButton alloc] initWithFrame:CGRectMake(self.superstratumButton.frame.origin.x, self.superstratumButton.frame.origin.y + self.superstratumButton.frame.size.height + 1, 375 * OffWidth, 44 * OffHeight)];
    [self.substratumButton addTarget:self
                              action:@selector(substratumButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_substratumButton];
    // 释放
    [_superstratumButton release];
    [_lineView release];
    [_substratumButton release];
}

- (void)superstratumButtonAction:(DX_CustomSettingsButton *)sender
{
    if ([sender.settingsLabel.text isEqualToString:@"我的收藏"]) {
        NSLog(@"我的收藏");
        // 获得 我的收藏 版块消息中心
        NSNotificationCenter *myCollectCenter = [NSNotificationCenter defaultCenter];
        [myCollectCenter postNotificationName:@"myCollectCenter"
                                       object:@"我的收藏"
                                     userInfo:nil];
    } else {
        NSLog(@"清除缓存");
        // 获取Caches路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        // 获取缓存文件夹路径
        NSString *dingDongCachesFolderName = [NSString stringWithFormat:@"%@/DingDongCaches", cachesPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDirectory = NO;
        BOOL existed = [fileManager fileExistsAtPath:dingDongCachesFolderName
                                         isDirectory:&isDirectory];
        // 若不存在, 提示已清空缓存
        if (!(isDirectory == YES && existed == YES)) {
            HUD = [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
            HUD.labelText = @"已清空缓存";
            HUD.mode = MBProgressHUDModeText;
            [HUD hide:YES afterDelay:2];
            HUD.dimBackground = NO;
        } else {
            HUD = [[MBProgressHUD alloc] initWithView:self.contentView];
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dx_minepage_toast"]] autorelease];
            HUD.delegate = self;
            HUD.labelText = @"缓存清除成功";
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD show:YES];
            [HUD hide:YES afterDelay:2];
            [self.contentView addSubview:HUD];
            [fileManager removeItemAtPath:dingDongCachesFolderName error:nil];
        }
    }
}

// MBProgressHUD持续时间
- (void)durationTime
{
    sleep(1);
}

- (void)substratumButtonAction:(DX_CustomSettingsButton *)sender
{
    if ([sender.settingsLabel.text hasSuffix:@"模式"]) {
        NSLog(@"%@", sender.settingsLabel.text);
        // 获取夜间模式单例对象
        DX_NightModeSingleton *nightMode = [DX_NightModeSingleton shareNightMode];
        // 状态取反
        sender.selected = nightMode.modeTransform;
        sender.selected = !sender.selected;
        nightMode.modeTransform = sender.selected;
        // 根据日间|夜间模式进行转换
        if (nightMode.modeTransform) {
            UIImage *daytimeModeImage = [UIImage imageNamed:@"dx_minepage_daytimemode"];
            self.substratumButton.settingsImageView.image = daytimeModeImage;
            self.substratumButton.settingsLabel.text = @"日间模式";
        } else {
            UIImage *nightModeImage = [UIImage imageNamed:@"dx_minepage_nightmode"];
            self.substratumButton.settingsImageView.image = nightModeImage;
            self.substratumButton.settingsLabel.text = @"夜间模式";
        }
        // 获得 夜间模式 消息中心
        NSNotificationCenter *nightModeCenter = [NSNotificationCenter defaultCenter];
        [nightModeCenter postNotificationName:@"nightModeCenter"
                                       object:@"NightMode"
                                     userInfo:nil];
    } else {
        NSLog(@"关于");
        // 获得 关于版块 消息中心
        NSNotificationCenter *aboutUsCenter = [NSNotificationCenter defaultCenter];
        [aboutUsCenter postNotificationName:@"aboutUsCenter"
                                     object:@"关于"
                                   userInfo:nil];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 我的收藏|夜间模式, 赋值
    if (self.sectionNum == 1) {
        UIImage *collectImage = [UIImage imageNamed:@"dx_minepage_lovecollect"];
        self.superstratumButton.settingsImageView.image = collectImage;
        self.superstratumButton.settingsLabel.text = @"我的收藏";
        
        UIImage *nightModeImage = [UIImage imageNamed:@"dx_minepage_nightmode"];
        self.substratumButton.settingsImageView.image = nightModeImage;
        self.substratumButton.settingsLabel.text = @"夜间模式";
    } else {
        UIImage *clearAwayCacheImage = [UIImage imageNamed:@"dx_minepage_clearawaycache"];
        self.superstratumButton.settingsImageView.image = clearAwayCacheImage;
        self.superstratumButton.settingsLabel.text = @"清除缓存";
        
        UIImage *aboutUsImage = [UIImage imageNamed:@"dx_minepage_aboutus"];
        self.substratumButton.settingsImageView.image = aboutUsImage;
        self.substratumButton.settingsLabel.text = @"关于";
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
