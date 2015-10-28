//
//  DX_WaterFallLayout.h
//  DreamRoomage
//
//  Created by dllo on 15/9/16.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WaterLayoutDelegate <NSObject>

@required
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface DX_WaterFallLayout : UICollectionViewLayout

@property (nonatomic, assign) id<WaterLayoutDelegate> delegate;  /**< 行数*/
@property (nonatomic, assign) NSInteger lineCount;  /**< 水平点*/
@property (nonatomic, assign) CGFloat verticalSpacing;  /**< 垂直点*/
@property (nonatomic, assign) CGFloat horizontalSpacing;
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@end
