//
//  DX_PopularCommentsModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/12.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_PopularCommentsModel : DX_BaseModel

@property (nonatomic, retain) NSDictionary *author;  /**< 作者信息字典*/
@property (nonatomic, copy) NSString *created_at;  /**< 发布时间*/
@property (nonatomic, copy) NSString *content;  /**< 内容*/
@property (nonatomic, retain) NSDictionary *rating;  /**< 星级字典*/

@end
