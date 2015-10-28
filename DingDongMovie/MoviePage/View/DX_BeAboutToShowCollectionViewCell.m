//
//  DX_BeAboutToShowCollectionViewCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/10.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BeAboutToShowCollectionViewCell.h"
#import "DX_BeAboutToShowTableViewCell.h"

#import "DX_BeAboutToShowModel.h"

#import "DataBaseManager.h"

#import "MJRefresh.h"
#import "DX_DropDownRefreshGIF.h"

@interface DX_BeAboutToShowCollectionViewCell ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *beAboutToShowTableView;  /**< 即将上映电影列表*/
@property (nonatomic, retain) NSMutableArray *beAboutToShowArray;  /**< 即将上映电影数据源*/

@end

@implementation DX_BeAboutToShowCollectionViewCell

- (void)dealloc
{
    [_beAboutToShowArray release];
    [_beAboutToShowTableView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBeAbtouToShowMovieCell];
    }
    return self;
}

#pragma mark - UITableView下拉刷新 动画图片
- (void)pullDownDefaultRefresh
{
    NSLog(@"即将上映 下拉刷新");
    // 设置回调(一旦进入刷新状态, 就调用target的action, 也就是调用self的getBeAboutToShowMoviesData)
    self.beAboutToShowTableView.header = [DX_DropDownRefreshGIF headerWithRefreshingTarget:self
                                                                          refreshingAction:@selector(getBeAboutToShowMoviesData)];
    // 马上进入刷新状态
    [self.beAboutToShowTableView.header beginRefreshing];
}

#pragma mark - 请求数据
- (void)getBeAboutToShowMoviesData
{
    [GiFHUD dismiss];
    // 数组初始化
    self.beAboutToShowArray = [NSMutableArray array];
    // 网络请求, 解析数据
    [Network networkGETRequestWithURL:BeAboutToShowAddress
                            parameter:nil
             pageUniquenessIdentifier:@"BeAboutToShow"
                               result:^(id result) {
        // 1. 创建数据库对象
        DataBaseManager *dataBaseManager = [DataBaseManager shareDataBaseManager];
        // 2. 连接数据库
        [dataBaseManager connectDataBase:@"DingDongDataBase.sqlite"];
        // 3. 查询
        NSArray *collectTempArray = [NSArray arrayWithArray:[dataBaseManager execuateQuerySQL:@"select * from BeAboutToShowMovieInfo"]];
        // 4. 关闭数据库
        [dataBaseManager closeDataBase];
        
        // 转Model
        for (NSDictionary *entriesDic in [(NSDictionary *)result objectForKey:@"entries"]) {
            DX_BeAboutToShowModel *beAboutToShowModel = [[DX_BeAboutToShowModel alloc] initWithDictionary:entriesDic];
            beAboutToShowModel.large = [[entriesDic objectForKey:@"images"] objectForKey:@"large"];
            
            // 收藏标志
            for (int i = 0; i < collectTempArray.count; i++) {
                if ([[collectTempArray[i] objectForKey:@"title"] isEqualToString:beAboutToShowModel.title]) {
                    beAboutToShowModel.wishButtonClickFlag = YES;
                }
            }
            
            [self.beAboutToShowArray addObject:beAboutToShowModel];
            [beAboutToShowModel release];
        }
        
        if ([self.beAboutToShowArray count] > 0) {
            [self.beAboutToShowTableView reloadData];
        }
        // 拿到当前的下拉刷新控件, 结束刷新状态
        [self.beAboutToShowTableView.header endRefreshing];
    }];
}

