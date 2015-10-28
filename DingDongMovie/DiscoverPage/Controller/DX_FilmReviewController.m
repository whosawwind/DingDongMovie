//
//  DX_FilmReviewController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_FilmReviewController.h"
#import "DX_DetailsMovieReviewsController.h"

#import "DX_FilmReviewModel.h"

#import "DX_FilmReviewCell.h"

#import "HeightForString.h"

@interface DX_FilmReviewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *filmReviewTableView;  /**< 影评表视图*/
@property (nonatomic, retain) NSMutableArray *filmReviewMutableArray;  /**< 影评数据源*/

@end

@implementation DX_FilmReviewController

- (void)dealloc
{
    [_filmReviewMutableArray release];
    [_filmReviewTableView release];
    [_filmReviewWebURLString release];
    [super dealloc];
}

// 实现返回上一级界面
- (void)leftButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.filmReviewMutableArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 请求数据
- (void)getFilmReviewData
{
    [Network networkGETRequestWithURL:self.filmReviewWebURLString
                            parameter:nil
             pageUniquenessIdentifier:@"FilmReview"
                               result:^(id result) {
        for (NSDictionary *reviewsDic in [(NSDictionary *)result objectForKey:@"reviews"]) {
            DX_FilmReviewModel *filmReviewModel = [[DX_FilmReviewModel alloc] initWithDictionary:reviewsDic];
            [self.filmReviewMutableArray addObject:filmReviewModel];
            [filmReviewModel release];
        }
        if (self.filmReviewMutableArray.count > 0) {
            [self.filmReviewTableView reloadData];
        }
        if (self.filmReviewMutableArray.count == 0) {
            UILabel *withoutFilmReviewInfo = (UILabel *)[self.filmReviewTableView viewWithTag:1000];
            withoutFilmReviewInfo.hidden = NO;
            [self.filmReviewTableView reloadData];
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
    
    self.title = @"影评";
    // 请求数据
    [self getFilmReviewData];
    // 创建影评界面
    [self createFilmReviewInterface];
}

#pragma mark - 创建影评界面
- (void)createFilmReviewInterface
{
    self.filmReviewTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    
    self.filmReviewTableView.delegate = self;
    self.filmReviewTableView.dataSource = self;
    
    // "暂无相关影评信息"提示
    UILabel *withoutFilmReviewInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 200)];
    withoutFilmReviewInfo.tag = 1000;
    withoutFilmReviewInfo.text = @"暂无相关影评信息";
    withoutFilmReviewInfo.textColor = [UIColor grayColor];
    withoutFilmReviewInfo.textAlignment = NSTextAlignmentCenter;
    withoutFilmReviewInfo.hidden = YES;
    [self.filmReviewTableView addSubview:withoutFilmReviewInfo];
    
    // 取消分割线
    self.filmReviewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.filmReviewTableView.showsVerticalScrollIndicator = NO;
    
    // 注册cell
    [self.filmReviewTableView registerClass:[DX_FilmReviewCell class]
                     forCellReuseIdentifier:@"filmReviewCell"];
    
    [self.view addSubview:_filmReviewTableView];
    [_filmReviewTableView release];
}

#pragma mark - UITableViewDataSource
// 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.filmReviewMutableArray.count > 0) {
        return [self.filmReviewMutableArray count];
    }
    return 0;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DX_FilmReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filmReviewCell"];
    DX_FilmReviewModel *filmReviewModel = [self.filmReviewMutableArray objectAtIndex:indexPath.row];
    cell.filmReviewModel = filmReviewModel;
    // cell选中样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableViewDelegate
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DX_FilmReviewModel *shortCommentaryModel = [self.filmReviewMutableArray objectAtIndex:indexPath.row];
    CGFloat rowHeight = [HeightForString heightWithString:shortCommentaryModel.summary
                                                    width:self.view.frame.size.width - 20
                                                 fontSize:16];
    return (rowHeight + 95) * OffHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DX_FilmReviewModel *filmReviewModel = [self.filmReviewMutableArray objectAtIndex:indexPath.row];
    DX_DetailsMovieReviewsController *detailsMovieReviewsVC = [[DX_DetailsMovieReviewsController alloc] init];
    detailsMovieReviewsVC.filmReviewModel = filmReviewModel;
    [self.navigationController pushViewController:detailsMovieReviewsVC animated:YES];
    [detailsMovieReviewsVC release];
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
