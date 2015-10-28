//
//  DX_BeAboutToShowModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_BeAboutToShowModel : DX_BaseModel

@property (nonatomic, copy) NSString *large;  /**< 海报图片数组*/
@property (nonatomic, copy) NSString *title;  /**< 电影名称*/
@property (nonatomic, copy) NSString *pubdate;  /**< 上映日期*/
@property (nonatomic, retain) NSNumber *wish;  /**< 期待观看*/
@property (nonatomic, copy) NSString *id;  /**< id号*/

@property (nonatomic, assign) BOOL wishButtonClickFlag;  /**< 收藏标志*/

@end
