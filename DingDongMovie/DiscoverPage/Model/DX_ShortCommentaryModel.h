//
//  DX_ShortCommentaryModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_ShortCommentaryModel : DX_BaseModel

@property (nonatomic, retain) NSDictionary *rating;  /**< 星级字典*/
@property (nonatomic, retain) NSDictionary *author;  /**< 作者字典*/
@property (nonatomic, copy) NSString *content;  /**< 内容*/

@end
