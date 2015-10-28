//
//  WidthForString.m
//  UI19_ UICollectionView
//
//  Created by dllo on 15/9/1.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "WidthForString.h"

@implementation WidthForString

+ (CGFloat)widthWithString:(NSString *)string height:(CGFloat)height fontSize:(CGFloat)fontSize
{
    CGSize size = CGSizeMake(10000, height);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [string boundingRectWithSize:size
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:dic
                                       context:nil];
    return rect.size.width;
}
@end
