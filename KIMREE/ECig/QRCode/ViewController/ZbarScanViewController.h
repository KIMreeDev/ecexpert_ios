//
//  ZbarScanViewController.h
//  ECExpert
//
//  Created by JIRUI on 15/5/26.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "BaseViewController.h"

@class ZbarScanViewController;
typedef void (^ZbarFinishBlock)(ZbarScanViewController *, NSString *);

/**
 *  仅仅用来扫描条形码,扫描二维码使用ScanViewController
 */
@interface ZbarScanViewController : UIViewController

@property (copy, nonatomic) ZbarFinishBlock finishBlock;

- (void)goBack;

@end
