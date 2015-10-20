//
//  ScanViewController.h
//  Demo
//
//  Created by JIRUI on 15/4/23.
//  Copyright (c) 2015年 kimree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum {
    ScanCodeTypeAll,
    ScanCodeTypeQRCode,
    ScanCodeTypeBarCode
}ScanCodeType;

@class ScanViewController;
typedef void (^FinishBlock)(ScanViewController *, NSString *);

@interface ScanViewController : UIViewController

@property (assign, nonatomic) ScanCodeType scanType;
@property (copy, nonatomic) FinishBlock finishBlock;

- (void)goBack;

@end

