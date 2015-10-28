//
//  DX_MinePageController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/9.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_MinePageController.h"

#import "DX_MovieRecommendCell.h"
#import "DX_DoubleDeckFunctionCell.h"

#import "DX_MovieRecommendController.h"
#import "DX_AboutUsController.h"
#import "DX_MyCollectController.h"

#define HeaderHeight 240 * OffHeight

// 4. 签订协议
@interface DX_MinePageController ()<UITableViewDataSource, UITableViewDelegate, DX_MovieRecommendCellDelegate>

@property (nonatomic, retain) UITableView *mineTableView;  /**< 我的表视图*/

@end

@implementation DX_MinePageController

- (void)dealloc
{
    // 移除关于版块观察者
    NSNotificationCenter *aboutUsCenter = [NSNotificationCenter defaultCenter];
    [aboutUsCenter removeObserver:self];
    
    [_mineTableView release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [GiFHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建我的模块导航
    [self createMineNavigation];
    // 创建我的模块界面
    [self createMinePage];
    
    // 获取 我的收藏版块 通知中心, 注册一个观察者和事件
    NSNotificationCenter *myCollectCenter = [NSNotificationCenter defaultCenter];
    [myCollectCenter addObserver:self
                        selector:@selector(showMyCollectInterface)
                            name:@"myCollectCenter"
                          object:nil];
    
    // 获取 关于版块 通知中心, 注册一个观察者和事件
    NSNotificationCenter *aboutUsCenter = [NSNotificationCenter defaultCenter];
    [aboutUsCenter addObserver:self
                      selector:@selector(showAboutUsInterface)
                          name:@"aboutUsCenter"
                        object:nil];
}

#pragma mark - 关于版块 观察者收到消息后要执行的方法
- (void)showAboutUsInterface
{
    DX_AboutUsController *aboutUsVC = [[DX_AboutUsController alloc] init];
    aboutUsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutUsVC animated:YES];
    [aboutUsVC release];
}

#pragma mark - 我的收藏版块 观察者收到消息后要执行的方法
- (void)showMyCollectInterface
{
    DX_MyCollectController *myCollectVC = [[DX_MyCollectController alloc] init];
    myCollectVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myCollectVC animated:YES];
    [myCollectVC release];
}

#pragma mark - 创建我的模块导航
- (void)createMineNavigation
{
    // 导航主题颜色
    self.navigationController.navigationBar.barTintColor = NavigationColor;
    // 设置导航不透明
    self.navigationController.navigationBar.translucent = NO;
    // 导航字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"我的";
}

#pragma mark - 创建我的模块界面
- (void)createMinePage
{
    self.mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    
    self.mineTableView.delegate = self;
    self.mineTableView.dataSource = self;
    
    // 关闭边界回弹
    self.mineTableView.bounces = NO;
    self.mineTableView.showsVerticalScrollIndicator = NO;
    
    // headerView
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HeaderHeight)];
    headerImageView.image = [UIImage imageNamed:@"dx_minepage_headerimageview"];
    self.mineTableView.tableHeaderView = headerImageView;
    [headerImageView release];
    
    // 注册推荐电影cell
    [self.mineTableView registerClass:[DX_MovieRecommendCell class]
               forCellReuseIdentifier:@"movieRecommendCell"];
    // 注册收藏和夜间模式cell
    [self.mineTableView registerClass:[DX_DoubleDeckFunctionCell class]
               forCellReuseIdentifier:@"collectAndNightModeCell"];
    // 注册清除缓存和关于cell
    [self.mineTableView registerClass:[DX_DoubleDeckFunctionCell class]
               forCellReuseIdentifier:@"clearAwayCacheAndAboutUsCell"];
    
    [self.view addSubview:_mineTableView];
    // 释放
    [_mineTableView release];
}

#pragma mark - UITableViewDataSource
// 分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

// 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DX_MovieRecommendCell *movieRecommendCell = [tableView dequeueReusableCellWithIdentifier:@"movieRecommendCell"];
        // 5. 指定代理人
        movieRecommendCell.delegate = self;
        // cell样式
        [movieRecommendCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return movieRecommendCell;
    } else if (indexPath.section == 1) {
        DX_DoubleDeckFunctionCell *collectAndNightModeCell = [tableView dequeueReusableCellWithIdentifier:@"collectAndNightModeCell"];
        // cell样式
        [collectAndNightModeCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        collectAndNightModeCell.sectionNum = indexPath.section;
        return collectAndNightModeCell;
    } else {
        DX_DoubleDeckFunctionCell *clearAwayCacheAndAboutUsCell = [tableView dequeueReusableCellWithIdentifier:@"clearAwayCacheAndAboutUsCell"];
        // cell样式
        [clearAwayCacheAndAboutUsCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        clearAwayCacheAndAboutUsCell.sectionNum = indexPath.section;
        return clearAwayCacheAndAboutUsCell;
    }
    
}

#pragma mark - UITableViewDelegate
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44 * OffHeight;
    } else {
        return 89 * OffHeight;
    }
}

// 区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7;
}

// cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了cell");
}

#pragma mark - DX_MovieRecommendCellDelegate
// 6. 实现协议方法
- (void)showMovieRecommendInterface
{
    DX_MovieRecommendController *movieRecommendVC = [[DX_MovieRecommendController alloc] init];
    movieRecommendVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:movieRecommendVC animated:YES];
    [movieRecommendVC release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
