//
//  AppDelegate.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-7.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "AppHelper.h"
#import "ArchiveServer.h"
#import "AppInfoModel.h"
#import "AppServer.h"
#import "LaunchView.h"
#import "GuideView.h"
//#import "WXApi.h"

#import "AFNetworking.h"
#import "JRKeyChainHelper.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()<LaunchViewDelegate,GuideViewDelegate,UIAlertViewDelegate>{
    /*
     1.收集是否有通知
     2.用于网络连接状态判断
     */
    NSDictionary *remoteNotificationUserInfo;
    Reachability *hostReach;
}
@end


@implementation AppDelegate
@synthesize navController = _navController;
@synthesize rootController = _rootController;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 查看沙盒路径
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSLog(@"%@", paths);
    
    /**
     *  崩溃信息监测,详情查看 http://www.infoq.com/cn/articles/crashlytics-crash-statistics-tools
     */
    [Fabric with:@[CrashlyticsKit]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //设定指示器的出现形式
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    
    
    //设置状态栏样式
    [UIApplication sharedApplication].statusBarHidden = NO;
    if ([SystemHelper systemVersion] >= 7.0f){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    //设置状态栏通知样式
    [JDStatusBarNotification setDefaultStyle:^JDStatusBarStyle *(JDStatusBarStyle *style){
        style.barColor = [UIColor blackColor];
        style.textColor = [UIColor whiteColor];
        style.animationType = JDStatusBarAnimationTypeMove;
        style.font = [UIFont systemFontOfSize:12];
        return style;
    }];
    
    
    [self.window makeKeyAndVisible];
    
    //启动动画、渐渐消失
    LaunchView *launchView = [[LaunchView alloc] initWithDelegate:self];
    [launchView showInView:self.window delay:1.f];
    
    UIViewController *rootView = [[UIViewController alloc]init];
    rootView.view.hidden = YES;
    self.window.rootViewController = rootView;
    
    
    //获取应用信息，检查更新
    [self checkForUpdate];
    
    //启动网络连接状况监听
    [self startNetStatusListener];
    
    // 自动登陆
    [self autoLogin];
    
    // 注册推送
    [self registerAPNS];
    
    //判断是否由远程消息通知触发应用程序启动
    if (launchOptions) {
        //获取应用程序消息通知标记数（即小红圈中的数字）
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge > 0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge--;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            NSDictionary *pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            
            //获取推送详情
            [self manageRemoteNotification:pushInfo];
        }
    }
    
    //    //注册微信id
    //    [WXApi registerApp:@"wxeb5b24cbb308c102"];
    //
    return YES;
}

//#pragma mark WXApiDelegate
//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [WXApi handleOpenURL:url delegate:self];
//
//}
//
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [WXApi handleOpenURL:url delegate:self];
//
//}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 推送代理
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    NSLog(@"---didRegisterUserNotificationSettings--%@", notificationSettings);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *pushToken = [[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] ;
    NSLog(@"%@ ：%@", deviceToken, pushToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [self manageRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Regist fail    %@",[error localizedDescription]);
}

#pragma mark - 注册推送
- (void)registerAPNS{
    UIApplication *application = [UIApplication sharedApplication];
    if (KM_DEVICE_OS_VERSION >= 8.0){
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        [application registerForRemoteNotifications];
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

/**
 *  处理远程推送信息
 *
 *  @param remoteMsg 远程推送信息内容
 */
- (void)manageRemoteNotification:(NSDictionary *)remoteMsg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"remote message" message:[remoteMsg description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        
    }];
}




#pragma LaunchViewDelegate method
- (void)launchViewWillDisappear:(LaunchView *)launchView{
    
    //初始化RootViewController
    [self createRootViewController];
    
    //判断是否第一次启动2.0版本程序
    if ([GuideView isFirstLaunchApp]) {
        NSArray *array = nil;
        if ([SystemHelper isLongScreen]) {
            array = [NSArray arrayWithObjects:F_IMG(@"guide1_h"),F_IMG(@"guide2_h"),F_IMG(@"guide3_h"),nil];
        }
        else{
            array = [NSArray arrayWithObjects:F_IMG(@"guide1"),F_IMG(@"guide2"),F_IMG(@"guide3"), nil];
        }
        GuideView *guideView = [[GuideView alloc] initWithImages:array delegate:self];
        [guideView showInView:self.window];
    }
    
    
    
    
    
    [self.window bringSubviewToFront:launchView];
}

- (void)launchViewDidDisappear:(LaunchView *)launchView
{
    //通过推送通知启动程序，如果不是第一次启动2.0版本，那么处理推送通知
    if (![GuideView isFirstLaunchApp] && remoteNotificationUserInfo) {
    }
}

- (void)guideViewWillDisappear:(GuideView *)guideView
{
}

- (void)guideViewDidDisappear:(GuideView *)guideView
{
    //设置第一次启动标识
    [S_USER_DEFAULTS setBool:YES forKey:@"GuideIsSecondLaunch"];
    [S_USER_DEFAULTS synchronize];
    
    //通过推送通知启动程序，处理推送通知
    if (remoteNotificationUserInfo) {
    }
}

#pragma mark-


- (void)startNetStatusListener
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    hostReach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    [hostReach startNotifier];
}

/*
 * @brief 网络链接改变时会调用的方法
 */
-(void)reachabilityChanged:(NSNotification *)note
{
    //THLog(@"reachabilityChanged-------------");
    Reachability *currReach = [note object];
    NetworkStatus status = [currReach currentReachabilityStatus];
    if(status == NotReachable) {
        self.isReachable = NO;
    }
    else{
        self.isReachable = YES;
    }
}


//创建主视图
- (void)createRootViewController{
    
    //设置导航栏颜色
    //    [[UINavigationBar appearance] setBarTintColor:COLOR_LIGHT_BLUE_THEME];
    [[UINavigationBar appearance] setBarTintColor:KM_COLOR_NAVIGATION_BAR];
    //    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbarbackground_ecig"] forBarMetrics:UIBarMetricsDefault];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           COLOR_WHITE_NEW, NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0], NSFontAttributeName, nil]];
    //初始化主视图
    self.rootController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    self.window.rootViewController = _rootController;
    
}



#pragma mark ----------------------------------------------check for update

-(NSURLConnection*)checkForUpdate
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:APP_URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40];
    [request setHTTPMethod:@"GET"];
    
    return [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}


