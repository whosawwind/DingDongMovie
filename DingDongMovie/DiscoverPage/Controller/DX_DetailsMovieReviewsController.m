//
//  DX_DetailsMovieReviewsController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/18.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_DetailsMovieReviewsController.h"
#import "UIImageView+WebCache.h"

#import "HeightForString.h"

#import "UMSocial.h"

@interface DX_DetailsMovieReviewsController ()<UMSocialUIDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;  /**< 滚动视图*/
@property (nonatomic, retain) UILabel *reviewTitleLabel;  /**< 影评标题*/
@property (nonatomic, retain) UIImageView *usernameImageView;  /**< 用户头像*/
@property (nonatomic, retain) UILabel *usernameLabel;  /**< 用户名称*/
@property (nonatomic, retain) UILabel *contentLabel;  /**< 内容*/

@property (nonatomic, copy) NSString *willShareUrl;  /**< 将要分享的链接*/

@end

@implementation DX_DetailsMovieReviewsController

- (void)dealloc
{
    [_willShareUrl release];
    [_contentLabel release];
    [_usernameLabel release];
    [_usernameImageView release];
    [_reviewTitleLabel release];
    [_filmReviewModel release];
    [_scrollView release];
    [super dealloc];
}

#pragma mark - 重写父类方法
// 重写父类方法, 实现返回上一级界面
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
                                      shareText:[NSString stringWithFormat:@"我正在关注影评《%@》 快来@叮咚影讯，生活会有美好的事情发生。", self.title]
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

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavigation];
    // 创建详细影评界面
    [self createDetailsFilmReviewInterface];
}

#pragma mark - 导航视图
- (void)createNavigation
{
    self.title = self.filmReviewModel.title;
}

#pragma mark -创建详细影评界面
- (void)createDetailsFilmReviewInterface
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.scrollView.bounces = NO;
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [self.view addSubview:_scrollView];
    
    self.reviewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
    self.reviewTitleLabel.font = [UIFont systemFontOfSize:17];
    self.reviewTitleLabel.text = self.filmReviewModel.title;
    self.reviewTitleLabel.numberOfLines = 0;
    [self.reviewTitleLabel sizeToFit];
    [self.scrollView addSubview:_reviewTitleLabel];
    
    self.usernameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.reviewTitleLabel.frame.origin.x, self.reviewTitleLabel.frame.origin.y + self.reviewTitleLabel.frame.size.height, 30, 30)];
    self.usernameImageView.layer.cornerRadius = 15;
    self.usernameImageView.clipsToBounds = YES;
    [self.scrollView addSubview:_usernameImageView];
    [self.usernameImageView sd_setImageWithURL:[NSURL URLWithString:[self.filmReviewModel.author objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"dx_moviepage_person_placeholder"]];
    
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.usernameImageView.frame.origin.x + self.usernameImageView.frame.size.width + 5, self.usernameImageView.frame.origin.y, self.view.frame.size.width - self.usernameImageView.frame.origin.x - self.usernameImageView.frame.size.width - 5 - 10, self.usernameImageView.frame.size.height)];
    self.usernameLabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:_usernameLabel];
    self.usernameLabel.text = [self.filmReviewModel.author objectForKey:@"name"];
    
    CGFloat contentLabelHeight = [HeightForString heightWithString:self.filmReviewModel.content
                                                             width:self.view.frame.size.width - 20
                                                          fontSize:17];
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.usernameImageView.frame.origin.x, self.usernameImageView.frame.origin.y + self.usernameImageView.frame.size.height + 10, self.view.frame.size.width - 20, contentLabelHeight)];
    self.contentLabel.text = self.filmReviewModel.content;
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel sizeToFit];
    [self.scrollView addSubview:_contentLabel];
    
    self.scrollView.contentSize = CGSizeMake(0, contentLabelHeight + 95);
    
    // 设置分享
    self.willShareUrl = self.filmReviewModel.alt;
    
    // 释放
    [_contentLabel release];
    [_usernameLabel release];
    [_usernameImageView release];
    [_reviewTitleLabel release];
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
