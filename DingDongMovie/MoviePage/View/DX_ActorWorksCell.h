//
//  DX_ActorWorksCell.h
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DX_ActorModel;

typedef void(^skipMovieDetailsInterface)(NSInteger tag);

@interface DX_ActorWorksCell : UITableViewCell

@property (nonatomic, retain) DX_ActorModel *actorModel;  /**< Model*/
@property (nonatomic, copy) skipMovieDetailsInterface skipMovieDetailsBlock;  /**< Block*/

@end
