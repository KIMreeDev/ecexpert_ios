//
//  LoginViewController.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-20.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GetPasswordViewController.h"
#import "Public.h"
#import "ASIFormDataRequest.h"
#import "ApiDef.h"
#import "SignInViewController.h"

typedef NS_ENUM (NSInteger, UserType){
    UserTypeNormal = 0,
    UserTypeDealer
};

@interface LoginViewController : BaseViewController

@property (nonatomic,strong) UITextField *userbox,*passwordbox;
@property (nonatomic,assign)BOOL Remember,isInLoginVC,isFromPostbar;
- (void)LinkNetWork:(NSString *)strUrl;

@end
