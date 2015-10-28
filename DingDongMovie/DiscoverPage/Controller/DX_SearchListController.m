//
//  DX_SearchListController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_SearchListController.h"
#import "DX_SearchListModel.h"

#import "DX_VideoController.h"
#import "DX_InteractionController.h"
#import "DX_ShortCommentaryController.h"
#import "DX_FilmReviewController.h"

#import "DX_HistoryQueryRecordCell.h"

#import "WidthForString.h"

@interface DX_SearchListController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) UITableView *filmTableView;  /**< 电影表视图*/
@property (nonatomic, retain) NSMutableArray *filmMutableArray;  /**< 电影数据源*/
@property (nonatomic, copy) NSString *tagFlagString;  /**< tag标记字符串*/
@property (nonatomic, copy) NSString *keywordString;  /**< 关键字*/

@property (nonatomic, retain) NSMutableArray *historyQueryRecordMutableArray;  /**< 查询历史记录数组*/

@end

@implementation DX_SearchListController

- (void)dealloc
{
    [_historyQueryRecordMutableArray release];
    [_keywordString release];
    [_tagFlagString release];
    [_filmMutableArray release];
    [_filmTableView release];
    [super dealloc];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filmMutableArray = [NSMutableArray array];
        self.historyQueryRecordMutableArray = [NSMutableArray array];
    }
    return self;
}

// 重写父类方法, 实现返回上一级界面
- (void)leftButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)getHotShowingMovieData:(NSString *)searchKeyword
{
    // 获取提示标签tag值
    UILabel *hintLabel = (UILabel *)[self.filmTableView viewWithTag:2000];
    hintLabel.hidden = YES;
    hintLabel.text = @"没有查找到您输入的影片";
    // 获取历史记录集合视图tag值
    UICollectionView *historyQueryRecordCollectionView = (UICollectionView *)[self.filmTableView viewWithTag:3000];
    historyQueryRecordCollectionView.hidden = YES;
    // 若查询之前数据源有值, 则清空数据源
    if (self.filmMutableArray.count > 0) {
        [self.filmMutableArray removeAllObjects];
    }
    
    // 拼接网址
    NSString *searchListURLString = [NSString stringWithFormat:SearchListAddress, searchKeyword];
    [Network networkGETRequestWithURL:searchListURLString
                            parameter:nil
             pageUniquenessIdentifier:@"SearchList"
                               result:^(id result) {
        for (NSDictionary *subjectsDic in [(NSDictionary *)result objectForKey:@"subjects"]) {
            DX_SearchListModel *searchListModel = [[DX_SearchListModel alloc] initWithDictionary:subjectsDic];
            [self.filmMutableArray addObject:searchListModel];
            [searchListModel release];
        }
        // 若搜索列表数据源不为空, 隐藏提示标签和历史记录集合视图, 刷新搜索列表
        if ([self.filmMutableArray count] > 0) {
            hintLabel.hidden = YES;
            historyQueryRecordCollectionView.hidden = YES;
            [self.filmTableView reloadData];
        } else {
            // 若搜索列表为空, 显示提示标签
            hintLabel.hidden = NO;
            // 显示历史记录集合视图
            historyQueryRecordCollectionView.hidden = NO;
            // 刷新历史记录集合视图
            [historyQueryRecordCollectionView reloadData];
            // 刷新搜索列表, 即清空上一次搜索的列表
            [self.filmTableView reloadData];
        }
    }];
}

#pragma mark - 获取最近搜索记录
- (void)getHistoryQueryRecordData
{
    // 沙盒Caches路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    // 拼接路径
    NSString *historyQueryRecordPath = [cachesPath stringByAppendingString:@"/DingDongCaches/historyQueryRecord.plist"];
    // 获取数据
    self.historyQueryRecordMutableArray = [NSKeyedUnarchiver unarchiveObjectWithFile:historyQueryRecordPath];
    if (historyQueryRecordPath != nil && self.historyQueryRecordMutableArray.count == 0) {
        self.historyQueryRecordMutableArray = [NSMutableArray array];
    }
}

#pragma mark - 存入历史搜索记录
- (void)saveHistoryQueryRecord
{
    // 沙盒Caches路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    // 拼接路径
    NSString *historyQueryRecordPath = [cachesPath stringByAppendingString:@"/DingDongCaches/historyQueryRecord.plist"];
    // 将数组写入本地
    [NSKeyedArchiver archiveRootObject:self.historyQueryRecordMutableArray
                                toFile:historyQueryRecordPath];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 根据tag值跳转
    switch (self.tagValue) {
        case 1000:
            self.title = @"预告片";
            self.tagFlagString = @"预告片";
            break;
        case 1002:
            self.title = @"短评";
            self.tagFlagString = @"短评";
            break;
        case 1003:
            self.title = @"影评";
            self.tagFlagString = @"影评";
            break;
        default:
            break;
    }
    // 创建电影搜索列表
    [self createFilmList];
    // 获取历史记录
    [self getHistoryQueryRecordData];
}

