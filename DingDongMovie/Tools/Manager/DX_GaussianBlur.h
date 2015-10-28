//
//  DX_GaussianBlur.h
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DX_GaussianBlur : NSObject

/**
 *  @brief 高斯模糊
 *
 *  @param blur  模糊程度 0.0~1.0
 *  @param image 要模糊处理的图片对象
 *
 *  @return 处理完成后的图片
 */
+ (UIImage *)gaussianBlur:(CGFloat)blur Image:(UIImage *)image;

@end
