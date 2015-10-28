//
//  HUDManager.m
//  UI18_AFN二次封装
//
//  Created by dllo on 15/8/31.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "HUDManager.h"
#import "GiFHUD.h"

@implementation HUDManager

+ (void)showStatus
{
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (int i = 1; i <= 9; i++) {
        NSString *imageName = [NSString stringWithFormat:@"dx_loading000%d", i];
        UIImage *image = [UIImage imageNamed:imageName];
        [imagesArr addObject:image];
    }
    for (int i = 10; i <= 26; i++) {
        NSString *imageName = [NSString stringWithFormat:@"dx_loading00%d", i];
        UIImage *image = [UIImage imageNamed:imageName];
        [imagesArr addObject:image];
    }
    [GiFHUD setGifWithImages:imagesArr];
    [GiFHUD show];
}

+ (void)dismissHUD
{
    [GiFHUD dismiss];
}

@end