#pragma mark - 更新收藏标志
- (void)judgeCollectByWishButtonClickFlag
{
    // 1. 创建数据库对象
    DataBaseManager *dataBaseManager = [DataBaseManager shareDataBaseManager];
    // 2. 连接数据库
    [dataBaseManager connectDataBase:@"DingDongDataBase.sqlite"];
    // 3. 查询
    NSArray *collectTempArray = [NSArray arrayWithArray:[dataBaseManager execuateQuerySQL:@"select * from BeAboutToShowMovieInfo"]];
    // 4. 关闭数据库
    [dataBaseManager closeDataBase];
    if (collectTempArray.count == 0) {
        for (int i = 0; i < self.beAboutToShowArray.count; i++) {
            DX_BeAboutToShowModel *beAboutToShowModel = self.beAboutToShowArray[i];
            beAboutToShowModel.wishButtonClickFlag = NO;
            [self.beAboutToShowArray replaceObjectAtIndex:i withObject:beAboutToShowModel];
        }
    } else {
        // 遍历Model
        for (int i = 0; i < self.beAboutToShowArray.count; i++) {
            DX_BeAboutToShowModel *beAboutToShowModel = self.beAboutToShowArray[i];
            // 遍历收藏数组更改收藏标志
            for (int j = 0; j < collectTempArray.count; j++) {
                if ([beAboutToShowModel.title isEqualToString:[collectTempArray[j] objectForKey:@"title"]]) {
                    beAboutToShowModel.wishButtonClickFlag = YES;
                    [self.beAboutToShowArray replaceObjectAtIndex:i withObject:beAboutToShowModel];
                    break;
                } else {
                    beAboutToShowModel.wishButtonClickFlag = NO;
                }
                [self.beAboutToShowArray replaceObjectAtIndex:i withObject:beAboutToShowModel];
            }
        }
    }
    // 刷新即将上映表视图
    if ([self.beAboutToShowArray count] > 0) {
        [self.beAboutToShowTableView reloadData];
    }
}

#pragma mark - 创建即将上映界面
- (void)createBeAbtouToShowMovieCell
{
    self.beAboutToShowArray = [NSMutableArray array];
    
    self.beAboutToShowTableView = [[UITableView alloc] initWithFrame:	CGRectZero
                                                               style:UITableViewStylePlain];
    // 隐藏右侧滚动条
    self.beAboutToShowTableView.showsVerticalScrollIndicator = NO;
    // 设置为无分割线
    self.beAboutToShowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.beAboutToShowTableView.delegate = self;
    self.beAboutToShowTableView.dataSource = self;
    
    [self pullDownDefaultRefresh];
    
    // 添加尾部视图, 解决获取数据之前有横线问题
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.1)];
    self.beAboutToShowTableView.tableFooterView = footerView;
    [footerView release];
    
    [self.contentView addSubview:_beAboutToShowTableView];
    
    [_beAboutToShowTableView release];
}

// item布局
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.beAboutToShowTableView.frame = CGRectMake(0, 20, self.frame.size.width, self.frame.size.height - 45);
}

#pragma mark - UITableViewDataSource
// 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.beAboutToShowArray count] > 0) {
        return [self.beAboutToShowArray count];
    }
    return 0;
}

// cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *beAboutToShowMovieIdentifier = @"beAboutToShowMovieIdentifier";
    DX_BeAboutToShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:beAboutToShowMovieIdentifier];
    if (cell == nil) {
        cell = [[[DX_BeAboutToShowTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                     reuseIdentifier:beAboutToShowMovieIdentifier] autorelease];
    }
    // cell选中样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (self.beAboutToShowArray.count > 0) {
        DX_BeAboutToShowModel *beAboutToShowModel = [self.beAboutToShowArray objectAtIndex:indexPath.row];
        cell.beAboutToShowModel = beAboutToShowModel;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
// 调节每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

// cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击cell");
    if (self.beAboutToShowArray.count > 0) {
        DX_BeAboutToShowModel *beAboutToShowModel = [self.beAboutToShowArray objectAtIndex:indexPath.row];
        NSArray *beAboutToShowArray = [NSArray arrayWithObjects:beAboutToShowModel.id, beAboutToShowModel.title, nil];
        
        // 获得消息中心
        NSNotificationCenter *beAboutToShowCellCenter = [NSNotificationCenter defaultCenter];
        [beAboutToShowCellCenter postNotificationName:@"beAboutToShowCellCenter"
                                               object:beAboutToShowArray
                                             userInfo:nil];
    }
}

@end
