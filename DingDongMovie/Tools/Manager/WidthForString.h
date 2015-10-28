//
//  WidthForString.h
//  UI19_ UICollectionView
//
//  Created by dllo on 15/9/1.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WidthForString : NSObject

+ (CGFloat)widthWithString:(NSString *)string
                    height:(CGFloat)height
                  fontSize:(CGFloat)fontSize;
@end
