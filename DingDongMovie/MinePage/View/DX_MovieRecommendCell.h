//
//  DX_MovieRecommendCell.h
//  DingDongMovie
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

// 1. 声明协议
@protocol DX_MovieRecommendCellDelegate <NSObject>

- (void)showMovieRecommendInterface;

@end

@interface DX_MovieRecommendCell : UITableViewCell

// 2. 设置代理人属性
@property (nonatomic, assign) id<DX_MovieRecommendCellDelegate> delegate;

// 3. 通知代理人调用方法
- (void)skipMovieRecommendInterface;

@end
