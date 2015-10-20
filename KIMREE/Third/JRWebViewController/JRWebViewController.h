//
//  WebViewController.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-14.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import <UIKit/UIKit.h>
//加入二维码扫描
#import "QRCodeReaderViewController.h"
#import "QRCodeReaderDelegate.h"

typedef enum {
	WebBrowserModeNavigation,
	WebBrowserModeModal,
} WebBrowserMode;


@interface XToolBar : UIToolbar {}@end
@interface JRWebViewController : UIViewController <UIWebViewDelegate,UIGestureRecognizerDelegate,QRCodeReaderDelegate>

@property (strong, nonatomic) NSURL *URL;
@property (nonatomic, assign) WebBrowserMode mode;
//用来判断点击行为
@property (assign,nonatomic) BOOL isTap;



- (void)load;
- (void)clear;

@end

