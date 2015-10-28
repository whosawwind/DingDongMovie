//
//  DX_MovieDetailsModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/12.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_MovieDetailsModel : DX_BaseModel

@property (nonatomic, retain) NSDictionary *images;  /**< 影片海报*/
@property (nonatomic, copy) NSString *title;  /**< 影片名称*/
@property (nonatomic, retain) NSArray *countries;  /**< 国籍*/
@property (nonatomic ,retain) NSDictionary *rating;  /**< 评分*/
@property (nonatomic, copy) NSString *pubdate;  /**< 上映日期*/
@property (nonatomic, retain) NSArray *durations;  /**< 影片时长*/
@property (nonatomic, retain) NSArray *genres;  /**< 影片类型*/

@property (nonatomic, copy) NSString *summary;  /**< 简介*/

@property (nonatomic, retain) NSArray *directors;  /**< 导演*/
@property (nonatomic, retain) NSArray *casts;  /**< 演员*/

@property (nonatomic, retain) NSArray *clips;  /**< 精选片段*/
@property (nonatomic, retain) NSArray *photos;  /**< 图片*/

@property (nonatomic, retain) NSArray *popular_comments;  /**< 精选评论*/
@property (nonatomic, retain) NSArray *popular_reviews;  /**< 更多评论*/
@property (nonatomic, copy) NSString *mobile_url;  /**< 分享链接*/

@property (nonatomic, assign) BOOL isClickSummary;  /**< 是否点击summary*/

@end
