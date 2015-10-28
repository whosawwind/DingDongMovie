//
//  HeightForString.h
//  UI09_类似朋友圈
//
//  Created by dllo on 15/8/19.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
// 引入UIKit
#import <UIKit/UIKit.h>

@interface HeightForString : NSObject

/**
 * @brief 根据文本内容计算高度
 *
 * @param string 文本内容
 * @param width 文本宽度
 * @param fontSize 文本字体大小
 * @return 计算的文本高度
 */
+ (CGFloat)heightWithString:(NSString *)string
                      width:(CGFloat)width
                   fontSize:(CGFloat)fontSize;

@end
