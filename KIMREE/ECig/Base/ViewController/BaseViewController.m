//
//  BaseViewController.m
//  KMECig
//
//  Created by JIRUI on 15/5/5.
//  Copyright (c) 2015年 kimree. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (strong, nonatomic) UIImageView *backgroundImageView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // default YES
    self.showNavigationBar = YES;
    self.translucentNavigationBar = YES;
    self.translucentTabBar = YES;
    
    self.navigationController.navigationBarHidden = !_showNavigationBar;
    
    self.view.frame = KM_SCREEN_BOUNDS;
    [self initBackgroundImageView];
    [self initNavigationBar];
    
    [self initMBProgressHUD];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = !_showNavigationBar;
    self.navigationController.navigationBar.translucent = _translucentNavigationBar;
    self.tabBarController.tabBar.translucent = _translucentTabBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBackgroundImageView{
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:KM_SCREEN_BOUNDS];
    UIImage *image = self.backgroundImage;
    if (image == nil) {
        image = [UIImage imageNamed:@"background_ecig"];
    }
    self.backgroundImageView.image = image;
    [self.view insertSubview:self.backgroundImageView atIndex:0];
}

- (void)initNavigationBar{
    // button item 背景色
    [self.navigationController.navigationBar setTintColor:KM_COLOR_WHITE];
    // 背景色
    [self.navigationController.navigationBar setBarTintColor:KM_COLOR_NAVIGATION_BAR];
    
    // navigation bar title 字体颜色
    UIColor * color = KM_COLOR_WHITE;
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    if ([self.navigationController.viewControllers objectAtIndex:0] != self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    }
}

- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initMBProgressHUD{
    self.progressHUD = [[MBProgressHUD alloc] init];
    self.progressHUD.dimBackground = YES;
    if (self.navigationController) {
        [self.navigationController.view addSubview:self.progressHUD];
    }else{
        [self.view addSubview:self.progressHUD];
    }
    
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideProgressHUD)];
    [self.progressHUD addGestureRecognizer:click];
}

- (void)hideProgressHUD{
    [self.progressHUD hide:YES];
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