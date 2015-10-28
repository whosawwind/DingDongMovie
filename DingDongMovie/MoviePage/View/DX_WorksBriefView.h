//
//  DX_WorksBriefView.h
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DX_WorksBriefView : UIView

@property (nonatomic, retain) UIView *photographicPlateView;  /**< 底片*/
@property (nonatomic, retain) UIImageView *leftPosterImageView;  /**< 左侧海报*/
@property (nonatomic, retain) UILabel *filmNameLabel;  /**< 电影名*/
@property (nonatomic, retain) UILabel *filmGradeLabel;  /**< 评分*/
@property (nonatomic, retain) UILabel *filmEnglishNameLabel;  /**< 电影英文名*/

// 写两个属相用来接收传递过来的target和action
@property (nonatomic, assign) id target;  /**< 目标*/
@property (nonatomic, assign) SEL action;  /**< 动作*/

// 写一个方法用来传递target和action
- (void)addNewTarget:(id)target
              action:(SEL)action;

@end
