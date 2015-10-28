//
//  Network.m
//  UI18_AFN二次封装
//
//  Created by dllo on 15/8/31.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "Network.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "HUDManager.h"

@implementation Network

+ (void)networkGETRequestWithURL:(NSString *)url
                       parameter:(NSDictionary *)dic
        pageUniquenessIdentifier:(NSString *)pageUniquenessIdentifier
                          result:(void (^)(id))block
{
    // 转码
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    /* Xu's Coding Beginnings */
    // 获取Caches路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    // 创建缓存文件夹
    NSString *dingDongCachesFolderName = [NSString stringWithFormat:@"%@/DingDongCaches", cachesPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    // 判断文件或者目录是否存在, isDirectory传出参数, 用于返回是文件还是目录
    BOOL existed = [fileManager fileExistsAtPath:dingDongCachesFolderName isDirectory:&isDirectory];
    if (!(isDirectory == YES && existed == YES)) {
        [fileManager createDirectoryAtPath:dingDongCachesFolderName
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    // 缓存文件名
    NSString *cachesFileString = [NSString stringWithFormat:@"resultDataCacheFile_%@.plist", pageUniquenessIdentifier];
    // 拼接路径
    NSString *cacheExistPath = [dingDongCachesFolderName stringByAppendingFormat:@"/%@", cachesFileString];
    NSLog(@"Caches: %@", cacheExistPath);
    /* Xu's Coding Ending */
    
    // 判断是否有网
    if ([self isNetworkConnectionAvailable]) {
        // 创建请求对象
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        // 请求HTTPS(若不添加, 无法解析HTTPS)
        manager.securityPolicy.allowInvalidCertificates = YES;
        // 设置请求格式
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 响应格式
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 设置响应的类型
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", nil]];
        
        // 加载指示器
        [HUDManager showStatus];
        
        // GET请求
        /**
         * 参数1: url
         * 参数2: 拼接的body
         * 参数3: 成功块
         * 参数4: 失败块
         */
        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // 转成JSON
            // operation.responseObject请求回的数据(请求回来的真正二进制文件)
            id result = [NSJSONSerialization JSONObjectWithData:operation.responseObject
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
            [HUDManager dismissHUD];
            
            /* Xu's Coding Beginnings */
            [NSKeyedArchiver archiveRootObject:result toFile:cacheExistPath];
            /* Xu's Coding Ending */
            
            block(result);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            /* Xu's Coding Beginnings */
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"加载失败, 数据请求超时!"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            [GiFHUD dismiss];
            /* Xu's Coding Ending */
            // 输出错误信息
            NSLog(@"%@", error);
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"无网络连接"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        /* Xu's Coding Beginnings */
        NSDictionary *takeOutCachesDataDic = [NSKeyedUnarchiver unarchiveObjectWithFile:cacheExistPath];
        if (takeOutCachesDataDic) {
            NSLog(@"无网 --- 有缓存数据");
            block(takeOutCachesDataDic);
        } else {
            NSLog(@"无网 --- 无缓存数据");
        /* Xu's Coding Ending */
        }
    }
}

+ (void)networkPOSTRequestWithURL:(NSString *)url body:(NSString *)body result:(void (^)(id))block
{
    if ([self isNetworkConnectionAvailable]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil]];
        [HUDManager showStatus];
        
        NSArray *bodyArr = [body componentsSeparatedByString:@"&"];
        NSMutableDictionary *bodyDic = [NSMutableDictionary dictionary];
        for (NSString *string in bodyArr) {
            NSArray *tempArr = [string componentsSeparatedByString:@"="];
            [bodyDic setObject:tempArr[1] forKey:tempArr	[0]];
        }
        
        [manager POST:url parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id result = [NSJSONSerialization JSONObjectWithData:operation.responseObject
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
            [HUDManager dismissHUD];
            block(result);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"无网络连接"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

+ (BOOL)isNetworkConnectionAvailable
{
    BOOL WithTheNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
        {
            WithTheNetwork = NO;
            NSLog(@"无网络连接");
        }
            break;
        case ReachableViaWiFi:
        {
            WithTheNetwork = YES;
            NSLog(@"通过WiFi连接");
        }
            break;
        case ReachableViaWWAN:
        {
            WithTheNetwork = YES;
            NSLog(@"通过GPRS网络连接");
        }
            break;
        default:
            break;
    }
    return WithTheNetwork;
}

@end
