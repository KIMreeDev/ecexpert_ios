//
//  AppDelegate.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-7.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIDownloadCache.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate, NSURLConnectionDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *rootController;
@property (strong, nonatomic) UINavigationController *navController;
//连接状态
@property (nonatomic,assign) BOOL isReachable;

// 登陆用户信息
@property (strong, nonatomic) NSDictionary *loginUser;

@end
