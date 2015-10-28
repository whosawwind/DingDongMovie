//
//  DX_DirectorModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_DirectorModel : DX_BaseModel

@property (nonatomic, retain) NSDictionary *avatars;  /**< 照片*/
@property (nonatomic, copy) NSString *name;  /**< 中文名*/
@property (nonatomic, copy) NSString *name_en;  /**< 英文名*/
@property (nonatomic, copy) NSString *birthday;  /**< 生日*/
@property (nonatomic, copy) NSString *born_place;  /**< 出生地*/
@property (nonatomic, retain) NSArray *professions;  /**< 职业*/
@property (nonatomic, copy) NSString *summary;  /**< 简介*/
@property (nonatomic, retain) NSArray *works;  /**< 代表作品*/
@property (nonatomic, copy) NSString *mobile_url;  /**< url*/

@property (nonatomic, assign) BOOL isClickSummary;  /**< 是否点击简介*/

@end
