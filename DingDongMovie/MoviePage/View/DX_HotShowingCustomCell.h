//
//  DX_HotShowingCustomCell.h
//  DingDongMovie
//
//  Created by dllo on 15/9/10.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DX_HotShowingCustomCell : UICollectionViewCell

@property (nonatomic, retain) UIImageView *filmPosterImageView;  /**< 电影海报*/
@property (nonatomic, retain) UILabel *filmNameLabel;  /**< 影片名称*/
@property (nonatomic, retain) UILabel *filmStarsView;  /**< 星级*/
@property (nonatomic, retain) UILabel *filmGradeLabel;  /**< 影片评价*/

@end
