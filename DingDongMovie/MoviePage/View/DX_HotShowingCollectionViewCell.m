//
//  DX_HotShowingCollectionViewCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/9.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_HotShowingCollectionViewCell.h"
#import "DX_HotShowingCustomCell.h"

#import "DX_HotShowingModel.h"

#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"

#import "DX_MoviePageController.h"
#import "DX_MovieDetailsController.h"

@interface DX_HotShowingCollectionViewCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, retain) UICollectionView *hotShowingMovieCollectionView;  /**< 热映电影集合视图*/
@property (nonatomic, retain) NSMutableArray *hotShowingMovieArray;  /**< 热映电影数据源*/
@property (nonatomic, retain) NSMutableArray *circulationPictureArray;  /**< 轮播图数组*/
@property (nonatomic, retain) NSMutableArray *circulationTextArray;  /**< 轮播图标题*/

@end

@implementation DX_HotShowingCollectionViewCell

- (void)dealloc
{
    [_circulationTextArray release];
    [_circulationPictureArray release];
    [_hotShowingMovieArray release];
    [_hotShowingMovieCollectionView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"初始化方法");
    self = [super initWithFrame:frame];
    if (self) {
        [self createCirculationPicture];
        [self createHotShowingMovieCell];
    }
    return self;
}

#pragma mark - 请求数据
- (void)getHotShowingMoviesData
{
    // 数组初始化
    self.hotShowingMovieArray = [NSMutableArray array];
    self.circulationPictureArray = [NSMutableArray array];
    self.circulationTextArray = [NSMutableArray array];
    // 网络请求, 数据解析
    [Network networkGETRequestWithURL:HotShowingAddress
                            parameter:nil
             pageUniquenessIdentifier:@"HotShowing"
                               result:^(id result) {
        // 转Model
        for (NSDictionary *entriesDic in [(NSDictionary *)result objectForKey:@"entries"]) {
            DX_HotShowingModel *hotShowingModel = [[DX_HotShowingModel alloc] initWithDictionary:entriesDic];
            [self.hotShowingMovieArray addObject:hotShowingModel];
            }

        // 轮播图数组
        for (int i = 0; i < 6; i++) {
            DX_HotShowingModel *model = [self.hotShowingMovieArray objectAtIndex:i];
            [self.circulationPictureArray addObject:[model.images objectForKey:@"large"]];
            [self.circulationTextArray addObject:model.title];
        }
        
        if ([self.hotShowingMovieArray count] > 0) {
            [self createCirculationPicture];
            [self.hotShowingMovieCollectionView reloadData];
        }
    }];
}

#pragma mark - 创建轮播图
- (void)createCirculationPicture
{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 2) imageURLStringsGroup:nil];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.delegate = self;
    cycleScrollView.imageURLStringsGroup = self.circulationPictureArray;
    cycleScrollView.titlesGroup = self.circulationTextArray;
    cycleScrollView.dotColor = FilmTypeLabelColor;
    [self.hotShowingMovieCollectionView addSubview:cycleScrollView];
}

#pragma mark - 创建正在热映界面
- (void)createHotShowingMovieCell
{
    // 创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 滚动方向垂直
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 最小行间距(垂直于滚动方向为行)
    flowLayout.minimumLineSpacing = 1;
    // 最小列间距(每一行item间距)
    flowLayout.minimumInteritemSpacing = 1;
    
    // 创建集合视图对象
    self.hotShowingMovieCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, self.frame.size.height - 45) collectionViewLayout:flowLayout];
    self.hotShowingMovieCollectionView.backgroundColor = [UIColor whiteColor];
    self.hotShowingMovieCollectionView.showsVerticalScrollIndicator = NO;
    
    self.hotShowingMovieCollectionView.delegate = self;
    self.hotShowingMovieCollectionView.dataSource = self;
    
    self.hotShowingMovieCollectionView.bounces = NO;
    // 注册item的样式
    [self.hotShowingMovieCollectionView registerClass:[DX_HotShowingCustomCell class]
                           forCellWithReuseIdentifier:@"HotShowingCustomCell"];
    // 添加至父视图
    [self.contentView addSubview:_hotShowingMovieCollectionView];
    
    // 请求数据
    [self getHotShowingMoviesData];
    
    // 释放
    [_hotShowingMovieCollectionView release];
    [flowLayout release];
}

