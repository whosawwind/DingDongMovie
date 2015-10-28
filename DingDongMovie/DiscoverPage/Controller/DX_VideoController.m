//
//  DX_VideoController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_VideoController.h"

#import "DX_VideosResourceModel.h"

#import "DX_VideoListCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DX_VideoController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) UICollectionView *videoCollectionView;  /**< 视频播放列表*/
/* trailers, bloopers, clips */
@property (nonatomic, retain) NSMutableArray *videosMutableArray;  /**< 预告片视频数组*/

@end

@implementation DX_VideoController

- (void)dealloc
{
    [_videosMutableArray release];
    [_videoCollectionView release];
    [_videoWebURLString release];
    [super dealloc];
}

// 重写父类方法, 实现返回上一级界面
- (void)leftButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化方法
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.videosMutableArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 请求数据
- (void)getVideoData
{
    [Network networkGETRequestWithURL:self.videoWebURLString
                            parameter:nil
             pageUniquenessIdentifier:@"Video"
                               result:^(id result) {
        // 预告片视频数组
        for (NSDictionary *trailersDic in [(NSDictionary *)result objectForKey:@"trailers"]) {
            DX_VideosResourceModel *trailersModel = [[DX_VideosResourceModel alloc] initWithDictionary:trailersDic];
            [self.videosMutableArray addObject:trailersModel];
            [trailersModel release];
        }
        // 片段
        for (NSDictionary *clipsDic in [(NSDictionary *)result objectForKey:@"clips"]) {
            DX_VideosResourceModel *clipsModel = [[DX_VideosResourceModel alloc] initWithDictionary:clipsDic];
            [self.videosMutableArray addObject:clipsModel];
            [clipsModel release];
        }
        // 花絮
        for (NSDictionary *bloopersDic in [(NSDictionary *)result objectForKey:@"bloopers"]) {
            DX_VideosResourceModel *bloopersModel = [[DX_VideosResourceModel alloc] initWithDictionary:bloopersDic];
            [self.videosMutableArray addObject:bloopersModel];
            [bloopersModel release];
        }

        if (self.videosMutableArray.count > 0) {
            [self.videoCollectionView reloadData];
        } else {
            UILabel *videoWithoutHintLabel = (UILabel *)[self.view viewWithTag:1000];
            videoWithoutHintLabel.hidden = NO;
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
    
    self.title = @"预告片";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getVideoData];
    [self createVideoInterface];
    // 创建提示标签
    UILabel *videoWithoutHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    videoWithoutHintLabel.tag = 1000;
    videoWithoutHintLabel.hidden = YES;
    videoWithoutHintLabel.text = @"本部影片没有相关视频";
    videoWithoutHintLabel.textColor = [UIColor grayColor];
    videoWithoutHintLabel.textAlignment = NSTextAlignmentCenter;
    videoWithoutHintLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:videoWithoutHintLabel];
    [videoWithoutHintLabel release];
}

- (void)createVideoInterface
{
    // 创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.videoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:flowLayout];
    self.videoCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.videoCollectionView.dataSource = self;
    self.videoCollectionView.delegate = self;
    
    // 注册item样式
    [self.videoCollectionView registerClass:[DX_VideoListCell class]
                 forCellWithReuseIdentifier:@"videoListCell"];
    
    [self.view addSubview:_videoCollectionView];
    
    // 释放
    [_videoCollectionView release];
    [flowLayout release];
}

#pragma mark - UICollectionViewDataSource
// 每个section中item的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (self.videosMutableArray.count > 0) {
        return [self.videosMutableArray count];
    }
    return 0;
}

// item重用池
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DX_VideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoListCell"
                                                                       forIndexPath:indexPath];
    DX_VideosResourceModel *videoModel = [self.videosMutableArray objectAtIndex:indexPath.item];
    cell.videoModel = videoModel;
    
    cell.videoPlayerCallBackBlock = ^(NSString *resource_url) {
        MPMoviePlayerViewController *moviePlayerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:resource_url]];
        [moviePlayerVC.moviePlayer play];
        [self presentMoviePlayerViewControllerAnimated:moviePlayerVC];
        [moviePlayerVC release];
    };
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
// itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150 * 0.618, 150);
}

// sectionEdge
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 5, 10, 5);
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
