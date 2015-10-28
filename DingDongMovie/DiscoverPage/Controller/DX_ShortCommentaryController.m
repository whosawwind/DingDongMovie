//
//  DX_ShortCommentaryController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_ShortCommentaryController.h"

#import "DX_ShortCommentaryModel.h"

#import "DX_ShortCommentaryCell.h"

#import "HeightForString.h"

@interface DX_ShortCommentaryController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *shortCommentaryTableView;  /**< 短评表视图*/
@property (nonatomic, retain) NSMutableArray *shortCommentaryMutableArray;  /**< 短评数据源*/

@end

@implementation DX_ShortCommentaryController

- (void)dealloc
{
    [_shortCommentaryMutableArray release];
    [_shortCommentaryTableView release];
    [_shortCommentaryWebURLString release];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shortCommentaryMutableArray = [NSMutableArray array];
    }
    return self;
}

// 重写父类方法, 实现返回上一级界面
- (void)leftButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)getShortCommentaryData
{
    [Network networkGETRequestWithURL:self.shortCommentaryWebURLString
                            parameter:nil
             pageUniquenessIdentifier:@"ShortCommentary"
                               result:^(id result) {
        for (NSDictionary *commentsDic in [(NSDictionary *)result objectForKey:@"comments"]) {
            DX_ShortCommentaryModel *shortCommentaryModel = [[DX_ShortCommentaryModel alloc] initWithDictionary:commentsDic];
            [self.shortCommentaryMutableArray addObject:shortCommentaryModel];
            [shortCommentaryModel release];
        }
        if ([self.shortCommentaryMutableArray count] > 0) {
            [self.shortCommentaryTableView reloadData];
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
    
    self.title = @"短评";
    // 获取数据
    [self getShortCommentaryData];
    // 创建短评界面
    [self createShortCommentaryInterface];
}

#pragma mark - 创建短评界面
- (void)createShortCommentaryInterface
{
    self.shortCommentaryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    
    self.shortCommentaryTableView.delegate = self;
    self.shortCommentaryTableView.dataSource = self;
    
    self.shortCommentaryTableView.showsVerticalScrollIndicator = NO;
    // 取消分割线
    self.shortCommentaryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.shortCommentaryTableView registerClass:[DX_ShortCommentaryCell class] forCellReuseIdentifier:@"shortCommentaryCell"];
    
    [self.view addSubview:_shortCommentaryTableView];
    [_shortCommentaryTableView release];
}

#pragma mark - UITableViewDataSource
// 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.shortCommentaryMutableArray count] > 0) {
        return [self.shortCommentaryMutableArray count];
    }
    return 0;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DX_ShortCommentaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shortCommentaryCell"];
    // cell选中样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    DX_ShortCommentaryModel *model = [self.shortCommentaryMutableArray objectAtIndex:indexPath.row];
    cell.shortCommentaryModel = model;
    return cell;
}

#pragma mark - UITableViewDelegate
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DX_ShortCommentaryModel *shortCommentaryModel = [self.shortCommentaryMutableArray objectAtIndex:indexPath.row];
    CGFloat rowHeight = [HeightForString heightWithString:shortCommentaryModel.content
                                                    width:self.view.frame.size.width - 20
                                                 fontSize:16];
    return ((rowHeight + 50) + 80 + 50) * OffHeight;
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
