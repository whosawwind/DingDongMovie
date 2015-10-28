//
//  DX_VideoListCell.h
//  DingDongMovie
//
//  Created by dllo on 15/9/26.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DX_VideosResourceModel;

typedef void(^videoPlayerCallBack)(NSString *resource_url);

@interface DX_VideoListCell : UICollectionViewCell

@property (nonatomic, retain) DX_VideosResourceModel *videoModel;  /**< Model*/

@property (nonatomic, copy) videoPlayerCallBack videoPlayerCallBackBlock;  /**< Block*/

@end
