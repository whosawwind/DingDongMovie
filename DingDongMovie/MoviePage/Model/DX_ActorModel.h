//
//  DX_ActorModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_ActorModel : DX_BaseModel

@property (nonatomic, copy) NSString *name;  /**< 演员姓名*/
@property (nonatomic, retain) NSArray *professions;  /**< 职业数组*/
@property (nonatomic, retain) NSDictionary *avatars;  /**< 照片字典*/
@property (nonatomic, retain) NSArray *photots;  /**< 演员照片数组*/
@property (nonatomic, copy) NSString *birthday;  /**< 出生日期*/
@property (nonatomic, copy) NSString *born_place;  /**< 出生地*/
@property (nonatomic, copy) NSString *name_en;  /**< 演员英文名*/
@property (nonatomic, retain) NSArray *works;  /**< 作品数组*/
@property (nonatomic, copy) NSString *constellation;  /**< 演员星座*/
@property (nonatomic, copy) NSString *summary;  /**< 简介*/
@property (nonatomic, copy) NSString *mobile_url;  /**< url*/

@property (nonatomic, assign) BOOL isClickSummary;  /**< 是否点击简介*/

@end