#pragma mark - UICollectionViewDataSource
// section数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([self.hotShowingMovieArray count] > 0) {
        return 1;
    }
    return 0;
}

// 每个section中的item数量
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if ([self.hotShowingMovieArray count] > 0) {
        return [self.hotShowingMovieArray count];
    }
    return 0;
}

// item重用池
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DX_HotShowingCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotShowingCustomCell"
                                                                              forIndexPath:indexPath];
    // 取hotShowingModel
    DX_HotShowingModel *hotShowingModel = [self.hotShowingMovieArray objectAtIndex:indexPath.item];
    // 电影海报赋值
    NSString *imageName = [hotShowingModel.images objectForKey:@"large"];
    [cell.filmPosterImageView sd_setImageWithURL:[NSURL URLWithString:imageName]
                                placeholderImage:[UIImage imageNamed:@"dx_homepage_movieplaceholder"]];
    // 电影名称赋值
    cell.filmNameLabel.text = hotShowingModel.title;
    // 电影评分
    cell.filmGradeLabel.text = hotShowingModel.rating;
    
    // 计算星级
    for (UIView *starsView in [cell.filmStarsView subviews]) {
        [starsView removeFromSuperview];
    }
    cell.filmStarsView.text = @"";
    CGFloat starsWidth = cell.filmStarsView.frame.size.width / 5;
    
    int starNum = [hotShowingModel.stars intValue] - 5;
    int fullStarNum = starNum / 10;
    int halfStarNum = (starNum - fullStarNum * 10) / 5;
    int emptyStarNum = 5 - fullStarNum - halfStarNum;
    if (starNum >= 0) {
        for (int i = 0; i < fullStarNum; i++) {
            UIImageView *fullStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + starsWidth * i, 0, starsWidth, starsWidth - 2)];
            fullStarImageView.image = [UIImage imageNamed:@"dx_hotshowingcollectionviewcell_star_red"];
            [cell.filmStarsView addSubview:fullStarImageView];
            [fullStarImageView release];
        }
        for (int i = fullStarNum; i < 5 - emptyStarNum; i++) {
            UIImageView *halfStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(fullStarNum * starsWidth + starsWidth * (i - fullStarNum), 0, starsWidth, starsWidth - 2)];
            halfStarImageView.image = [UIImage imageNamed:@"dx_hotshowingcollectionviewcell_star_half"];
            [cell.filmStarsView addSubview:halfStarImageView];
            [halfStarImageView release];
        }
        for (int i = fullStarNum + halfStarNum; i < 5; i++) {
            UIImageView *emptyStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(fullStarNum * starsWidth + halfStarNum * starsWidth + starsWidth * (i - fullStarNum - halfStarNum), 0, starsWidth, starsWidth - 2)];
            emptyStarImageView.image = [UIImage imageNamed:@"dx_hotshowingcollectionviewcell_star_gray"];
            [cell.filmStarsView addSubview:emptyStarImageView];
            [emptyStarImageView release];
        }
    } else {
        cell.filmStarsView.text = @"暂无信息";
        cell.filmStarsView.textColor = [UIColor grayColor];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
// CollectionView点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DX_HotShowingModel *hotShowingModel = [self.hotShowingMovieArray objectAtIndex:indexPath.item];
    NSArray *hotShowingArray = [NSArray arrayWithObjects:hotShowingModel.id, hotShowingModel.title, nil];
    
    // 获得消息中心
    NSNotificationCenter *hotShowingCellCenter = [NSNotificationCenter defaultCenter];
    [hotShowingCellCenter postNotificationName:@"hotShowingCellCenter"
                                        object:hotShowingArray
                                      userInfo:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout
// itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width / 2 - 1, 250);
}

// headerSize
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height / 2);
}

// sectionEdge
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - SDCycleScrollViewDelegate
// 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld张图片", (long)index);
}

@end
