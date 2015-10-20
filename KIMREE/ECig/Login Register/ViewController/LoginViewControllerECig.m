//
//  LoginViewController.m
//  KMECig
//
//  Created by JIRUI on 15/5/5.
//  Copyright (c) 2015年 kimree. All rights reserved.
//

#import "LoginViewControllerECig.h"
#import "RegisterViewController.h"
#import "CustomerViewController.h"

@interface LoginViewControllerECig ()

@property (assign, nonatomic) BOOL autoLogin;
@property (assign, nonatomic) CGRect viewFrameWhenEditing;
@property (assign, nonatomic) CGRect viewFrameNormal;

@end

@implementation LoginViewControllerECig

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.showNavigationBar = YES;
//    self.title = NSLocalizedString(@"Login", nil);
    
    [self initView];
}

- (void)initView{
    self.autoLogin = NO;
    [self changeAutoLoginImageAction];
    
    // 进入输入状态时，界面整体上移
    self.viewFrameNormal = KM_SCREEN_BOUNDS;
    CGFloat _move = 250 - 64;
    self.viewFrameWhenEditing = CGRectMake(self.viewFrameNormal.origin.x, self.viewFrameNormal.origin.y - _move, self.viewFrameNormal.size.width, self.viewFrameNormal.size.height);
    
    // 点击自动登陆
    self.rememberPasswordLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *rememberTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAutoLoginImageAction)];
    [self.rememberPasswordLabel addGestureRecognizer:rememberTap];
    
    // 点击自动登陆前的图标
    UITapGestureRecognizer *autoLoginImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAutoLoginImageAction)];
    self.autoLoginImageView.userInteractionEnabled = YES;
    [self.autoLoginImageView addGestureRecognizer:autoLoginImageTap];
    
    // 点击忘记密码
    self.forgetPasswordLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *forgetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordAction)];
    [self.forgetPasswordLabel addGestureRecognizer:forgetTap];
    
    // 点击界面空白处，移除输入键盘
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboardAction)];
    [self.view addGestureRecognizer:viewTap];
}

- (void)changeAutoLoginImageAction{
    BOOL check = !self.autoLogin;
    UIImage *image = nil;
    if (check) {
        image = [UIImage imageNamed:@"checkselected_ecig"];
    }else{
        image = [UIImage imageNamed:@"checkbox_ecig"];
    }
    self.autoLoginImageView.image = image;
    self.autoLogin = check;
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

#pragma mark - 忘记密码
- (void)forgetPasswordAction{
    
}

#pragma mark - 登陆
- (IBAction)loginAction:(id)sender {
    NSLog(@"loginAction");
    [self removeKeyboardAction];
    
    if (true) {
        // 获取tabviewcontroller
        MainViewController *mainVC = (MainViewController *)self.tabBarController;
        NSMutableArray *vcArray = [NSMutableArray arrayWithArray:mainVC.viewControllers];
        // 移除当前controller
        [vcArray removeObject:self.navigationController];
        // 加载需要显示的viewcontroller
        CustomerViewController *customerVC = [[CustomerViewController alloc] init];
        UINavigationController *customerNav = [mainVC UINavigationControllerWithRootVC:customerVC image:@"Me" title:@"Me"];
        
        // 重新拼装 tabviewcontroller， 并显示新添加进去的 viewcontroller
        [vcArray addObject:customerNav];
        mainVC.viewControllers = vcArray;
        [mainVC setSelectedViewController:customerNav];
    }
}


#pragma mark - 注册
- (IBAction)registerAction:(id)sender {
    [self.view endEditing:YES];
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}


#pragma mark - 用户名输入键盘，点击next按钮
- (IBAction)nextKeyAction:(id)sender {
    [self.passwordField becomeFirstResponder];
}


#pragma mark - 用户名 或者 密码输入框获得焦点
- (IBAction)beginInputAction:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    self.view.frame = self.viewFrameWhenEditing;
    [UIView commitAnimations];
}


#pragma mark - 用户名 或者 密码输入框获失去焦点
- (void)removeKeyboardAction{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    [self.view endEditing:YES];
    self.view.frame = self.viewFrameNormal;
    [UIView commitAnimations];
}

@end
