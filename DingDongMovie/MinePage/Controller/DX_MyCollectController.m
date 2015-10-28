//
//  DX_MyCollectController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_MyCollectController.h"
#import "DX_BeAboutToShowTableViewCell.h"
#import "DX_MovieDetailsController.h"

#import "DX_BeAboutToShowModel.h"

#import "DataBaseManager.h"

@interface DX_MyCollectController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *myCollectTableView;  /**< 收藏表视图*/
@property (nonatomic, retain) NSMutableArray *myCollectMutableArray;  /**< 收藏数据源*/

@end

@implementation DX_MyCollectController

- (void)dealloc
{
    [_myCollectMutableArray release];
    [_myCollectTableView release];
    [super dealloc];
}

// 重写父类方法, 实现返回上一级界面
- (void)leftButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.myCollectMutableArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 从数据库获取我地收藏
- (void)getMyCollectDataFromDataBase
{
    // 1. 创建数据库对象
    DataBaseManager *dataBaseManager = [DataBaseManager shareDataBaseManager];
    // 2. 连接数据库
    [dataBaseManager connectDataBase:@"DingDongDataBase.sqlite"];
    // 3. 查询
    NSArray *myCollectionTempArray = [NSArray arrayWithArray:[dataBaseManager execuateQuerySQL:@"select * from BeAboutToShowMovieInfo"]];
    // 4. 关闭数据库
    [dataBaseManager closeDataBase];
    // 收藏信息存入数据源
    for (NSDictionary *myCollectionTempDic in myCollectionTempArray) {
        DX_BeAboutToShowModel *beAboutToShowModel = [[DX_BeAboutToShowModel alloc] initWithDictionary:myCollectionTempDic];
        beAboutToShowModel.wishButtonClickFlag = YES;
        [self.myCollectMutableArray addObject:beAboutToShowModel];
        [beAboutToShowModel release];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 从数据库获取数据
    [self getMyCollectDataFromDataBase];
    if (self.myCollectMutableArray.count > 0) {
        // 创建我的收藏界面
        [self createMyCollectInterface];
    } else {
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        hintLabel.text = @"没有收藏任何内容";
        hintLabel.textColor = [UIColor grayColor];
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.font = [UIFont systemFontOfSize:20];
        [self.view addSubview:hintLabel];
        [hintLabel release];
    }
}

#pragma mark - 创建我的收藏板块界面
- (void)createMyCollectInterface
{
    self.myCollectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    
    self.myCollectTableView.delegate = self;
    self.myCollectTableView.dataSource = self;
    
    // tableFooterView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.myCollectTableView.tableFooterView = footerView;
    [footerView release];
    
    // 注册cell
    [self.myCollectTableView registerClass:[DX_BeAboutToShowTableViewCell class]
                    forCellReuseIdentifier:@"myCollectCell"];
    
    [self.view addSubview:_myCollectTableView];
    [_myCollectTableView release];
}

#pragma mark - UITableViewDataSource
// 分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.myCollectMutableArray count] > 0) {
        return [self.myCollectMutableArray count];
    }
    return 0;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DX_BeAboutToShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCollectCell"];
    // cell选中样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    DX_BeAboutToShowModel *beAboutToShowModel = [self.myCollectMutableArray objectAtIndex:indexPath.row];
    cell.beAboutToShowModel = beAboutToShowModel;
    return cell;
}

#pragma mark - UITableViewDelegate
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DX_BeAboutToShowModel *beAboutToShowModel = [self.myCollectMutableArray objectAtIndex:indexPath.row];
    // 拼接网址
    NSString *movieDetailsAddress = [NSString stringWithFormat:MovieDetailsAddress, beAboutToShowModel.id];
    
    DX_MovieDetailsController *movieDetailsVC = [[DX_MovieDetailsController alloc] init];
    // 将拼接后的接口网址传入下一级界面
    movieDetailsVC.movieDetailsWebUrlString = movieDetailsAddress;
    movieDetailsVC.title = beAboutToShowModel.title;
    [self.navigationController pushViewController:movieDetailsVC animated:YES];
    [movieDetailsVC release];
}

#pragma mark - TableView编辑方法
// 1. 打开编辑开关
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    // TableView编辑开关
    [self.myCollectTableView setEditing:editing animated:animated];
}

// 2. 是否允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 3. Cell的编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// 4. 根据编辑状态删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DX_BeAboutToShowModel *beAboutToShowModel = [self.myCollectMutableArray objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除数组中相对应的内容
        [self.myCollectMutableArray removeObjectAtIndex:indexPath.row];
        // 删除的位置信息存放到数组中
        NSArray *removeLocArray = @[indexPath];
        // 让视图和数组的数据同步
        [tableView deleteRowsAtIndexPaths:removeLocArray withRowAnimation:UITableViewRowAnimationLeft];
        
        // 1. 创建数据库对象
        DataBaseManager *dataBaseManager = [DataBaseManager shareDataBaseManager];
        // 2. 连接数据库
        [dataBaseManager connectDataBase:@"DingDongDataBase.sqlite"];
        // 3. 删除
        [dataBaseManager executeSQLStatement:[NSString stringWithFormat:@"delete from BeAboutToShowMovieInfo where id = '%@'", beAboutToShowModel.id]];
        // 4. 关闭数据库
        [dataBaseManager closeDataBase];
    }
}

// 删除样式
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.myCollectTableView setEditing:NO animated:YES];
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
