//
//  DX_MoviePhotosShowController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_MoviePhotosShowController.h"
#import "DX_PhotographBrowseController.h"

#import "UIImageView+WebCache.h"

#define OneThirdWidth self.view.frame.size.width / 3 - 20

@interface DX_MoviePhotosShowController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) UICollectionView *moviePhotosShowCollectionView;  /**< 照片集合视图*/

@end

@implementation DX_MoviePhotosShowController

- (void)dealloc
{
    [_moviePhotosShowCollectionView release];
    [_photosArray release];
    [super dealloc];
}

// 重写父类左按钮方法, 返回上一级界面
- (void)leftButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 初始化方法
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.photosArray = [NSArray array];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"精选图片";
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建照片墙界面
    if (self.photosArray.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        label.text = @"暂无本部影片精选图片";
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        [label release];
    } else {
        [self createMoviePhotoWallInterface];
    }
    NSLog(@"--- %ld", (unsigned long)self.photosArray.count);
}

#pragma mark - 创建照片墙界面
- (void)createMoviePhotoWallInterface
{
    // 创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 滚动方向垂直
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 最小行间距(垂直于滚动方向为行)
    flowLayout.minimumLineSpacing = 10;
    // 最小列间距(每一行item间距)
    flowLayout.minimumInteritemSpacing = 10;
    
    // 创建集合视图
    self.moviePhotosShowCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:flowLayout];
    self.moviePhotosShowCollectionView.backgroundColor = [UIColor whiteColor];

    self.moviePhotosShowCollectionView.delegate = self;
    self.moviePhotosShowCollectionView.dataSource = self;
    
    // 注册item样式
    [self.moviePhotosShowCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    // 添加至父视图
    [self.view addSubview:_moviePhotosShowCollectionView];
    
    // 释放
    [_moviePhotosShowCollectionView release];
    [flowLayout release];
}

#pragma mark - UICollectionViewDataSource
// section数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.photosArray.count > 0) {
        return 1;
    }
    return 0;
}

// 每个section中的item数量
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (self.photosArray.count > 0) {
        return self.photosArray.count;
    }
    return 0;
}

// item重用池
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell"
                                                                           forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.photosArray[indexPath.item] objectForKey:@"image"]]
                 placeholderImage:[UIImage imageNamed:@"dx_typelabel_vidicon"]];
    cell.backgroundView = imageView;
    [imageView release];
    return cell;
}

#pragma mark - UICollectionViewDelegate
// collectionView点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"--- section: %ld, item: %ld", (long)indexPath.section, (long)indexPath.item);
    DX_PhotographBrowseController *photographBrowseVC = [[DX_PhotographBrowseController alloc] init];
    photographBrowseVC.photosArray = self.photosArray;
    photographBrowseVC.photoLocation = indexPath.item;
    [self.navigationController pushViewController:photographBrowseVC animated:YES];
    [photographBrowseVC release];
}

#pragma mark - UICollectionViewDelegateFlowLayout
// itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(OneThirdWidth, OneThirdWidth);
}

// sectionEdge
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
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
