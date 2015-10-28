//
//  DX_PhotographBrowseController.m
//  DingDongMovie
//
//  Created by dllo on 15/9/26.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_PhotographBrowseController.h"

#import "UIImageView+WebCache.h"

@interface DX_PhotographBrowseController ()<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *photographsScrollView;  /**< 图片浏览滚动视图*/
@property (nonatomic, assign) BOOL tapStatus;  /**< 轻点状态*/

@end

@implementation DX_PhotographBrowseController

- (void)dealloc
{
    [_photographsScrollView release];
    [_photosArray release];
    [super dealloc];
}

// 重写父类左按钮方法, 返回上一级界面
- (void)leftButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tapStatus = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"精选图片";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createPhotosBrowseScrollView];
}

- (void)createPhotosBrowseScrollView
{
    self.photographsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 64) / 4, self.view.frame.size.width, (self.view.frame.size.height - 64) / 2)];
    self.photographsScrollView.backgroundColor = [UIColor whiteColor];
    self.photographsScrollView.pagingEnabled = YES;
    self.photographsScrollView.bounces = NO;
    self.photographsScrollView.showsHorizontalScrollIndicator = NO;
    // 设置滚动范围
    self.photographsScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.photosArray.count, 0);
    // 设置滚动视图初始偏移量
    self.photographsScrollView.contentOffset = CGPointMake(self.view.frame.size.width * self.photoLocation, 0);
    [self.view addSubview:_photographsScrollView];
    // 放置图片
    for (int i = 0; i < self.photosArray.count; i++) {
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.photographsScrollView.frame.size.width, 0, self.photographsScrollView.frame.size.width, self.photographsScrollView.frame.size.height)];
        photoImageView.tag = 1000 + i;
        photoImageView.userInteractionEnabled = YES;
        [photoImageView sd_setImageWithURL:[NSURL URLWithString:[self.photosArray[i] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"dx_typelabel_vidicon"]];
        [self.photographsScrollView addSubview:photoImageView];
        [photoImageView release];
    }
    // 轻点
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    [tap release];
    // 捏合
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(pinchAction:)];
    [self.photographsScrollView addGestureRecognizer:pinch];
    [pinch release];
    [_photographsScrollView release];
}

#pragma mark - 手势
// 轻点
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"轻点");
    
    self.tapStatus = !self.tapStatus;
    if (self.tapStatus) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.167 alpha:1.000];
        self.navigationItem.leftBarButtonItem.customView.hidden = YES;
        self.navigationItem.title = @"";
        self.view.backgroundColor = [UIColor colorWithWhite:0.167 alpha:1.000];
    } else {
        self.navigationController.navigationBar.barTintColor = NavigationColor;
        self.navigationItem.leftBarButtonItem.customView.hidden = NO;
        self.navigationItem.title = @"精选图片";
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

// 捏合
- (void)pinchAction:(UIPinchGestureRecognizer *)pinch
{
    // 获取捏合View
    UIView *view = pinch.view;
    // 根据捏合的视图大小缩放
    view.transform = CGAffineTransformScale(view.transform, pinch.scale, pinch.scale);
    pinch.scale = 1;
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
