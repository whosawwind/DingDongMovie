//
//  DX_MoviePageController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/9.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_MoviePageController.h"

#import "DX_HotShowingCollectionViewCell.h"
#import "DX_BeAboutToShowCollectionViewCell.h"

#import "DX_MovieDetailsController.h"

#define NAVIGATIONLEFTBUTTONTAG 1001
#define NAVIGATIONRIGHTBUTTONTAG 1002

@interface DX_MoviePageController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, retain) UICollectionView *movieCollectionView;  /**< 集合视图*/
@property (nonatomic, retain) UIView *line;  /**< 中间竖线*/
@property (nonatomic, retain) NSMutableArray *buttonsArray;  /**< 按钮数组*/
@property (nonatomic, retain) UIView *scrollBar;  /**< 滚动条*/

@end

@implementation DX_MoviePageController

- (void)dealloc
{
    // 移除 正在热映 观察者
    NSNotificationCenter *hotShowingCellCenter = [NSNotificationCenter defaultCenter];
    [hotShowingCellCenter removeObserver:self];
    
    // 移除 即将上映 观察者
    NSNotificationCenter *beAboutToShowCellCenter = [NSNotificationCenter defaultCenter];
    [beAboutToShowCellCenter removeObserver:self];
    
    [_scrollBar release];
    [_buttonsArray release];
    [_line release];
    [_movieCollectionView release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 显示辅助导航视图
    UIButton *navigationLeftButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:NAVIGATIONLEFTBUTTONTAG];
    UIButton *navigationRightButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:NAVIGATIONRIGHTBUTTONTAG];
    navigationLeftButton.hidden = NO;
    navigationRightButton.hidden = NO;
    self.line.hidden = NO;
    self.scrollBar.hidden = NO;
    
    // 刷新 即将上映 表视图
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    DX_BeAboutToShowCollectionViewCell *beAboutToShowCell = (DX_BeAboutToShowCollectionViewCell *)[self.movieCollectionView cellForItemAtIndexPath:indexPath];
    [beAboutToShowCell judgeCollectByWishButtonClickFlag];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 创建电影界面
    [self createMovieInterface];
    
    // 注册观察者和事件, 正在热映
    NSNotificationCenter *hotShowingCellCenter = [NSNotificationCenter defaultCenter];
    [hotShowingCellCenter addObserver:self
                             selector:@selector(showCellCenterAction:)
                                 name:@"hotShowingCellCenter"
                               object:nil];
    
    // 注册观察者和事件, 即将上映
    NSNotificationCenter *beAboutToShowCellCenter = [NSNotificationCenter defaultCenter];
    [beAboutToShowCellCenter addObserver:self
                                selector:@selector(showCellCenterAction:)
                                    name:@"beAboutToShowCellCenter"
                                  object:nil];
}

#pragma mark - 观察者收到消息后执行的方法
- (void)showCellCenterAction:(id)object
{
    DX_MovieDetailsController *movieDetailsVC = [[DX_MovieDetailsController alloc] init];

    NSString *movieDetailsAddress = [NSString stringWithFormat:MovieDetailsAddress, [object object][0]];
    NSLog(@"MOVIEPAGE ID: %@", [object object][0]);
    // 将拼接后的接口网址传入下一级界面
    movieDetailsVC.movieDetailsWebUrlString = movieDetailsAddress;
    movieDetailsVC.title = [object object][1];
    movieDetailsVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:movieDetailsVC animated:YES];
    
    [movieDetailsVC release];
}

#pragma mark - 创建电影模块首级界面
- (void)createMovieInterface
{
    // 创建顶部导航视图
    [self createAssistantNavigationView];
    
    // 创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 滚动方向水平
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 创建CollectionView
    self.movieCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
    self.movieCollectionView.backgroundColor = [UIColor whiteColor];
    self.movieCollectionView.tag = 1000;
    
    // 边界回弹关闭
    self.movieCollectionView.bounces = NO;
    // 分页
    self.movieCollectionView.pagingEnabled = YES;
    
    self.movieCollectionView.dataSource = self;
    self.movieCollectionView.delegate = self;
    
    // 注册item的样式
    [self.movieCollectionView registerClass:[DX_HotShowingCollectionViewCell class]
                 forCellWithReuseIdentifier:@"HotShowingCollectionViewCell"];
    [self.movieCollectionView registerClass:[DX_BeAboutToShowCollectionViewCell class]
                 forCellWithReuseIdentifier:@"BeAboutToShowCollectionViewCell"];
    
    // 添加至父视图
    [self.view addSubview:_movieCollectionView];
    
    // 释放
    [_movieCollectionView release];
    [flowLayout release];
}

