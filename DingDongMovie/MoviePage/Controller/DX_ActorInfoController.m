//
//  DX_ActorInfoController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_ActorInfoController.h"
#import "DX_ActorModel.h"

#import "DX_ActorInfoCell.h"
#import "DX_DirectorInfoSummaryCell.h"
#import "DX_ActorWorksCell.h"

#import "HeightForString.h"
#import "UMSocial.h"

#import "DX_MovieDetailsController.h"

static BOOL isClickSummary = NO;

@interface DX_ActorInfoController ()<UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate>

@property (nonatomic, retain) UITableView *actorTableView;  /**< 演员表视图*/
@property (nonatomic, retain) NSMutableArray *actorMutableArray;  /**< 演员数据源*/

@property (nonatomic, copy) NSString *willShareUrl;  /**< 将要分享的链接*/

@end

@implementation DX_ActorInfoController

- (void)dealloc
{
    [_actorWebUrlString release];
    [_actorMutableArray release];
    [_actorTableView release];
    [super dealloc];
}

#pragma mark - 重写父类方法
// 左按钮方法, 返回上一级界面
- (void)leftButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 实现分享
- (void)rightShareButtonAction:(UIButton *)sender
{
    // 默认分享样式
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:AppKey
                                      shareText:[NSString stringWithFormat:@"我正在关注演员%@ 快来@叮咚影讯，生活会有美好的事情发生。", self.title]
                                     shareImage:[UIImage imageNamed:@"dx_dingdongmovielogo"]
                                shareToSnsNames:@[UMShareToWechatSession,
                                                  UMShareToWechatTimeline,
                                                  UMShareToWechatFavorite,
                                                  UMShareToSina,
                                                  UMShareToQQ,
                                                  UMShareToQzone]
                                       delegate:self];
    // QQ Qzone
    // 设置点击分享内容跳转链接
    [UMSocialData defaultData].extConfig.qqData.url = self.willShareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = self.willShareUrl;
    // 设置title
    [UMSocialData defaultData].extConfig.qqData.title = @"叮咚影讯 QQ分享";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"叮咚影讯 Qzone分享";
    
    // Wechat
    // 设置点击分享内容跳转链接
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.willShareUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.willShareUrl;
    // 设置title
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"叮咚影讯 微信好友分享";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"叮咚影讯 微信朋友圈分享";
}

// 初始化方法
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.actorMutableArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 请求数据
- (void)getActorData
{
    [Network networkGETRequestWithURL:self.actorWebUrlString
                            parameter:nil
             pageUniquenessIdentifier:@"ActorInfo"
                               result:^(id result) {
        DX_ActorModel *actorModel = [[DX_ActorModel alloc] initWithDictionary:(NSDictionary *)result];
        [self.actorMutableArray addObject:actorModel];
        [actorModel release];
        
        if ([self.actorMutableArray count] > 0) {
            [self.actorTableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 网络请求, 解析数据
    [self getActorData];
    // 创建界面
    [self createActorInterface];
}

#pragma mark - 创建界面
- (void)createActorInterface
{
    self.actorTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    
    self.actorTableView.dataSource = self;
    self.actorTableView.delegate = self;
    
    // 隐藏滚动条
    self.actorTableView.showsVerticalScrollIndicator = NO;
    // 关闭边界回弹
    self.actorTableView.bounces = NO;
    // 解决TableView分组时第一个Cell与顶部有距离的问题
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.actorTableView.tableHeaderView = headerView;
    [headerView release];
    // 解决TableView加载前有横线的问题
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.actorTableView.tableFooterView = footerView;
    [footerView release];
    
    [self.view addSubview:_actorTableView];
    [_actorTableView release];
}

#pragma mark - UITableViewDataSource
// 分区的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.actorMutableArray.count > 0) {
        return 3;
    }
    return 0;
}

// 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.actorMutableArray.count > 0) {
        return [self.actorMutableArray count];
    }
    return 0;
}

// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *actorInfoCell = @"actorInfoCell";
        DX_ActorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:actorInfoCell];
        if (cell == nil) {
            cell = [[[DX_ActorInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                            reuseIdentifier:actorInfoCell] autorelease];
        }
        // cell选中样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DX_ActorModel *actorModel = [self.actorMutableArray objectAtIndex:indexPath.row];
        cell.actorModel = actorModel;
        // 设置分享
        self.willShareUrl = actorModel.mobile_url;
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *actorSummaryCell = @"actorSummaryCell";
        DX_DirectorInfoSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:actorSummaryCell];
        if (cell == nil) {
            cell = [[[DX_DirectorInfoSummaryCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                      reuseIdentifier:actorSummaryCell] autorelease];
        }
        // cell选中样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DX_ActorModel *actorModel = [self.actorMutableArray objectAtIndex:indexPath.row];
        cell.directorModel = (DX_DirectorModel *)actorModel;
        actorModel.isClickSummary = isClickSummary;
        return cell;
    } else {
        static NSString *actorWorksCell = @"actorWorksCell";
        DX_ActorWorksCell *cell = [tableView dequeueReusableCellWithIdentifier:actorWorksCell];
        if (cell == nil) {
            cell = [[[DX_ActorWorksCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                             reuseIdentifier:actorWorksCell] autorelease];
        }
        // cell选中样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DX_ActorModel *actorModel = [self.actorMutableArray objectAtIndex:indexPath.row];
        cell.actorModel = actorModel;
        cell.skipMovieDetailsBlock = ^(NSInteger tag) {
            DX_MovieDetailsController *movieVC = [[DX_MovieDetailsController alloc] init];
            NSString *movieDetailsAddress = [NSString stringWithFormat:MovieDetailsAddress, [[[actorModel.works objectAtIndex:tag] objectForKey:@"subject"] objectForKey:@"id"]];
            movieVC.movieDetailsWebUrlString = movieDetailsAddress;
            movieVC.title = [[[actorModel.works objectAtIndex:tag] objectForKey:@"subject"] objectForKey:@"title"];
            [self.navigationController pushViewController:movieVC animated:YES];
            [movieVC release];
        };
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
// 每个分区的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    } else if (indexPath.section == 1) {
        if (isClickSummary) {
            DX_ActorModel *actorModel = [self.actorMutableArray objectAtIndex:indexPath.row];
            CGFloat summaryHeight = [HeightForString heightWithString:actorModel.summary width:self.view.frame.size.width - 20 fontSize:17];
            return summaryHeight + 20;
        }
        return 100;
    } else {
        return 280;
    }
    return 0;
}

// 区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

// cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        // 获取导演信息Model
        DX_ActorModel *actorModel = [self.actorMutableArray objectAtIndex:indexPath.row];
        // 若导演简介不为空, 则点击有收缩效果
        if (actorModel.summary.length > 0) {
            isClickSummary = !isClickSummary;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
            [self.actorTableView reloadSections:indexSet
                               withRowAnimation:UITableViewRowAnimationFade];
        }
    }
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
