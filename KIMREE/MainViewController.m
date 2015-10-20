//
//  MainViewController.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-8-13.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "MainViewController.h"
#import "NavigationAnimation.h"
#import "NearbyViewController.h"
#import "MemberSettingViewController.h"
#import "LoginViewController.h"
#import "JRWebViewController.h"
#import "CigAndWineViewController.h"

#import "SellerViewController.h"
#import "CustomerViewController.h"


@interface MainViewController ()<UITabBarControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) NavigationAnimation *navAnimation;
@property (strong,nonatomic) NearbyViewController *nearbyVC;
@property (strong,nonatomic) MemberSettingViewController *memberSettingVC;
@property (strong,nonatomic)  LoginViewController *loginVC;
@property (strong,nonatomic) UINavigationController *loginNav;
@property (strong,nonatomic) CigAndWineViewController *CigAndWineVC;
@property (strong,nonatomic) UINavigationController *userNav;
@property (strong,nonatomic) UINavigationController *informationNav;
@property (strong,nonatomic) UINavigationController *nearbyNav;
@property (strong,nonatomic) UINavigationController *cigAndWineNav;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate=self;
    //视图初始化
    [self viewInit];
}

#pragma mark
#pragma mark view init method


-(void)viewInit
{
    
    _navAnimation=[NavigationAnimation new];
    
    //资讯
    JRWebViewController *webVC=[[JRWebViewController alloc] init];
    webVC.URL=[NSURL URLWithString:@"http://m.ecig100.com/"];
    webVC.mode=WebBrowserModeModal;
    _informationNav=[self UINavigationControllerWithRootVC:webVC image:@"information" title:@"News"];
    _informationNav.delegate=self;
    
    
    
    //    //附近烟酒
    //    _CigAndWineVC=[[CigAndWineViewController alloc] init];
    //    _cigAndWineNav=[self UINavigationControllerWithRootVC:_CigAndWineVC image:@"wine" title:@"cigarettes and wine"];
    //    _cigAndWineNav.delegate=self;
    
    
    //附近
    _nearbyVC=[[NearbyViewController alloc] init];
    _nearbyNav=[self UINavigationControllerWithRootVC:_nearbyVC image:@"circum" title:@"Nearby"];
    _nearbyNav.delegate=self;
    
    //用户
    _memberSettingVC=[[MemberSettingViewController alloc] init];
    _userNav=[self UINavigationControllerWithRootVC:_memberSettingVC image:@"Me" title:@"Me"];
    _userNav.delegate=self;
    
    NSMutableArray *vcArray = [NSMutableArray arrayWithObjects: _informationNav, _nearbyNav, nil];
    
    // 根据自动登陆结果，判断显示界面
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *loginUser = appDelegate.loginUser;
    if (loginUser) {
        UserType userType = [[loginUser objectForKey:@"usertype"] integerValue];
        switch (userType) {
            case UserTypeNormal:{
                CustomerViewController *customerVC = [[CustomerViewController alloc] init];
                UINavigationController *customerNav = [self UINavigationControllerWithRootVC:customerVC image:@"Me" title:@"会员中心"];
                [vcArray addObject:customerNav];
                break;
            }
            case UserTypeDealer:{
                SellerViewController *sellerVC = [[SellerViewController alloc] init];
                UINavigationController *sellerNav = [self UINavigationControllerWithRootVC:sellerVC image:@"Me" title:@"销售中心"];
                [vcArray addObject:sellerNav];
                break;
            }
            default:
                break;
        }
    }else{
        // 自动登陆失败
        //自动登录功能在loginVC被打开的时候执行
        _loginVC=[[LoginViewController alloc] init];
        _loginNav = [self UINavigationControllerWithRootVC:_loginVC image:@"Me" title:@"Me"];
        [vcArray addObject:_loginNav];
    }
    
    
    //    SellerViewController *sellerVC = [[SellerViewController alloc] init];
    //    UINavigationController *sellerNav = [self UINavigationControllerWithRootVC:sellerVC image:@"Me" title:@"Seller"];
    //    [vcArray addObject:sellerNav];
    
    self.viewControllers = [NSArray arrayWithArray:vcArray];
    self.tabBar.barStyle=UIBarStyleDefault;
    //选中颜色
    //    self.tabBar.tintColor=COLOR_LIGHT_BLUE_THEME;
    self.tabBar.tintColor = KM_COLOR_NAVIGATION_BAR;
    
}





-(UINavigationController*)UINavigationControllerWithRootVC:(UIViewController*)VC image:(NSString*)image title:(NSString*) title
{
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:VC];
    VC.tabBarItem.image=[UIImage imageNamed:image];
    VC.title=NSLocalizedString(title, nil);
    nav.navigationBar.tintColor = COLOR_WHITE_NEW;
    return nav;
}



#pragma mark
#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    self.navigationController.navigationBarHidden=NO;
    
    
    
    if (self.selectedIndex==0) {
        
//        self.nearbyNav.view = nil;
    }else if (self.selectedIndex==1)
    {
        
        
    }else if (self.selectedIndex==2)
    {
        
//        self.nearbyNav.view = nil;
    }
    
    
#if TESTVERSION
#else
    [[[self.viewControllers objectAtIndex:0] tabBarItem] setTitle:NSLocalizedString(@"News", nil)];
    
#endif
    
    
    
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    
    
    return _navAnimation;
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
