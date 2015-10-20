//
//  BaseViewController.h
//  KMECig
//
//  Created by JIRUI on 15/5/5.
//  Copyright (c) 2015年 kimree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MJExtension.h"

@interface BaseViewController : UIViewController

// 显示 navigation bar, default YES
@property (assign, nonatomic) BOOL showNavigationBar;

// 透明的navigationBar default YES ;  YES ：frame从0 0 开始    NO 从 0 64开始
@property (assign, nonatomic) BOOL translucentNavigationBar;
// default YES
@property (assign, nonatomic) BOOL translucentTabBar;

// 信息提示框
@property (strong, nonatomic) MBProgressHUD *progressHUD;
// 背景图片，默认background
@property (strong, nonatomic) UIImage *backgroundImage;

- (void)goback;

@end
