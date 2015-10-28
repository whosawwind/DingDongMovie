//
//  DX_HotShowingModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/10.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_HotShowingModel : DX_BaseModel

@property (nonatomic, copy) NSString *rating;  /**< 评分*/
@property (nonatomic, copy) NSString *stars;  /**< 星级*/
@property (nonatomic, copy) NSString *title;  /**< 电影名称*/
@property (nonatomic, retain) NSDictionary *images;  /**< 图片字典*/
@property (nonatomic, copy) NSString *id;  /**< id号*/

@end
