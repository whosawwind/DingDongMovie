//
//  DX_GuidePage.m
//  DX_GuidePageDemo
//
//  Created by dllo on 15/9/19.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_GuidePage.h"

@interface DX_GuidePage ()

@end

@implementation DX_GuidePage

- (void)dealloc
{
    [_enterButton release];
    [_pageControl release];
    [_scrollView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createGuidePage];
    }
    return self;
}

#pragma mark - 获取沙盒版本号
+ (NSString *)getHomeDirectoryVersionNumber
{
    // 获取NSUserDefaults文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *versionNumber = [userDefaults objectForKey:@"VersionNumber"];
    //    NSLog(@"Library Caches: %@", [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) firstObject]);
    return versionNumber;
}

#pragma mark - 获取当前版本号
+ (NSString *)getAtPresentVersionNumber
{
    // 项目版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return version;
}

#pragma mark - 存储当前版本号
+ (void)saveAtPresentVersionNumber:(NSString *)atPresentVersionNumber
{
    // 获取NSUserDefaults文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 向文件写入版本号
    [userDefaults setObject:atPresentVersionNumber forKey:@"VersionNumber"];
    // 立即同步内容
    [userDefaults synchronize];
}

#pragma mark - 创建引导页
- (void)createGuidePage
{
    // 背景图片
    NSArray *backgroundImagesArray = @[@"dx_guidepage_easy",
                                       @"dx_guidepage_simpleness",
                                       @"dx_guidepage_shortcut",
                                       @"dx_guidepage_ending"];
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    // 分页滚动
    self.scrollView.pagingEnabled = YES;
    // 滚动范围
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * backgroundImagesArray.count, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    // 添加背景图片
    for (int i = 0; i < backgroundImagesArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = [UIImage imageNamed:backgroundImagesArray[i]];
        [self.scrollView addSubview:imageView];
        [imageView release];
    }
    [_scrollView release];
    
    // 分页控制器
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 25, self.frame.size.height - 30, 50, 20)];
    // 未选中点颜色
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    // 当前选中点颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    // 分页点数量
    self.pageControl.numberOfPages = backgroundImagesArray.count;
    [self addSubview:_pageControl];
    [_pageControl release];
    
    // 进入按钮
    self.enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterButton.frame = CGRectMake(self.frame.size.width - 80, self.pageControl.frame.origin.y - 35, 70, 35);
    [self.enterButton setTitle:@"跳过" forState:UIControlStateNormal];
    [self.enterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.enterButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.enterButton.layer.borderWidth = 0.5;
    self.enterButton.layer.cornerRadius = 7;
    [self addSubview:_enterButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
