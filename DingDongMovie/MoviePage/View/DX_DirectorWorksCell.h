//
//  DX_DirectorWorksCell.h
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^skipMovieDetailsInterface)(NSInteger tag);

@interface DX_DirectorWorksCell : UITableViewCell

@property (nonatomic, retain) NSArray *worksArray;  /**< 相关作品数组*/
@property (nonatomic, copy) skipMovieDetailsInterface skipMovieDetailsBlock;  /**< Block*/

@end
