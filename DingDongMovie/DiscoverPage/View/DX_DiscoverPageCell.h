//
//  DX_DiscoverPageCell.h
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^transmitButtonContent)(NSInteger tag);

@interface DX_DiscoverPageCell : UITableViewCell

@property (nonatomic, copy) transmitButtonContent transmitButtonContentBlock;  /**< Block*/

@end