#pragma mark - 创建电影搜索列表
- (void)createFilmList
{
    self.filmTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    self.filmTableView.delegate = self;
    self.filmTableView.dataSource = self;
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.filmTableView.tableFooterView = footerView;
    [footerView release];
    // 注册cell
    [self.filmTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"filmCell"];

    // 创建SearchBar头部视图
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.tag = 4000;
    searchBar.placeholder = [NSString stringWithFormat:@"请选择您要查看%@的电影", self.tagFlagString];
    searchBar.delegate = self;
    self.filmTableView.tableHeaderView = searchBar;
    [searchBar release];
    
    // 提示标签
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height, self.view.frame.size.width, 100)];
    hintLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    hintLabel.layer.borderWidth = 0.5;
    hintLabel.text = @"请在搜索框输入您要查看的电影";
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.textColor = [UIColor grayColor];
    hintLabel.tag = 2000;
    [self.filmTableView addSubview:hintLabel];
    [hintLabel release];
    
    // 历史记录集合视图
    [self createHistoryQueryRecordInterface];

    [self.view addSubview:_filmTableView];
    [_filmTableView release];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // 若查询字段为空, 显示提示标签和历史记录集合视图
    if ([searchText isEqualToString:@""] || searchText == nil) {
        // 获取提示标签tag值
        UILabel *hintLabel = (UILabel *)[self.filmTableView viewWithTag:2000];
        hintLabel.hidden = NO;
        hintLabel.text = @"请在搜索框输入您要查看的电影";
        // 获取历史记录tag值
        UICollectionView *historyQueryRecordCollectionView = (UICollectionView *)[self.filmTableView viewWithTag:3000];
        historyQueryRecordCollectionView.hidden = NO;
        [historyQueryRecordCollectionView reloadData];
        [self.filmMutableArray removeAllObjects];
        [self.filmTableView reloadData];
    } else {
        self.keywordString = searchText;
        // 去除关键字首尾空格
        self.keywordString = [self.keywordString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        // 请求数据
        [self getHotShowingMovieData:self.keywordString];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if ([self.keywordString isEqualToString:@""] || self.keywordString != nil) {
        for (int i = 0; i < self.historyQueryRecordMutableArray.count; i++) {
            NSLog(@"历史记录数组: %@", self.historyQueryRecordMutableArray[i]);
            if ([self.historyQueryRecordMutableArray[i] isEqualToString:self.keywordString]) {
                [self.historyQueryRecordMutableArray removeObject:self.keywordString];
            }
        }
        // 将查询字段存入历史查询记录数组
        [self.historyQueryRecordMutableArray addObject:self.keywordString];
        [self saveHistoryQueryRecord];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource
// 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.filmMutableArray.count > 0) {
        return self.filmMutableArray.count;
    }
    return 0;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filmCell"];
    DX_SearchListModel *searchListModel = [self.filmMutableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = searchListModel.title;
    cell.textLabel.textColor = [UIColor grayColor];
    NSRange keywordRange = [searchListModel.title rangeOfString:self.keywordString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:searchListModel.title];
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}
                              range:keywordRange];
    cell.textLabel.attributedText = attributedString;
    [attributedString release];
    return cell;
}

#pragma mark - UITableViewDelegate
// 每个分区的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

