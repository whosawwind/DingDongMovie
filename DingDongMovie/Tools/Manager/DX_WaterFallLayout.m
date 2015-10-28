//
//  DX_WaterFallLayout.m
//  DreamRoomage
//
//  Created by dllo on 15/9/16.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_WaterFallLayout.h"

@interface DX_WaterFallLayout()

@property (nonatomic, retain) NSMutableArray *heights;
@property (nonatomic, retain) NSMutableArray *originX;
@property (nonatomic, retain) NSMutableDictionary *itemsArrange;
@property (nonatomic, retain) NSMutableDictionary *itemsInitialArrange;

@end

@implementation DX_WaterFallLayout

#pragma mark - 重写，应 始终调用子类
- (void)prepareLayout
{
    // 如果item 是0 返回
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    if (cellCount == 0) {
        return ;
    }
    // 设置代理人
    self.delegate = (id<WaterLayoutDelegate>)self.collectionView.delegate;
    
    self.itemsArrange = [NSMutableDictionary dictionary];
    self.itemsInitialArrange = [NSMutableDictionary dictionary];
    
    [self initAllarrays];

    for (NSInteger i = 0; i < cellCount; i++) {
        [self layoutForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
}

#pragma 初始化所以数组
- (void)initAllarrays
{
    self.heights = [NSMutableArray array];
    self.originX = [NSMutableArray array];
    // item宽度
    CGFloat itemWidth   = (MobileDevicesScreenWidth - self.sectionInset.left - self.sectionInset.right - (self.lineCount - 1) * self.horizontalSpacing) / self.lineCount;
    
    for (NSInteger i = 0; i < self.lineCount; i++) {
        
        // 循环添加 每行的每个top的点到 height数组中
        [self.heights addObject:[NSNumber numberWithDouble:self.sectionInset.top]];
        
        //设置oringin_x 为0
        CGFloat oringin_x   = 0.0;
        
        if (i == 0) {
         //i = 0 x点 = left;
            oringin_x = self.sectionInset.left;
        } else {
            //  x = i + item宽 + 横向宽度
            oringin_x = [self.originX[i - 1] doubleValue] + itemWidth + self.horizontalSpacing;
        }
         // 把得到的点加到 x数组中
        [self.originX addObject:[NSNumber numberWithDouble: oringin_x]];
    }

}

#pragma mark - itme设置
- (void)layoutForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect rect = CGRectZero;
    // 协议方法
    CGSize size = [self.delegate collectionView:self.collectionView
                                         layout:self
                         sizeForItemAtIndexPath:indexPath];
    
    rect.size.height = size.height;
    
    rect.size.width  = (MobileDevicesScreenWidth - self.sectionInset.left - self.sectionInset.right - (self.lineCount - 1) * self.horizontalSpacing) / self.lineCount;
    
    NSInteger index  = [self getLowerHeightRowIndex:self.heights];
    
    rect.origin.x = [self.originX[index] doubleValue];
    rect.origin.y = [self.heights[index] doubleValue];
    
    CGFloat newHeight = rect.origin.y + rect.size.height + self.verticalSpacing;
    
    [self.heights replaceObjectAtIndex:index withObject:[NSNumber numberWithDouble: newHeight]];
    
    [self.itemsArrange setObject:indexPath forKey:NSStringFromCGRect(rect)];
    
    [self.itemsInitialArrange setObject:indexPath
                                 forKey:NSStringFromCGRect(CGRectMake(rect.origin.x, rect.origin.y - MobileDevicesScreenHeight, rect.size.width, rect.size.height))];
}

#pragma mark - 子类必须重写此方法并使用它来返回的宽度和高度的视图的内容。这些值表示的宽度和高度的所有内容，视图使用此信息来配置其自身内容的大小，以便滚动。
- (CGSize)collectionViewContentSize
{
    
    CGFloat heightest = [self getHeightest:self.heights];
    CGSize size = CGSizeMake(0, heightest);
    return size;
}

#pragma mark - 设置自定义视图
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSArray *keyArr = self.itemsArrange.allKeys;
    
    for (NSString *rectStr in keyArr) {

        if (self.itemsArrange[rectStr] != indexPath) {
            continue;
        }
        
        CGRect rect = CGRectFromString(rectStr);
        
        attributes.frame = rect;
        
        break;
        
    }
    return attributes;
}

#pragma mark - 将这些初始属性到最终显示到view上的设置。
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    // layout特性初始化方法
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
    NSArray *keyArr = self.itemsArrange.allKeys;
    for (NSString *rectStr in keyArr) {
        
        if (self.itemsInitialArrange[rectStr] != itemIndexPath) {
            continue;
        }
        CGRect rect = CGRectFromString(rectStr);
        attributes.frame = rect;
        break;
        
    }
    return attributes;
}

#pragma mark - 布局属性返回数组 视图在给定矩形
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    CGFloat up = rect.origin.y;
    CGFloat down = rect.origin.y + rect.size.height;
    
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSString *rectStr in self.itemsArrange) {
        CGRect itemRect = CGRectFromString(rectStr);
        if (itemRect.origin.y <= down && itemRect.origin.y + itemRect.size.height >= up) {
            NSIndexPath *indexPath = [self.itemsArrange objectForKey:rectStr];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}

# pragma mark - 获取低行高
- (NSInteger)getLowerHeightRowIndex:(NSMutableArray *)height {
    if (height.count == 0) {
        return 0;
    }
    NSInteger index  = 0;
    CGFloat heightest = [height[0] doubleValue];
    for (NSInteger i  = 1; i < height.count; i++) {
        // 判定获取低行位置
        index = heightest > [height[i] doubleValue] ? i : index;
    }
    return index;
}

# pragma mark - 获取最高点
- (CGFloat)getHeightest:(NSMutableArray *)height {
    if (height.count == 0) {
        return 0;
    }
    CGFloat heightest = self.sectionInset.top;
    // 遍历最高点
    for (NSInteger i  = 0; i < height.count; i++) {
        // 如果heightest为最高点返回返回 如果不是则返回height
        heightest  = heightest > [height[i] doubleValue] ? heightest : [height[i] doubleValue];
    }
    return heightest;
}

@end
