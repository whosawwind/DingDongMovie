//
//  DX_TopMovieModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_TopMovieModel : DX_BaseModel

@property (nonatomic, copy) NSString *title;  /**< 电影中文名*/
@property (nonatomic, copy) NSString *original_title;  /**< 电影英文名*/
@property (nonatomic, retain) NSDictionary *images;  /**< 影片海报*/
@property (nonatomic, copy) NSString *id;  /**< id号*/
@property (nonatomic, assign) int filmNum;  /**< 排名*/

@end
