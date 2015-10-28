//
//  DX_AboutUsController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_AboutUsController.h"

#import "HeightForString.h"

@interface DX_AboutUsController ()

@end

@implementation DX_AboutUsController

- (void)dealloc
{
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
    
    self.title = @"关于";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createAboutUsInterface];
}

- (void)createAboutUsInterface
{
    UIImageView *appLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 45, 10, 90, 90)];
    appLogoImageView.layer.cornerRadius = 5;
    appLogoImageView.clipsToBounds = YES;
    appLogoImageView.image = [UIImage imageNamed:@"dx_dingdongmovielogo"];
    [self.view addSubview:appLogoImageView];
    [appLogoImageView release];
    
    UILabel *appDescriptionLabel = [[UILabel alloc] init];
    appDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    appDescriptionLabel.text = @"    叮咚影讯，由DingXu独立开发完成。叮咚坚持简洁、实用的电影资讯理念，努力做到最好。\n    电影作为现代人放松休闲的方式，已经成为生活的常态。叮咚专为达人设计，提供影片资讯，新片预告，经典榜单，汇聚了丰富的短评，影评，预告片、精彩片段与花絮，网罗各种看点，槽点。\n    如果您对叮咚有意见和建议，请及时联系开发者Mr.Ding，叮咚期待您的宝贵意见！\n新浪微博：@丁咚丁东\n邮箱：jlnudingxu@gmail.com";
    appDescriptionLabel.numberOfLines = 0;
    CGFloat appDescriptionHeight = [HeightForString heightWithString:appDescriptionLabel.text
                                                               width:self.view.frame.size.width - 20
                                                            fontSize:17];
    appDescriptionLabel.frame = CGRectMake(10, appLogoImageView.frame.origin.y + appLogoImageView.frame.size.height + 10, self.view.frame.size.width - 20, appDescriptionHeight);
    [self.view addSubview:appDescriptionLabel];
    [appDescriptionLabel release];
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
