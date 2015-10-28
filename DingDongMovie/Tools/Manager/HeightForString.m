//
//  HeightForString.m
//  UI09_类似朋友圈
//
//  Created by dllo on 15/8/19.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "HeightForString.h"

@implementation HeightForString

+ (CGFloat)heightWithString:(NSString *)string
                      width:(CGFloat)width
                   fontSize:(CGFloat)fontSize
{
    // 显示的范围, 根据所给定的宽度, 调节高度
    CGSize size = CGSizeMake(width, 10000);
    // 定制字体的容器
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    // 字符串计算高度的方法
    CGRect rect = [string boundingRectWithSize:size
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:dic
                                       context:nil];
    return rect.size.height;
}

@end
