//
//  DX_MovieDetailsController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_MovieDetailsController.h"

#import "DX_MovieDetailsInfoCell.h"
#import "DX_CharacterIntroduceCell.h"
#import "DX_DirectorActorCell.h"
#import "DX_FilmPictureCell.h"
#import "DX_FilmReviewsCell.h"

#import "DX_MovieDetailsModel.h"
#import "DX_ActorsModel.h"
#import "DX_PopularCommentsModel.h"

#import "HeightForString.h"

#import "DX_DirectorInfoController.h"
#import "DX_ActorInfoController.h"
#import "DX_MoviePhotosShowController.h"

#import "UMSocial.h"

// 是否点击了剧情简介
static BOOL isClickSummary = NO;

@interface DX_MovieDetailsController ()<UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate>

@property (nonatomic, retain) UITableView *detailsTableView;  /**< 电影详情表视图*/
@property (nonatomic, retain) NSMutableArray *detailsArray; /**< 详情数据源*/

@property (nonatomic, retain) NSMutableArray *castsMutableArray;  /**< 主要演员数组*/
@property (nonatomic, retain) NSMutableArray *popularCommentsMutableArray;  /**< 最新评论数组*/

@property (nonatomic, copy) NSString *willShareUrl;  /**< 将要分享的链接*/

@end

@implementation DX_MovieDetailsController

- (void)dealloc
{
    [_willShareUrl release];
    [_popularCommentsMutableArray release];
    [_castsMutableArray release];
    [_detailsArray release];
    [_detailsTableView release];
    [_movieDetailsWebUrlString release];
    [super dealloc];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.detailsArray = [NSMutableArray array];
        self.castsMutableArray = [NSMutableArray array];
        self.popularCommentsMutableArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 重写父类方法
// 实现返回上一级界面
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
                                      shareText:[NSString stringWithFormat:@"我正在关注影片《%@》 快来@叮咚影讯，生活会有美好的事情发生。", self.title]
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

#pragma mark - 请求数据
- (void)getDataForMovieDetails
{
    [Network networkGETRequestWithURL:self.movieDetailsWebUrlString
                            parameter:nil
             pageUniquenessIdentifier:@"MovieDetails"
                               result:^(id result) {
        DX_MovieDetailsModel *movieDetailsModel = [[DX_MovieDetailsModel alloc] initWithDictionary:(NSDictionary *)result];
        [self.detailsArray addObject:movieDetailsModel];
                
        // 演员数组
        for (NSDictionary *actorsDic in movieDetailsModel.casts) {
            DX_ActorsModel *actorsModel = [[DX_ActorsModel alloc] initWithDictionary:actorsDic];
            [self.castsMutableArray addObject:actorsModel];
            [actorsModel release];
        }
        
        // 评论数组
        for (NSDictionary *commentsDic in movieDetailsModel.popular_comments) {
            DX_PopularCommentsModel *popularCommentsModel = [[DX_PopularCommentsModel alloc] initWithDictionary:commentsDic];
            [self.popularCommentsMutableArray addObject:popularCommentsModel];
            [popularCommentsModel release];
        }
        [movieDetailsModel release];
        
        if ([self.detailsArray count] > 0) {
            [self.detailsTableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 显示导航条
    self.navigationController.navigationBar.hidden = NO;
    // 网络请求, 解析数据
    [self getDataForMovieDetails];
    [self createMovieDetailsInterface];
}

#pragma mark - 创建详情解界面
- (void)createMovieDetailsInterface
{
    self.detailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];

    self.detailsTableView.delegate = self;
    self.detailsTableView.dataSource = self;
    // 隐藏滚动条
    self.detailsTableView.showsVerticalScrollIndicator = NO;
    // 关闭边界回弹
    self.detailsTableView.bounces = NO;
    // 解决TableView分组时第一个Cell与顶部有距离的问题
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.detailsTableView.tableHeaderView = headerView;
    [headerView release];
    
    [self.view addSubview:_detailsTableView];
    [_detailsTableView release];
}

#pragma mark - UITableViewDataSource
// 分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 代码保护
    if ([self.detailsArray count] > 0) {
        return 5;
    }
    return 0;
}

// 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if ([self.detailsArray count] > 0) {
                return [self.detailsArray count];
            }
            break;
        case 1:
            if ([self.detailsArray count] > 0) {
                return [self.detailsArray count];
            }
            break;
        case 2:
            if ([self.detailsArray count] > 0) {
                return [self.detailsArray count];
            }
            break;
        case 3:
            if ([self.detailsArray count] > 0) {
                return [self.detailsArray count];
            }
            break;
        case 4:
            if ([self.detailsArray count] > 0) {
                return [self.detailsArray count];
            }
            break;
        default:
            break;
    }
    return 0;
}

// cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *movieDetailsInfoCell = @"movieDetailsInfoCell";
        DX_MovieDetailsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:movieDetailsInfoCell];
        if (cell == nil) {
            cell = [[[DX_MovieDetailsInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:movieDetailsInfoCell] autorelease];
        }
        // cell选中样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DX_MovieDetailsModel *movieDetailsModel = [self.detailsArray objectAtIndex:indexPath.row];
        cell.movieDetailsModel = movieDetailsModel;
        // 分享设置
        self.willShareUrl = movieDetailsModel.mobile_url;
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *characterIntroduceCell = @"characterIntroduceCell";
        DX_CharacterIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:characterIntroduceCell];
        if (cell == nil) {
            cell = [[[DX_CharacterIntroduceCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                     reuseIdentifier:characterIntroduceCell] autorelease];
        }
        // cell选中样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DX_MovieDetailsModel *movieDetailsModel = [self.detailsArray objectAtIndex:indexPath.row];
        movieDetailsModel.isClickSummary = isClickSummary;
        cell.movieDetailsModel = movieDetailsModel;
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *directorActorCell = @"directorActorCell";
        DX_DirectorActorCell *cell = [tableView dequeueReusableCellWithIdentifier:directorActorCell];
        if (cell == nil) {
            cell = [[[DX_DirectorActorCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                reuseIdentifier:directorActorCell] autorelease];
        }
        // cell选中样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DX_MovieDetailsModel *movieDetailsModel = [self.detailsArray objectAtIndex:indexPath.row];
        cell.movieDetailsModel = movieDetailsModel;
        cell.actorsArray = self.castsMutableArray;
        // Block跳转至导演界面
        cell.transmitDirectorInfoBlock = ^(NSDictionary *directorDic) {
            // 拼接导演界面接口地址
            NSString *directorAddress = [NSString stringWithFormat:DirectorAddress,[directorDic objectForKey:@"id"]];
            
            DX_DirectorInfoController *directorInfoVC = [[DX_DirectorInfoController alloc] init];
            // 设置导演界面导航栏标题
            directorInfoVC.title = [directorDic objectForKey:@"name"];
            // 传入导演界面接口网址
            directorInfoVC.directorWebUrlString = directorAddress;
            
            [self.navigationController pushViewController:directorInfoVC animated:YES];
            [directorInfoVC release];
        };
        // Block跳转至演员界面
        cell.transmitActorInfoBlock = ^(DX_ActorsModel *actorModel) {
            // 拼接演员界面接口网址
            NSString *actorAddress = [NSString stringWithFormat:ActorAddress, actorModel.id];
            
            DX_ActorInfoController *actorInfoVC = [[DX_ActorInfoController alloc] init];
            // 设置演员界面导航栏标题
            actorInfoVC.title = actorModel.name;
            // 传入演员界面接口网址
            actorInfoVC.actorWebUrlString = actorAddress;
            
            [self.navigationController pushViewController:actorInfoVC animated:YES];
            [actorInfoVC release];
        };
        return cell;
    } else if (indexPath.section == 3) {
        static NSString *filmPictureCell = @"filmPictureCell";
        DX_FilmPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:filmPictureCell];
        if (cell == nil) {
            cell = [[[DX_FilmPictureCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:filmPictureCell] autorelease];
        }
        // cell选中样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DX_MovieDetailsModel *movieDetailsModel = [self.detailsArray objectAtIndex:indexPath.row];
        cell.movieDetailsModel = movieDetailsModel;
        return cell;
    } else if (indexPath.section == 4) {
        static NSString *filmReviewsCell = @"filmReviewsCell";
        DX_FilmReviewsCell *cell = [tableView dequeueReusableCellWithIdentifier:filmReviewsCell];
        if (cell == nil) {
            cell = [[[DX_FilmReviewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:filmReviewsCell] autorelease];
        }
        // cell选中样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DX_MovieDetailsModel *movieDetailsModel = [self.detailsArray objectAtIndex:indexPath.row];
        cell.movieDetailsModel = movieDetailsModel;
        cell.popularCommentsArray = self.popularCommentsMutableArray;
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
// 每个分区的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 200;
            break;
        case 1:
            if (isClickSummary) {
                DX_MovieDetailsModel *movieDetailsModel = [self.detailsArray objectAtIndex:indexPath.row];
                CGFloat summaryRowHeight = [HeightForString heightWithString:movieDetailsModel.summary width:self.view.frame.size.width - 20 fontSize:18] + 30;
                return summaryRowHeight;
            }
            return 200;
            break;
        case 2:
        {
            // 移动设备为iPhone 4S 或 5, 5S 设置行高
            if ((MobileDevicesScreenWidth == iPhone4SWidth && MobileDevicesScreenHeight == iPhone4SHeight) || (MobileDevicesScreenWidth == iPhone5Width && MobileDevicesScreenHeight == iPhone5Height)) {
                return 240;
            }
            // 移动设备为iPhone 6 Plus 设置行高
            else if (MobileDevicesScreenWidth == iPhone6PlusWidth && MobileDevicesScreenHeight == iPhone6PlusHeight) {
                return 350;
            }
            return 300;
        }
            break;
        case 3:
        {
            if (MobileDevicesScreenWidth == iPhone4SWidth && MobileDevicesScreenHeight == iPhone4SHeight) {
                return 100;
            }
            return 140;
        }
            break;
        case 4:
        {
            NSInteger popularCommentsCount = self.popularCommentsMutableArray.count;
            if (popularCommentsCount <= 2) {
                return popularCommentsCount * 220 * OffHeight;
            }
            return popularCommentsCount * 180 * OffHeight;
        }
            break;
        default:
            break;
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
    DX_MovieDetailsModel *movieDetailsModel = [self.detailsArray objectAtIndex:indexPath.row];
    if (indexPath.section == 1) {
        isClickSummary = !isClickSummary;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        [self.detailsTableView reloadSections:indexSet
                             withRowAnimation:UITableViewRowAnimationFade];
    }
    if (indexPath.section == 3) {
        DX_MoviePhotosShowController *moviePhotosShowVC = [[DX_MoviePhotosShowController alloc] init];
        moviePhotosShowVC.photosArray = movieDetailsModel.photos;
        [self.navigationController pushViewController:moviePhotosShowVC animated:YES];
        [moviePhotosShowVC release];
    }
    NSLog(@"section: %ld, row: %ld", (long)indexPath.section, (long)indexPath.row);
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
