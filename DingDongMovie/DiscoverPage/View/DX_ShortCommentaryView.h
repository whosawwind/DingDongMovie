//
//  DX_ShortCommentaryView.h
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DX_ShortCommentaryView : UIView

@property (nonatomic, retain) UIView *filmBackgroundView;  /**< 背景视图*/
@property (nonatomic, retain) UIImageView *usernameImageView;  /**< 用户头像*/
@property (nonatomic, retain) UILabel *usernameLabel;  /**< 用户名称*/
@property (nonatomic, retain) UILabel *starsLabel;  /**< 星级*/
@property (nonatomic, retain) UILabel *contentLabel;  /**< 内容*/

@end
