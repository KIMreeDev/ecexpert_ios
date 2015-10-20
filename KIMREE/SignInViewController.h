//
//  SignInViewController.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-15.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "Public.h"
#import "LoginViewController.h"


@protocol SignInDelegate <NSObject>

-(void)setNameAndPwdAndUserType:(NSArray*)array;

@end


@interface SignInViewController : BaseViewController

{
    UIButton *submitBtn,*serviceBtn;
    UILabel  *agreeInLabel;
    UITextField *nickname,*email,*passwordbox,*comfirmpasswordbox;
    UIView  *serveProtocolView;
    UISegmentedControl *segment;
}
@property (assign,nonatomic) id<SignInDelegate>delegate;
@end
