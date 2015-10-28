//
//  DX_PhotographBrowseController.h
//  DingDongMovie
//
//  Created by dllo on 15/9/26.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseController.h"

@interface DX_PhotographBrowseController : DX_BaseController

@property (nonatomic, retain) NSArray *photosArray;  /**< 图片数组*/
@property (nonatomic, assign) NSInteger photoLocation;  /**< 图片位置*/

@end
