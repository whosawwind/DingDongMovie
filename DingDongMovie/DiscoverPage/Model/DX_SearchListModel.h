//
//  DX_SearchListModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/19.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_SearchListModel : DX_BaseModel

@property (nonatomic, copy) NSString *title;  /**< 影片中文名*/
@property (nonatomic, copy) NSString *id;  /**< id号*/

@end
