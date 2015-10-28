//
//  DX_FilmReviewsCell.h
//  DingDongMovie
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DX_MovieDetailsModel;
@class DX_PopularCommentsModel;

@interface DX_FilmReviewsCell : UITableViewCell

@property (nonatomic, retain) DX_MovieDetailsModel *movieDetailsModel;  /**< 主Model*/
@property (nonatomic, retain) NSArray *popularCommentsArray;  /**< Model*/

@end
