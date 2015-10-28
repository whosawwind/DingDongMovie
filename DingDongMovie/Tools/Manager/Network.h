//
//  Network.h
//  UI18_AFN二次封装
//
//  Created by dllo on 15/8/31.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject

/**
 * @brief GET网络请求
 *
 * @param url 请求网址
 * @param dic 拼接的body
 * @param pageUniquenessIdentifier 页面唯一标示符
 * @param block 返回请求结果
 */
+ (void)networkGETRequestWithURL:(NSString *)url
                       parameter:(NSDictionary *)dic
        pageUniquenessIdentifier:(NSString *)pageUniquenessIdentifier
                          result:(void(^)(id result))block;

/**
 * @brief POST网络请求
 * 
 * @param url 请求网址
 * @param body 拼接的body
 * @param block 返回请求结果
 */
+ (void)networkPOSTRequestWithURL:(NSString *)url
                             body:(NSString *)body
                           result:(void(^)(id result))block;

/**
 * @brief 判断网络状态
 *
 * @return YES 有网 NO 无网
 */
+ (BOOL)isNetworkConnectionAvailable;

@end
