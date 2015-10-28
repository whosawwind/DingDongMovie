//
//  DX_BaseController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/9.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_BaseController.h"

@interface DX_BaseController ()

@end

@implementation DX_BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航主题颜色
    self.navigationController.navigationBar.barTintColor = NavigationColor;
    
    // 设置导航不透明
    self.navigationController.navigationBar.translucent = NO;
    // 导航字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 设置导航左侧按钮, 返回上一级界面
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton setImage:[UIImage imageNamed:@"dx_navigation_leftarrows"]
                forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(leftButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftBarButton release];
    
    // 设置导航右侧按钮, 分享
    UIButton *rightShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightShareButton.frame = CGRectMake(0, 0, 30, 30);
    [rightShareButton setImage:[UIImage imageNamed:@"dx_navigation_share"]
                      forState:UIControlStateNormal];
    [rightShareButton addTarget:self
                         action:@selector(rightShareButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightShareButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
    
    // 解决自定义按钮侧滑手势消失(iOS7)
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)leftButtonAction:(UIButton *)sender
{
    NSLog(@"导航左侧按钮, 返回上一级界面");
}

- (void)rightShareButtonAction:(UIButton *)sender
{
    NSLog(@"导航右侧按钮, 分享");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
