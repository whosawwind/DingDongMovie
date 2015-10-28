//
//  DX_FilmReviewModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/16.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_FilmReviewModel : DX_BaseModel

@property (nonatomic, copy) NSString *title;  /**< 影评标题*/
@property (nonatomic, retain) NSDictionary *rating;  /**< 星级字典*/
@property (nonatomic, retain) NSDictionary *author;  /**< 作者信息字典*/
@property (nonatomic, copy) NSString *summary;  /**< 简介*/
@property (nonatomic, copy) NSString *content;  /**< 内容*/
@property (nonatomic, copy) NSString *alt;  /**< 影评链接*/

@end