// TableView点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DX_SearchListModel *searchListModel = [self.filmMutableArray objectAtIndex:indexPath.row];
    NSLog(@"搜索列表: %@", searchListModel.id);
    // 根据tag值跳转
    switch (self.tagValue) {
        case 1000:
        {
            DX_VideoController *videoVC = [[DX_VideoController alloc] init];
            videoVC.hidesBottomBarWhenPushed = YES;
            // 传入预告片网址接口
            videoVC.videoWebURLString = [NSString stringWithFormat:VideoAddress, searchListModel.id];
            [self.navigationController pushViewController:videoVC animated:YES];
            [videoVC release];
        }
            break;
        case 1002:
        {
            DX_ShortCommentaryController *shortCommentaryVC = [[DX_ShortCommentaryController alloc] init];
            shortCommentaryVC.hidesBottomBarWhenPushed = YES;
            // 传入短评网址接口
            shortCommentaryVC.shortCommentaryWebURLString = [NSString stringWithFormat:ShortCommentaryAddress, searchListModel.id];
            [self.navigationController pushViewController:shortCommentaryVC animated:YES];
            [shortCommentaryVC release];
        }
            break;
        case 1003:
        {
            DX_FilmReviewController *filmReviewVC = [[DX_FilmReviewController alloc] init];
            filmReviewVC.hidesBottomBarWhenPushed = YES;
            // 传入影评网址接口
            filmReviewVC.filmReviewWebURLString = [NSString stringWithFormat:FilmReviewAddress, searchListModel.id];
            [self.navigationController pushViewController:filmReviewVC animated:YES];
            [filmReviewVC release];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 创建历史记录界面
- (void)createHistoryQueryRecordInterface
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *historyQueryRecordCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44 + 100, self.view.frame.size.width, self.view.frame.size.height - 64 - 100) collectionViewLayout:flowLayout];
    historyQueryRecordCollectionView.backgroundColor = [UIColor whiteColor];
    historyQueryRecordCollectionView.tag = 3000;
    
    historyQueryRecordCollectionView.hidden = YES;
    flowLayout.minimumInteritemSpacing = 3;
    
    historyQueryRecordCollectionView.dataSource = self;
    historyQueryRecordCollectionView.delegate = self;
    // 注册cell
    [historyQueryRecordCollectionView registerClass:[DX_HistoryQueryRecordCell class] forCellWithReuseIdentifier:@"historyQueryRecordCell"];
    // 注册Header
    [historyQueryRecordCollectionView registerClass:[UICollectionReusableView class]
                         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                withReuseIdentifier:@"Header"];
    
    [self.filmTableView addSubview:historyQueryRecordCollectionView];
    // 释放
    [flowLayout release];
    [historyQueryRecordCollectionView release];
}

#pragma mark -UICollectionViewDataSource
// item数量
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (self.historyQueryRecordMutableArray.count > 0) {
        return self.historyQueryRecordMutableArray.count;
    }
    return 0;
}

// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DX_HistoryQueryRecordCell *historyQueryRecordCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"historyQueryRecordCell" forIndexPath:indexPath];
    historyQueryRecordCell.label.text = [self.historyQueryRecordMutableArray objectAtIndex:indexPath.item];
    return historyQueryRecordCell;
}

// Header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                  withReuseIdentifier:@"Header"
                                                                                         forIndexPath:indexPath];
        
        UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        headerButton.frame = CGRectMake(0, 0, 100, 40);
        [headerButton setTitle:@"最近搜索" forState:UIControlStateNormal];
        [headerButton setImage:[UIImage imageNamed:@"dx_discoverpage_search"]
                      forState:UIControlStateNormal];
        [headerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [headerView addSubview:headerButton];
        
        UIButton *headerEmptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        headerEmptyButton.frame = CGRectMake(self.view.frame.size.width - 50, 0, 50, 40);
        [headerEmptyButton setImage:[UIImage imageNamed:@"dx_discoverpage_searchempty"]
                           forState:UIControlStateNormal];
        [headerEmptyButton setImage:[UIImage imageNamed:@"dx_discoverpage_searchemptyhighlight"]
                           forState:UIControlStateHighlighted];
        [headerEmptyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [headerEmptyButton addTarget:self
                              action:@selector(headerEmptyButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:headerEmptyButton];
        return headerView;
    }
    return nil;
}

#pragma mark - headerEmptyButtonAction点击事件
- (void)headerEmptyButtonAction:(UIButton *)sender
{
    NSLog(@"删除历史记录");
    [self.historyQueryRecordMutableArray removeAllObjects];
    [self saveHistoryQueryRecord];
    // 获取历史记录tag值
    UICollectionView *historyQueryRecordCollectionView = (UICollectionView *)[self.filmTableView viewWithTag:3000];
    [historyQueryRecordCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout
// itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([WidthForString widthWithString:[self.historyQueryRecordMutableArray objectAtIndex:indexPath.item]
                                               height:30
                                             fontSize:17] + 10, 30);
}

// headerSize
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 40);
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [self.historyQueryRecordMutableArray objectAtIndex:indexPath.item];
    NSLog(@"点击 %@", string);
    self.keywordString = string;
    
    UISearchBar *searchBar = (UISearchBar *)[self.filmTableView viewWithTag:4000];
    searchBar.text = self.keywordString;
    // 请求数据
    [self getHotShowingMovieData:self.keywordString];
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
