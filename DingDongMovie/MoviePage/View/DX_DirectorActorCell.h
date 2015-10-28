//
//  DirectorActorCell.h
//  DingDongMovie
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DX_MovieDetailsModel;
@class DX_ActorsModel;

typedef void(^transmitDirectorInfo)(NSDictionary *directorDic);
typedef void(^transmitActorInfo)(DX_ActorsModel *actorsModel);

@interface DX_DirectorActorCell : UITableViewCell

@property (nonatomic, retain) DX_MovieDetailsModel *movieDetailsModel;  /**< 主Model*/
@property (nonatomic, retain) NSArray *actorsArray;  /**< 演员Model数组*/

@property (nonatomic, copy) transmitDirectorInfo transmitDirectorInfoBlock;  /**< Director Block*/
@property (nonatomic, copy) transmitActorInfo transmitActorInfoBlock;  /**< Actor Block*/

@end
