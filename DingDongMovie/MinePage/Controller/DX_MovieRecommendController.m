//
//  DX_MovieRecommendController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_MovieRecommendController.h"
#import "DX_MovieDetailsController.h"

#import "DX_WaterFallLayout.h"
#import "DX_WaterFallLayoutCell.h"

#import "DX_TopMovieModel.h"

#import "MJRefresh.h"
#import "MBProgressHUD.h"

static int movieNum = 20;  /**< 每次加载的影片数量*/

@interface DX_MovieRecommendController ()<UICollectionViewDataSource, UICollectionViewDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) UICollectionView *movieRecommendCollectionView;  /**< 推荐电影集合视图*/
@property (nonatomic, retain) NSMutableArray *movieRecommendMutableArray;  /**< 推荐电影数据源*/

@end

@implementation DX_MovieRecommendController

- (void)dealloc
{
    [HUD release];
    [_movieRecommendMutableArray release];
    [_movieRecommendCollectionView release];
    [super dealloc];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.movieRecommendMutableArray = [NSMutableArray array];
    }
    return self;
}

// 重写父类方法, 实现返回上一级界面
- (void)leftButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 上拉加载
- (void)pullUpLoad
{
    // 上拉加载
    self.movieRecommendCollectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (movieNum >= 100) {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"已到底部";
            HUD.mode = MBProgressHUDModeText;
            [HUD hide:YES afterDelay:2];
            HUD.dimBackground = NO;
        } else {
            // 检测网络请求是否可到达指定的主机名
            Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
            // currentReachabilityStatus 当前网络请求可到达状态
            switch ([reach currentReachabilityStatus]) {
                case NotReachable:
                {
                    NSLog(@"没有网络连接");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"无网络连接"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
                    break;
                case ReachableViaWiFi:
                    NSLog(@"通过Wifi网络");
                case ReachableViaWWAN:
                    NSLog(@"使用3G / GPRS网络");
                    movieNum += 20;
                    // 请求数据遮挡视图, 即不允许多次上拉加载
                    UIView *requestDataShadeView = [[UIView alloc] initWithFrame:self.view.bounds];
                    requestDataShadeView.tag = 1000;
                    requestDataShadeView.backgroundColor = [UIColor clearColor];
                    [self.view addSubview:requestDataShadeView];
                    [requestDataShadeView release];
                    [self getMovieRecommendData:movieNum];
                    
                    break;
                default:
                    break;
            }
        }
        // 结束刷新
        [self.movieRecommendCollectionView.footer endRefreshing];
    }];
    // 默认先隐藏footer
    self.movieRecommendCollectionView.footer.hidden = YES;
}

// MBProgressHUD持续时间
- (void)durationTime
{
    sleep(1);
}

#pragma mark - 请求数据
- (void)getMovieRecommendData:(NSInteger)filmNum
{
    if (self.movieRecommendMutableArray.count > 0) {
        [self.movieRecommendMutableArray removeAllObjects];
    }
    // 拼接请求数据的接口网址
    NSString *movieRecommendURLString = [NSString stringWithFormat:MovieRecommendAddress, (long)filmNum];
    // 网络请求
    [Network networkGETRequestWithURL:movieRecommendURLString
                            parameter:nil
             pageUniquenessIdentifier:@"MovieRecommend"
                               result:^(id result) {
        for (int i = 0; i < [[(NSDictionary *)result objectForKey:@"subjects"] count]; i++) {
            NSDictionary *subjectsDic = [[(NSDictionary *)result objectForKey:@"subjects"] objectAtIndex:i];
            DX_TopMovieModel *topMovieModel = [[DX_TopMovieModel alloc] initWithDictionary:subjectsDic];
            topMovieModel.filmNum = i + 1;  // 影片排行编号
            [self.movieRecommendMutableArray addObject:topMovieModel];
            [topMovieModel release];
        }
        if ([self.movieRecommendMutableArray count] > 0) {
            // 移除请求数据遮挡视图
            UIView *requestDataShadeView = (UIView *)[self.view viewWithTag:1000];
            [requestDataShadeView removeFromSuperview];
            [self.movieRecommendCollectionView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推荐电影TOP";
    [self createMovieRecommendInterface];
    [self getMovieRecommendData:movieNum];
}

#pragma mark - 创建电影推荐界面
- (void)createMovieRecommendInterface
{
    // 瀑布流布局
    DX_WaterFallLayout *waterFallLayout = [[DX_WaterFallLayout alloc] init];
    // section缩进
    waterFallLayout.sectionInset = UIEdgeInsetsMake(0.04 * MobileDevicesScreenWidth, 10, 10, 10);
    // 间距
    waterFallLayout.verticalSpacing = 10;
    waterFallLayout.horizontalSpacing = 10;
    // 列数
    waterFallLayout.lineCount = 2;
    self.movieRecommendCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:waterFallLayout];
    self.movieRecommendCollectionView.backgroundColor = [UIColor colorWithWhite:0.839 alpha:1.000];
    
    self.movieRecommendCollectionView.delegate = self;
    self.movieRecommendCollectionView.dataSource = self;
    
    [self performSelector:@selector(pullUpLoad) withObject:nil];
    
    // 隐藏滚动条
    self.movieRecommendCollectionView.showsVerticalScrollIndicator = NO;
    
    // 注册cell
    [self.movieRecommendCollectionView registerClass:[DX_WaterFallLayoutCell class] forCellWithReuseIdentifier:@"movieRecommendCell"];
    
    [self.view addSubview:_movieRecommendCollectionView];
    [_movieRecommendCollectionView release];
}

#pragma mark - UICollectionViewDataSource
// 每个section的item数
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if ([self.movieRecommendMutableArray count] > 0) {
        return [self.movieRecommendMutableArray count];
    }
    return 0;
}

// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DX_WaterFallLayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieRecommendCell"
                                                                             forIndexPath:indexPath];
    if (self.movieRecommendMutableArray.count > 0) {
        DX_TopMovieModel *topMovieModel = [self.movieRecommendMutableArray objectAtIndex:indexPath.item];
        cell.topMovieModel = topMovieModel;
    }
    return cell;
}

// 大小 在这里写入数据中保存的宽和高
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((MobileDevicesScreenWidth - 30) / 2,  arc4random() % 200 + 150);
}

#pragma mark - UICollectionViewDelegate
// cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DX_TopMovieModel *topMovieModel = [self.movieRecommendMutableArray objectAtIndex:indexPath.item];
    DX_MovieDetailsController *movieDetailsVC = [[DX_MovieDetailsController alloc] init];
    
    // 拼接接口网址
    NSString *movieDetailsAddress = [NSString stringWithFormat:MovieDetailsAddress, topMovieModel.id];
    movieDetailsVC.movieDetailsWebUrlString = movieDetailsAddress;
    movieDetailsVC.title = topMovieModel.title;
    
    [self.navigationController pushViewController:movieDetailsVC animated:YES];
    [movieDetailsVC release];
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
