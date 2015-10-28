//
//  AppDelegate.m
//  DingDongMovie
//
//  Created by dllo on 15/9/8.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "AppDelegate.h"
#import "GuidePageController.h"

#import "MoviePage/Controller/DX_MoviePageController.h"
#import "MinePage/Controller/DX_MinePageController.h"
#import "DiscoverPage/Controller/DX_DiscoverPageController.h"
#import "DX_GuidePage.h"

#import "DX_NightModeSingleton.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()<UIScrollViewDelegate>

@property (nonatomic, retain) DX_GuidePage *guidePage;  /**< 引导页*/
@property (nonatomic, retain) UIView *nightModeView;  /**< 夜间模式*/
@property (nonatomic, retain) GuidePageController *guidePageVC;

@end

@implementation AppDelegate

- (void)dealloc
{
    // 移除 夜间模式 通知中心
    NSNotificationCenter *nightModeCenter = [NSNotificationCenter defaultCenter];
    [nightModeCenter removeObserver:self];
    
    [_guidePageVC release];
    [_nightModeView release];
    [_guidePage release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // 设置分享AppKey
    [UMSocialData setAppKey:AppKey];
    // 设置分享到QQ | Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:AppKey url:@"http://www.mtime.com/"];
    // 设置微信AppId、AppSecret，分享url
    [UMSocialWechatHandler setWXAppId:WechatAppId
                            appSecret:WechatAppSecret
                                  url:@"http://www.mtime.com/"];
    
    // 获得 夜间模式 通知中心, 注册一个观察者和事件
    NSNotificationCenter *nightModeCenter = [NSNotificationCenter defaultCenter];
    [nightModeCenter addObserver:self
                        selector:@selector(nightModeAction)
                            name:@"nightModeCenter"
                          object:nil];
    
#pragma mark - 引导页
    // 获取沙盒版本号
    NSString *homeDirectoryVersionString = [DX_GuidePage getHomeDirectoryVersionNumber];
    // 获取当前版本号
    NSString *atPresentVersionString = [DX_GuidePage getAtPresentVersionNumber];
    // 若沙盒版本号与当前版本号一致, 尚未更新
    if ([homeDirectoryVersionString isEqualToString:atPresentVersionString]) {
        NSLog(@"未更新 --- 显示主页");
        [self createHomePage];
    } else {
        // 存储当前版本号
        [DX_GuidePage saveAtPresentVersionNumber:atPresentVersionString];
        NSLog(@"更新 --- 显示引导页");
        
        self.guidePage = [[DX_GuidePage alloc] initWithFrame:self.window.bounds];
        self.guidePage.scrollView.delegate = self;
        [self.guidePage.enterButton addTarget:self
                                       action:@selector(enterButtonAction:)
                             forControlEvents:UIControlEventTouchUpInside];
        self.guidePageVC = [[GuidePageController alloc] init];
        [self.window setRootViewController:_guidePageVC];
        [self.guidePageVC.view addSubview:_guidePage];
        [_guidePage release];
    }
    return YES;
}

#pragma mark - 添加系统回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - 观察者收到消息后要执行的方法
- (void)nightModeAction
{
    DX_NightModeSingleton *nightMode = [DX_NightModeSingleton shareNightMode];
    if (nightMode.modeTransform) {
        NSLog(@"夜间模式");
        self.nightModeView = [[UIView alloc] initWithFrame:self.window.bounds];
        self.nightModeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.nightModeView.userInteractionEnabled = NO;
        [self.window addSubview:_nightModeView];
        [_nightModeView release];
    } else {
        NSLog(@"日间模式");
        [_nightModeView removeFromSuperview];
    }
}

#pragma mark - 创建主页
- (void)createHomePage
{
    DX_MoviePageController *moviePageVC = [[DX_MoviePageController alloc] init];
    UINavigationController *moviePageNav = [[UINavigationController alloc] initWithRootViewController:moviePageVC];
    // 设置电影模块标签文字和图片
    UIImage *movieImage = [UIImage imageNamed:@"dx_tabbar_movie"];
    UIImage *movieSelectedImage = [UIImage imageNamed:@"dx_tabbar_movieselected"];
    moviePageNav.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"电影"
                                                             image:movieImage
                                                     selectedImage:movieSelectedImage] autorelease];
    // 设置tabBar文字字体
    [moviePageNav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}
                                           forState:UIControlStateNormal];
    
    DX_DiscoverPageController *discoverPageVC = [[DX_DiscoverPageController alloc] init];
    UINavigationController *discoverPageNav = [[UINavigationController alloc] initWithRootViewController:discoverPageVC];
    // 设置发现模块标签文字和图片
    UIImage *discoverImage = [UIImage imageNamed:@"dx_tabbar_bulb"];
    UIImage *discoverSelectedImage = [UIImage imageNamed:@"dx_tabbar_bulbselected"];
    discoverPageNav.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"发现"
                                                                image:discoverImage
                                                        selectedImage:discoverSelectedImage] autorelease];
    // 设置tabBar文字字体
    [discoverPageNav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}
                                              forState:UIControlStateNormal];
    
    DX_MinePageController *minePageVC = [[DX_MinePageController alloc] init];
    UINavigationController *minePageNav = [[UINavigationController alloc] initWithRootViewController:minePageVC];
    // 设置我的模块标签文字和图片
    UIImage *mineImage = [UIImage imageNamed:@"dx_tabbar_mine"];
    UIImage *mineSelectedImage = [UIImage imageNamed:@"dx_tabbar_mineselected"];
    minePageNav.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"我的"
                                                            image:mineImage
                                                    selectedImage:mineSelectedImage] autorelease];
    // 设置tabBar文字字体
    [minePageNav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}
                                          forState:UIControlStateNormal];
    // 管理的导航数组
    NSArray *viewsArray = [NSArray arrayWithObjects:moviePageNav, discoverPageNav, minePageNav, nil];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = viewsArray;
    [self.window setRootViewController:tabBarController];
    
    // 释放
    [tabBarController release];
    [minePageNav release];
    [minePageVC release];
    [discoverPageNav release];
    [discoverPageVC release];
    [moviePageNav release];
    [moviePageVC release];
}

#pragma mark - Button点击事件, 移除引导页并显示主视图控制器
- (void)enterButtonAction:(UIButton *)sender
{
    NSLog(@"跳过");
    [self.guidePage removeFromSuperview];
    [self createHomePage];
}

#pragma mark - 滚动至最后一张图片, 移除引导页并显示主视图控制器
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.guidePage.scrollView.contentOffset.x > self.window.frame.size.width * 3 + self.window.frame.size.width / 3) {
        [self.guidePage removeFromSuperview];
        [self createHomePage];
    }
}

#pragma mark - 滚动视图改变, 分页点随之改变
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.guidePage.pageControl.currentPage = self.guidePage.scrollView.contentOffset.x / (self.guidePage.scrollView.frame.size.width);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
