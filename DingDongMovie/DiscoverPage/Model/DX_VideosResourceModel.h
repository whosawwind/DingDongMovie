//
//  DX_TrailersModel.h
//  DingDongMovie
//
//  Created by dllo on 15/9/26.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseModel.h"

@interface DX_VideosResourceModel : DX_BaseModel

@property (nonatomic, copy) NSString *medium;  /**< 图片*/
@property (nonatomic, copy) NSString *title;  /**< 标题*/
@property (nonatomic, copy) NSString *resource_url;  /**< 视频资源URL*/

@end
