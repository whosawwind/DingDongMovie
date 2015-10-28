//
//  DX_InteractionController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_InteractionController.h"

#import "HUDManager.h"

@interface DX_InteractionController ()<UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *webView;  /**< 网页视图*/

@end

@implementation DX_InteractionController

- (void)dealloc
{
    [_webView release];
    [super dealloc];
}

// 重写父类方法, 实现返回上一级界面
- (void)leftButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"互动";
    
    [self createInteractionInterface];
    [self loadWebPageWithURLString:InteractionAddress];
}

- (void)createInteractionInterface
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView release];
}

- (void)loadWebPageWithURLString:(NSString *)urlString
{
    urlString = [NSString stringWithFormat:@"%@", urlString];
    NSLog(@"URL: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
// 开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [HUDManager showStatus];
}

// 结束加载
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUDManager dismissHUD];
}

// 加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [HUDManager dismissHUD];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知"
                                                        message:@"加载失败, 请查看网络设置"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    alertView.frame = CGRectMake(30, 150, self.view.frame.size.width - 60, 150);
    [alertView show];
    [alertView release];
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
