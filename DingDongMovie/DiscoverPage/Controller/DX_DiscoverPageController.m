//
//  DX_DiscoverPageController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/9.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_DiscoverPageController.h"
#import "DX_DiscoverPageCell.h"

#import "DX_SearchListController.h"
#import "DX_InteractionController.h"

#import "DX_HeaderView.h"

#import "DX_GaussianBlur.h"

#define WIDTH self.view.frame.size.width
#define HEIGHT 240 * OffHeight

@interface DX_DiscoverPageController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) DX_HeaderView *headerImageView;  /**< HeaderView*/
@property (nonatomic, retain) UITableView *discoverPageTableView;  /**< 发现表视图*/

@end

@implementation DX_DiscoverPageController

- (void)dealloc
{
    [_headerImageView release];
    [_discoverPageTableView release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [GiFHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建发现模块导航
    [self createDiscoverNavigation];
    // 创建发现模块界面
    [self createDiscoverPageInterface];
}

#pragma mark - 创建发现模块导航
- (void)createDiscoverNavigation
{
    // 导航主题颜色
    self.navigationController.navigationBar.barTintColor = NavigationColor;
    
    // 设置导航不透明
    self.navigationController.navigationBar.translucent = NO;
    // 导航字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"发现";
}

#pragma mark - 创建发现模块界面
- (void)createDiscoverPageInterface
{
    self.discoverPageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    
    self.discoverPageTableView.backgroundColor = DiscoverPageBackgroundColor;
    
    self.discoverPageTableView.delegate = self;
    self.discoverPageTableView.dataSource = self;
    
    self.discoverPageTableView.showsVerticalScrollIndicator = NO;
    // headerView
    self.headerImageView = [[DX_HeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.headerImageView.headerView.image = [UIImage imageNamed:@"dx_discoverpage_interactiontitle"];
    self.headerImageView.alphaView.image = [DX_GaussianBlur gaussianBlur:1.0f Image:_headerImageView.headerView.image];
    self.discoverPageTableView.tableHeaderView = self.headerImageView;
    // footerView
    UIImageView *footerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    footerView.image = [UIImage imageNamed:@"dx_discover_bottomofpage"];
    self.discoverPageTableView.tableFooterView = footerView;
    [footerView release];
    
    // 添加至父视图
    [self.view addSubview:_discoverPageTableView];
    // 释放
    [_headerImageView release];
    [_discoverPageTableView release];
}

#pragma mark - UITableViewDataSource
// 分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 每个分区的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *discoverPageCell = @"discoverPageCell";
    DX_DiscoverPageCell *cell = [tableView dequeueReusableCellWithIdentifier:discoverPageCell];
    if (cell == nil) {
        cell = [[[DX_DiscoverPageCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:discoverPageCell] autorelease];
    }
    cell.transmitButtonContentBlock = ^(NSInteger tag) {
        if (tag == 1001) {
            DX_InteractionController *interactionVC = [[DX_InteractionController alloc] init];
            interactionVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:interactionVC animated:YES];
            [interactionVC release];
        } else {
            DX_SearchListController *searchListVC = [[DX_SearchListController alloc] init];
            searchListVC.hidesBottomBarWhenPushed = YES;
            searchListVC.tagValue = tag;
            [self.navigationController pushViewController:searchListVC animated:YES];
            [searchListVC release];
        }
    };
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height / 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.discoverPageTableView) {
        CGFloat dy = scrollView.contentOffset.y;
        if (dy < 0) {
            self.headerImageView.headerView.frame = CGRectMake(-(-(dy) * WIDTH / HEIGHT) / 2, dy, WIDTH - (dy) * WIDTH / HEIGHT, HEIGHT - dy);
            self.headerImageView.alphaView.frame = CGRectMake(-(-(dy) * WIDTH / HEIGHT) / 2, dy, WIDTH - (dy) * WIDTH / HEIGHT, HEIGHT - dy);
        }
        self.headerImageView.alphaView.alpha = (HEIGHT - CGRectGetHeight(self.headerImageView.headerView.frame)) / 60 + 1;
    }
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