#pragma mark - 创建辅助导航视图
- (void)createAssistantNavigationView
{
    // 宽度
    CGFloat assistantNavigationWidth = self.view.frame.size.width / 2;
    NSArray *buttonsTitleArray = @[@"正在热映", @"即将上映"];
    self.buttonsArray = [NSMutableArray array];
    // 创建Button导航按钮
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0 + assistantNavigationWidth * i, 0, assistantNavigationWidth, 44);
        button.backgroundColor = NavigationColor;
        button.tag = NAVIGATIONLEFTBUTTONTAG + i;
        [button setTitle:buttonsTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (button.tag == NAVIGATIONLEFTBUTTONTAG) {
            [button setTitleColor:FilmTypeLabelColor forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button addTarget:self
                   action:@selector(buttonActionCheck:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:button];
        [_buttonsArray addObject:button];
    }
    // 创建中间竖线
    self.line = [[UIView alloc] initWithFrame:CGRectMake(assistantNavigationWidth + 1, 3, 1, 38)];
    self.line.backgroundColor = [UIColor lightGrayColor];
    [self.navigationController.navigationBar addSubview:_line];
    // 创建滚动条
    self.scrollBar = [[UIView alloc] initWithFrame:CGRectMake(20, 41, assistantNavigationWidth - 40, 3)];
    self.scrollBar.backgroundColor = FilmTypeLabelColor;
    self.scrollBar.layer.cornerRadius = 5;
    [self.navigationController.navigationBar addSubview:_scrollBar];
    // 释放
    [_scrollBar release];
    [_line release];
}

// 辅助导航点击事件, 切换窗口
- (void)buttonActionCheck:(UIButton *)sender
{
    for (UIButton *button in self.buttonsArray) {
        if (button.tag == sender.tag) {
            [button setTitleColor:FilmTypeLabelColor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    UICollectionView *collectionView = (UICollectionView *)[self.view viewWithTag:1000];
    if (sender.tag == 1002) {
        collectionView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    } else {
        collectionView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark - UICollectionViewDataSource
// section数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

// 每个section中的item数量
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

// item重用池
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DX_HotShowingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotShowingCollectionViewCell" forIndexPath:indexPath];
        return cell;
    } else {
        DX_BeAboutToShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BeAboutToShowCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
// itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height - 64);
}

// section缩进
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(-64, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegate
// cell将要出现时添加动画
- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    CATransition *transition = [CATransition animation];
    // 通过类型来选择动画效果 @"reveal"显露效果(将旧视图移开,显示下面的新视图)
    transition.type = @"reveal";
    // 动画时间
    transition.duration = 1.5f;
    // 是否还原效果
    transition.autoreverses = NO;
    // 添加到layer
    [cell.layer addAnimation:transition forKey:@"asd"];
}

#pragma mark - UIScrollViewDelegate
// 滚动视图偏移量改变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= MobileDevicesScreenWidth) {
        // 滚动条动画
        [UIView animateWithDuration:0.5 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            self.scrollBar.frame = CGRectMake(self.view.frame.size.width / 2 + 20, 41, self.view.frame.size.width / 2 - 40, 3);
        } completion:^(BOOL finished) {
        }];
        UIButton *leftButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:1001];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *rightButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:1002];
        [rightButton setTitleColor:FilmTypeLabelColor forState:UIControlStateNormal];
    }
    if (scrollView.contentOffset.x <= 0) {
        // 滚动条动画
        [UIView animateWithDuration:0.5 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            self.scrollBar.frame = CGRectMake(20, 41, self.view.frame.size.width / 2 - 40, 3);
        } completion:^(BOOL finished) {
        }];
        UIButton *leftButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:1001];
        [leftButton setTitleColor:FilmTypeLabelColor forState:UIControlStateNormal];
        UIButton *rightButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:1002];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark - 视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 隐藏辅助导航视图
    UIButton *navigationLeftButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:NAVIGATIONLEFTBUTTONTAG];
    UIButton *navigationRightButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:NAVIGATIONRIGHTBUTTONTAG];
    navigationLeftButton.hidden = YES;
    navigationRightButton.hidden = YES;
    self.line.hidden = YES;
    self.scrollBar.hidden = YES;
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
