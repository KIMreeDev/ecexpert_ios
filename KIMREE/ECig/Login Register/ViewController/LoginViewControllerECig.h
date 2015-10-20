//
//  LoginViewController.h
//  KMECig
//
//  Created by JIRUI on 15/5/5.
//  Copyright (c) 2015年 kimree. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewControllerECig : BaseViewController


@property (weak, nonatomic) IBOutlet UIImageView *topLogo;
@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet UIImageView *autoLoginImageView;
@property (weak, nonatomic) IBOutlet UILabel *forgetPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *rememberPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;



- (IBAction)registerAction:(id)sender;
- (IBAction)loginAction:(id)sender;


// did end on exit
- (IBAction)nextKeyAction:(id)sender;

// UITextField begin editing
- (IBAction)beginInputAction:(id)sender;

@end
