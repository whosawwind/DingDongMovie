//
//  DX_ActorsModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/12.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_ActorsModel : DX_BaseModel

@property (nonatomic, retain) NSDictionary *avatars;  /**< 演员照片字典*/
@property (nonatomic, copy) NSString *name;  /**< 演员中文名*/
@property (nonatomic, copy) NSString *name_en;  /**< 演员英文名*/
@property (nonatomic, copy) NSString *id;  /**< id号*/

@end