//获取本地版本号
-(NSString*) getLocalVer {
    NSDictionary* dict = [[NSBundle mainBundle] infoDictionary];
    return [dict objectForKey:@"CFBundleShortVersionString"];
}


#pragma mark-
#pragma mark- UIAlertViewDelegate
// =============================================================
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        // 弹出AppStore更新界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/dian-zi-yan-zhuan-jia/id948643406?l=zh&ls=1&mt=8"]];
    }else
    {
        //        //点击稍后更新后，更改不再提示标志
        //        NSMutableDictionary *updateDic=[[LocalStroge sharedInstance] getObjectAtKey:F_UPDATEINFORMATION filePath:NSCachesDirectory];
        //        [updateDic setObject:@"YES" forKey:@"updateLater"];
        //        [[LocalStroge sharedInstance] addObject:updateDic forKey:F_UPDATEINFORMATION filePath:NSCachesDirectory];
        
    }
}


#pragma mark-
#pragma mark- NSURLConnectionDelegate
// 当请求失败时的相关操作
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error{
    
    NSLog(@"Error info: %@", [error debugDescription]);
}

// 获取版本成功

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data {
    NSDictionary* dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:nil];
    
    
    if (dict) {
        NSArray* results = [dict objectForKey:@"results"];
        if (results && results.count != 0) {
            NSDictionary* resultsDict = [results objectAtIndex:0];
            if (resultsDict) {
                NSString* appstoreVer = [resultsDict objectForKey:@"version"];
                
                //保存当前商店上最新版本号及以后升级标志
                //                    NSMutableDictionary *updateDic=[[LocalStroge sharedInstance] getObjectAtKey:F_UPDATEINFORMATION filePath:NSCachesDirectory];
                //                    if (!updateDic) {
                //                        updateDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"NO",@"updateLater",appstoreVer,@"version", nil];
                //                        [[LocalStroge sharedInstance] addObject:updateDic forKey:F_UPDATEINFORMATION filePath:NSCachesDirectory];
                //                    }
                
                
                if (appstoreVer && ([appstoreVer doubleValue] > [[self getLocalVer] doubleValue])) {
                    
                    //                        if (![[updateDic objectForKey:@"updateLater"] isEqualToString:@"YES"]) {
                    UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"There is a new version, do you want to update?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Update later", nil) otherButtonTitles:NSLocalizedString(@"Update now", nil), nil];
                    view.alertViewStyle=UIAlertViewStyleDefault;
                    [view show];
                    //                        }
                    //                        if([appstoreVer doubleValue] > [[self getLocalVer] doubleValue])
                    //                        {
                    //                               [updateDic setObject:appstoreVer forKey:@"version"];
                    //                               [[LocalStroge sharedInstance] addObject:updateDic forKey:F_UPDATEINFORMATION filePath:NSCachesDirectory];
                    //                        }
                }
            }
        }
    }
    
    
    
}



/**
 *  自动登陆
 */
- (void) autoLogin{
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
        
        __unsafe_unretained AppDelegate *blockSelf = self;
        NSDictionary *paramsLogin = [[NSDictionary alloc] initWithObjectsAndKeys:[JRKeyChainHelper getUserNameWithService:KEY_USERNAME],@"username",[JRKeyChainHelper getPasswordWithService:KEY_PASSWORD],@"userpassword", [JRKeyChainHelper getUserTypeWithService:KEY_USERTYPE],@"usertype" ,nil];
        
        // 登陆
        [manager POST:API_LOGIN_URL_NEW parameters:paramsLogin success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *loginDic = (NSDictionary *)responseObject;
            NSInteger code = [[loginDic objectForKey:@"code"] integerValue];
            if (code == 1) {
                NSUserDefaults *userSid=[NSUserDefaults standardUserDefaults];
                [userSid setObject:[[loginDic objectForKey:@"data"] objectForKey:@"sid"] forKey:API_LOGIN_SID];
                [userSid synchronize];
                
                // 登陆成功后获取登陆用户信息
                [blockSelf loadLoginUserInfo:paramsLogin];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

/**
 *  自动登陆成功后获取登陆用户信息
 *
 *  @param paramsLogin 登陆时需要发送的数据，获取用户详细信息时可以用到部分数据
 */
-(void) loadLoginUserInfo:(NSDictionary *) paramsLogin{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    
    __unsafe_unretained AppDelegate *blockSelf = self;
    // 获取登陆用户信息
    [manager POST:API_GETUSERINFO_URL_NEW parameters:paramsLogin success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *infoDic = (NSDictionary *)responseObject;
        NSInteger code = [[infoDic objectForKey:@"code"] integerValue];
        if (code == 1) {
            blockSelf.loginUser = [infoDic objectForKey:@"data"];
            [[LocalStroge sharedInstance] addObject:blockSelf.loginUser forKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
            NSLog(@"%@", blockSelf.loginUser);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
