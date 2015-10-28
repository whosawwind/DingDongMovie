//
//  DX_DirectorInfoController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/14.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_DirectorInfoController.h"
#import "DX_MovieDetailsController.h"

#import "DX_DirectorModel.h"

#import "DX_DirectorInfoCell.h"
#import "DX_DirectorInfoSummaryCell.h"
#import "DX_DirectorWorksCell.h"

#import "HeightForString.h"
#import "UMSocial.h"

static BOOL isClickSummary = NO;

@interface DX_DirectorInfoController ()<UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate>

@property (nonatomic, retain) UITableView *directorTableView;  /**< 导演表视图*/
@property (nonatomic, retain) NSMutableArray *directorMutableArray;  /**< 导演数据源*/

@property (nonatomic, copy) NSString *willShareUrl;  /**< 将要分享的链接*/

@end

@implementation DX_DirectorInfoController

- (void)dealloc
{
    [_willShareUrl release];
    [_directorWebUrlString release];
    [_directorMutableArray release];
    [_directorTableView release];
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
                                      shareText:[NSString stringWithFormat:@"我正在关注导演%@ 快来@叮咚影讯，生活会有美好的事情发生。", self.title]
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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.directorMutableArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 请求数据
- (void)getDirectorData
{
    [Network networkGETRequestWithURL:self.directorWebUrlString
                            parameter:nil pageUniquenessIdentifier:@"DirectorInfo"
                               result:^(id result) {
        DX_DirectorModel *directorModel = [[DX_DirectorModel alloc] initWithDictionary:(NSDictionary *)result];
        [self.directorMutableArray addObject:directorModel];
        [directorModel release];
        
        if ([self.directorMutableArray count] > 0) {
            [self.directorTableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 网络请求, 解析数据
    [self getDirectorData];
    // 创建界面
    [self createDirectorInterface];
}

#pragma mark - 创建界面
- (void)createDirectorInterface
{
    self.directorTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    
    self.directorTableView.dataSource = self;
    self.directorTableView.delegate = self;
    
    // 隐藏滚动条
    self.directorTableView.showsVerticalScrollIndicator = NO;
    // 关闭边界回弹
    self.directorTableView.bounces = NO;
    // 解决TableView加载数据前有横线问题
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.directorTableView.tableFooterView = footerView;
    [footerView release];
    
    [self.view addSubview:_directorTableView];
    [_directorTableView release];
}

#pragma mark - UITableViewDataSource
// 分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.directorMutableArray count] > 0) {
        return 3;
    }
    return 0;
}

// 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.directorMutableArray count] > 0) {
        return [self.directorMutableArray count];
    }
    return 0;
}

// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *directorInfoCell = @"directorInfoCell";
        DX_DirectorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:directorInfoCell];
        if (cell == nil) {
            cell = [[[DX_DirectorInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                               reuseIdentifier:directorInfoCell] autorelease];
        }
        // cell选中样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DX_DirectorModel *directorModel = [self.directorMutableArray objectAtIndex:indexPath.row];
        cell.directorModel = directorModel;
        // 设置分享
        self.willShareUrl = directorModel.mobile_url;
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *directorInfoSummaryCell = @"directorInfoSummaryCell";
        DX_DirectorInfoSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:directorInfoSummaryCell];
        if (cell == nil) {
            cell = [[[DX_DirectorInfoSummaryCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                      reuseIdentifier:directorInfoSummaryCell] autorelease];
        }
        // cell选中样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DX_DirectorModel *directorModel = [self.directorMutableArray objectAtIndex:indexPath.row];
        directorModel.isClickSummary = isClickSummary;
        cell.directorModel = directorModel;
        return cell;
    } else {
        static NSString *directorWorksCell = @"directorWorksCell";
        DX_DirectorWorksCell *cell = [tableView dequeueReusableCellWithIdentifier:directorWorksCell];
        if (cell == nil) {
            cell = [[[DX_DirectorWorksCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                reuseIdentifier:directorWorksCell] autorelease];
        }
        // cell选中样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DX_DirectorModel *directorModel = [self.directorMutableArray objectAtIndex:indexPath.row];
        cell.worksArray = directorModel.works;
        cell.skipMovieDetailsBlock = ^(NSInteger tag) {
            DX_MovieDetailsController *movieVC = [[DX_MovieDetailsController alloc] init];
            NSString *movieDetailsAddress = [NSString stringWithFormat:MovieDetailsAddress, [[[directorModel.works objectAtIndex:tag] objectForKey:@"subject"] objectForKey:@"id"]];
            movieVC.movieDetailsWebUrlString = movieDetailsAddress;
            movieVC.title = [[[directorModel.works objectAtIndex:tag] objectForKey:@"subject"] objectForKey:@"title"];
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
            DX_DirectorModel *directorModel = [self.directorMutableArray objectAtIndex:indexPath.row];
            CGFloat summaryHeight = [HeightForString heightWithString:directorModel.summary width:self.view.frame.size.width - 20 fontSize:17];
            return summaryHeight + 20;
        }
        return 100;
    } else {
        return (160 * [[self.directorMutableArray[indexPath.row] works] count]) + 30;
    }
}

// cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        // 获取导演信息Model
        DX_DirectorModel *directorModel = [self.directorMutableArray objectAtIndex:indexPath.row];
        // 若导演简介不为空, 则点击有收缩效果
        if (directorModel.summary.length > 0) {
            isClickSummary = !isClickSummary;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
            [self.directorTableView reloadSections:indexSet
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
