//
//  DX_GuidePage.h
//  DX_GuidePageDemo
//
//  Created by dllo on 15/9/19.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DX_GuidePage : UIView

@property (nonatomic, retain) UIScrollView *scrollView;  /**< 滚动视图*/
@property (nonatomic, retain) UIPageControl *pageControl;  /**< 分页控制器/*/
@property (nonatomic, retain) UIButton *enterButton;  /**< 进入按钮*/

/**
 *  @brief 获取沙盒版本号
 *
 *  @return 返回沙盒中APP版本号
 */
+ (NSString *)getHomeDirectoryVersionNumber;

/**
 *  @brief 获取当前版本号
 *
 *  @return 返回当前APP版本号
 */
+ (NSString *)getAtPresentVersionNumber;

/**
 *  @brief 存储当前版本号
 *
 *  @param atPresentVersionNumber 传入的当前版本号
 */
+ (void)saveAtPresentVersionNumber:(NSString *)atPresentVersionNumber;

@end
