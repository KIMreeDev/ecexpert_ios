//
//  LoginViewController.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-20.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "LoginViewController.h"
#import "JRKeyChainHelper.h"
#import "NSString+JiRui.h"
#import "MemberSettingViewController.h"
#import "UserModel.h"

#import "CustomerViewController.h"
#import "SellerViewController.h"
#import "AppDelegate.h"


@interface LoginViewController () <UITextFieldDelegate,SignInDelegate>
{
    UIButton *forgotpsswordBtn,*logInBtn,*RememberPassword;
    UILabel  *autoLonInLabel;
    UIImageView *headImageView,*backgroundImage,*accountHintImage,*passwordHintImage;
    UISegmentedControl *segment;
}
@property (nonatomic,assign) BOOL  isRead;
@property (strong,nonatomic) ASIFormDataRequest *request;
@property (assign, nonatomic) UserType userType;
@end

@implementation LoginViewController
@synthesize Remember=_Remember;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]) {
        _isInLoginVC=NO;
        [self LinkNetWork:API_LOGIN_URL_NEW];
    }
    
    _isInLoginVC=YES;
    
    [self viewInit];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden=NO;
    
    if (KM_DEVICE_OS_VERSION >= 7.0) {
        self.navigationController.navigationBar.translucent = NO;
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    _isInLoginVC=NO;
    
}





//界面初始化
-(void)viewInit
{
    
    self.view.backgroundColor = COLOR_BACKGROUND;
    self.title =NSLocalizedString(@"Login", @"");
    //从贴吧登陆是需要改变
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SIGN IN", nil) style:UIBarButtonItemStylePlain target:self action:@selector(signIn:)];
    
    
    float value;
    if (_isFromPostbar==YES) {
        value=60.0;
    }else{
        
        value=0;
    }
    
    backgroundImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, value, kScreen_Width, 140)];
    backgroundImage.image=[UIImage imageNamed:@"accountBg"];
    [self.view addSubview:backgroundImage];
    
    //头像
    headImageView=[[UIImageView alloc] initWithFrame:CGRectMake(110, 20, 100, 100)];
    headImageView.image=[UIImage imageNamed:@"accountHeader"];
    headImageView.layer.cornerRadius = 50;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.borderWidth=4;
    headImageView.layer.borderColor=COLOR_WHITE_NEW.CGColor;
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [backgroundImage addSubview:headImageView];
    
    
    //提示图片
    accountHintImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 205+value, 40, 40)];
    accountHintImage.image=[UIImage imageNamed:@"accountHint"];
    [self.view addSubview:accountHintImage];
    passwordHintImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 255+value, 40, 40)];
    passwordHintImage.image=[UIImage imageNamed:@"passwordHint"];
    [self.view addSubview:passwordHintImage];
    
    
    // 用户类型  下面所有控件 y 下移 50
    self.userType = UserTypeNormal;
    NSString *userTypeStr = [JRKeyChainHelper getUserTypeWithService:KEY_USERTYPE];
    if (userTypeStr.length) {
        self.userType = [userTypeStr integerValue];
    }
    
    CGRect segmentFrame = CGRectMake((320 - 150)/2.0, 160+value, 150, 30);
    
    // items 的顺序与枚举 UserType 的顺序保持一致，确保对应的itemindex就是对应的枚举值
    segment = [[UISegmentedControl alloc] initWithItems:@[@"普通客户",@"销售商"]];
    segment.frame = segmentFrame;
    segment.tintColor = COLOR_LIGHT_BLUE_THEME;
    [segment setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    segment.selectedSegmentIndex = self.userType;
    [self.view addSubview:segment];
    
    //用户名
    _userbox=[self textFieldInit:_userbox placeholder:NSLocalizedString(@"NAME", nil) Frame:CGRectMake(50, 155 + 50 +value, 260, 40) Tag:Tag_AccountTextField];
    _userbox.text = [JRKeyChainHelper getUserNameWithService:KEY_USERNAME];
    
    //密码
    _passwordbox=[self textFieldInit:_passwordbox placeholder:NSLocalizedString(@"PASSWORD", nil) Frame:CGRectMake(50, 205 + 50+value, 260, 40) Tag:Tag_TempPasswordTextField];
    [_passwordbox setSecureTextEntry:YES];
    _passwordbox.text = [JRKeyChainHelper getPasswordWithService:KEY_PASSWORD];
    
    
    //记住密码选择框
    NSUserDefaults *passwordObject = [NSUserDefaults standardUserDefaults];
    _Remember = [passwordObject boolForKey:@"rememberPassword"];
    
    RememberPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [RememberPassword setFrame:CGRectMake(12, 266 + 50+value, 28, 28)];
    RememberPassword.layer.cornerRadius = 6;
    [RememberPassword setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"radiobox_0"]]];
    if (_Remember == NO) {
        [RememberPassword setImage:nil forState:UIControlStateNormal];
    }else{
        [RememberPassword setImage:[UIImage imageNamed:@"checkbox_1"] forState:UIControlStateNormal];
    }
    [RememberPassword addTarget:self action:@selector(RememberPassword:) forControlEvents:UIControlEventTouchUpInside];
    //记住密码提示框
    autoLonInLabel=[self labelInit:autoLonInLabel name:@"Remember the password" frame:CGRectMake(44, 264 + 50+value, 200, 30) fontsize:14.0];
    
    //忘记密码
    forgotpsswordBtn=[self buttonInit:forgotpsswordBtn setTitle:@"FORGOT?" action:@selector(getPassword:) size:CGRectMake(160 + 80,264 + 50+value,150 - 80,30) withFontSize:14.0 color:COLOR_LIGHT_BLUE_THEME];
    [forgotpsswordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    
    //登陆
    logInBtn=[self buttonInit:logInBtn setTitle:@"LOGIN" action:@selector(logIn:) size:CGRectMake(10,310 + 50+value,300,40) withFontSize:18.0 color:COLOR_BACKGROUND];
    logInBtn.backgroundColor=COLOR_LIGHT_BLUE_THEME;
    logInBtn.layer.cornerRadius=4;
    logInBtn.layer.masksToBounds=YES;
    logInBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 18.0];
    
    
    [self.view addSubview:_userbox];
    [self.view addSubview:_passwordbox];
    [self.view addSubview:RememberPassword];
    [self.view addSubview:forgotpsswordBtn];
    [self.view addSubview:autoLonInLabel];
    [self.view addSubview:logInBtn];
    
    
    //添加键盘通知
    //注册键盘出现与隐藏时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboadWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;//手势敲击的次数
    [self.view addGestureRecognizer:gesture];
    
    
    
}







//键盘出现时候调用的事件
-(void) keyboadWillShow:(NSNotification *)note{
    
    float value;
    if (_isFromPostbar==YES) {
        value=60.0;
    }else{
        
        value=0;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(0, -80-value, kScreen_Width, kScreen_Height);
    [UIView commitAnimations];
    
}
//键盘消失时候调用的事件
-(void)keyboardWillHide:(NSNotification *)note{
    
    float value;
    if (_isFromPostbar==YES) {
        value=60.0;
    }else{
        
        value=0;
    }
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(0, 64-value, kScreen_Width, kScreen_Height);
    [UIView commitAnimations];
}


//隐藏键盘方法
-(void)hideKeyboard{
    [_userbox resignFirstResponder];
}



-(NSDictionary*) returnUserNameAndPassword
{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:[JRKeyChainHelper getUserNameWithService:KEY_USERNAME],@"username",[JRKeyChainHelper getPasswordWithService:KEY_PASSWORD],@"userpassword" ,nil];
    
    return dic;
    
}

-(UserType)returnUserType{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:[JRKeyChainHelper getUserTypeWithService:KEY_USERTYPE],@"usertype" ,nil];
    NSString *userType = [dic objectForKey:@"usertype"];
    return [userType integerValue];
}





#pragma mark---------------------------init method

-(UIButton*) buttonInit:(UIButton*)button setTitle:(NSString*)name action:(SEL)action size:(CGRect)frame withFontSize:(float)size color:(UIColor*)color{
    
    button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.titleLabel.font = [UIFont systemFontOfSize: size];
    [button setTitle:NSLocalizedString(name, @"") forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor clearColor];
    button.frame = frame;
    return button;
    
}

-(UILabel*) labelInit:(UILabel*)label name:(NSString*)string frame:(CGRect)frame fontsize:(float)size{
    
    label=[[UILabel alloc] init];
    label.text=NSLocalizedString(string, @"");
    label.backgroundColor=[UIColor clearColor];
    label.textColor=COLOR_LIGHT_BLUE_THEME;
    label.font = [UIFont systemFontOfSize:size];
    label.frame = frame;
    return label;
}


-(UITextField*) textFieldInit:(UITextField*)textfield placeholder:(NSString*)string Frame:(CGRect)frame Tag:(NSInteger)tag
{
    textfield=[[UITextField alloc] initWithFrame:frame];
    [textfield setBorderStyle:UITextBorderStyleRoundedRect];
    textfield.placeholder = NSLocalizedString(string, @"");
    textfield.tag = tag;
    textfield.delegate =self;
    textfield.autocorrectionType = UITextAutocorrectionTypeNo;
    textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textfield.returnKeyType = UIReturnKeyDone;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textfield;
}



#pragma mark ----------------------- RegisterBtnClicked Method
- (void)logIn:(id)sender{
    
    NSString* userName = _userbox.text;
    NSString* pwd = _passwordbox.text;
    UserType userType = segment.selectedSegmentIndex;
    
    if (_Remember)
    {
        [JRKeyChainHelper saveUserName:userName userNameService:KEY_USERNAME psaaword:pwd psaawordService:KEY_PASSWORD];
        [JRKeyChainHelper saveUserType:userType userTypeService:KEY_USERTYPE];
    }
    
    if ([self checkValidityTextField]) {
        if (NO) {
            [Utils alertTitle:nil message:@"Wrong username or password" delegate:self cancelBtn:@"Fill again" otherBtnName:nil];
        }else {
            logInBtn.enabled=NO;
            [self LinkNetWork:API_LOGIN_URL_NEW];
        }
    }
}


- (void)RememberPassword:(id)sender{
    
    if (_Remember==YES) {
        
        [JRKeyChainHelper deleteWithUserNameService:KEY_USERNAME psaawordService:KEY_PASSWORD];
        [RememberPassword setImage:nil forState:UIControlStateNormal];
        _Remember = NO;
        
        
        
    }else if(_Remember==NO){
        [RememberPassword setImage:[UIImage imageNamed:@"checkbox_1"] forState:UIControlStateNormal];
        _Remember = YES;
        
        
    }
    
    //存储按钮状态
    NSUserDefaults *passwordObject = [NSUserDefaults standardUserDefaults];
    [passwordObject setBool:_Remember forKey:@"rememberPassword"];
    [passwordObject synchronize];
    
    
}


#pragma mark checkValidityTextField Null

- (BOOL)checkValidityTextField
{
    
    
    if ([(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:nil message:NSLocalizedString(@"NO user name", "") delegate:self cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:nil message:NSLocalizedString(@"NO password", "") delegate:self cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        
        return NO;
    }
    
    if ([[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] length] < 5) {
        
        [Utils alertTitle:nil message:NSLocalizedString(@"Password lengh must be over 6 numbers including letters!", "") delegate:nil cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        return NO;
    }
    
    
    return YES;
    
}


-(void)getPassword:(UIButton *)btn
{
    self.navigationController.navigationBar.hidden = NO;
    GetPasswordViewController *getPasswordView =[[GetPasswordViewController alloc] init];
    [self.navigationController pushViewController:getPasswordView animated:YES];
}

-(void)signIn:(UIButton *)btn
{
    self.navigationController.navigationBar.hidden = NO;
    SignInViewController *signInVC = [[SignInViewController alloc] init];
    signInVC.delegate=self;
    [self.navigationController pushViewController:signInVC animated:YES];
    
}


#pragma -mark signInDelegate
-(void)setNameAndPwdAndUserType:(NSArray*)array
{
    _userbox.text=[array objectAtIndex:0];
    _passwordbox.text=[array objectAtIndex:1];
    segment.selectedSegmentIndex = [(NSNumber *)[array objectAtIndex:2] integerValue];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - touchMethod
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    [self allEditActionsResignFirstResponder];
}

#pragma mark - PrivateMethod
- (void)allEditActionsResignFirstResponder{
    
    //用户名
    [[self.view viewWithTag:Tag_AccountTextField] resignFirstResponder];
    //temp密码
    [[self.view viewWithTag:Tag_TempPasswordTextField] resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    
    [_request cancel];
    [_request clearDelegatesAndCancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
    
}


#pragma -mark UITextFieldDelegate

//开始编辑：
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}



- (void)LinkNetWork:(NSString *)strUrl
{
    _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [_request setDelegate:self];
    [_request setShouldAttemptPersistentConnection:NO];
    [_request setTimeOutSeconds:10];
    
    
    UserType userType = UserTypeNormal;
    if (_isInLoginVC) {
        userType = segment.selectedSegmentIndex;
    }else{
        userType = [self returnUserType];
    }

    if ([strUrl hasPrefix:API_GETUSERINFO_URL_NEW]) {
        _request.tag=102;
        [_request setPostValue:[NSNumber numberWithInteger:userType] forKey:@"usertype"];
    }else {
        
        [_request setRequestMethod:@"POST"];
        
        if (_isInLoginVC==YES) {
            [_request setPostValue:_userbox.text forKey:@"username"];
            [_request setPostValue:_passwordbox.text forKey:@"userpassword"];
            [_request setPostValue:[NSNumber numberWithInteger:userType] forKey:@"usertype"];
            
        }else{
            [_request setPostValue:[[self returnUserNameAndPassword] objectForKey:@"username"] forKey:@"username"];
            [_request setPostValue:[[self returnUserNameAndPassword] objectForKey:@"userpassword"] forKey:@"userpassword"];
            [_request setPostValue:[NSNumber numberWithInteger:userType] forKey:@"usertype"];
        }        
        
        //            if (_isInLoginVC==YES) {
        [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"Loading...", @"")];
        //            }
        
        
    }
    
    [_request startAsynchronous];
}


- (void)requestFailed:(ASIFormDataRequest *)request
{
    [MMProgressHUD dismissWithError:NSLocalizedString(@"Failed to connect link to server!", "") afterDelay:3];
    logInBtn.enabled=YES;
}

- (void)requestFinished:(ASIFormDataRequest *)request
{
    NSData *jsonData = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    int status=[[rootDic objectForKey:@"code"] intValue];
    if (request.tag==102) {
        if (status==1) {
            logInBtn.enabled=YES;
            
            NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:[rootDic objectForKey:@"data"]];
            NSLog(@"%@", dic);
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.loginUser = dic;
            
            [[LocalStroge sharedInstance] addObject:dic forKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
            
            if (self.navigationController.viewControllers.count==1) {
                
                //                MemberSettingViewController *secVC = [[MemberSettingViewController alloc] init];
                //                [self.navigationController pushViewController:secVC animated:YES];
                //
                //                if ([[dic objectForKey:@"customer_headimage"] isEqualToString:@""]) {
                //
                //                    [secVC.headView setImage:[UIImage imageNamed:@"accountHeader.png"]];
                //                }else{
                //
                //                    [secVC.headView setImageWithURL:[dic objectForKey:@"customer_headimage"]];
                //
                //                }
                //                secVC.userName =[NSString stringWithFormat:@"Name:%@",[dic objectForKey:@"customer_name"]];
                //                secVC.userNickname =[NSString stringWithFormat:@"Nickname:%@",[dic objectForKey:@"customer_nickname"]];
                //                secVC.userLevel=[NSString stringWithFormat:@"Level:%@",[dic objectForKey:@"customer_degree"]];
                //
                //
                //                [secVC.memberTableView reloadData];
                
                // 获取tabviewcontroller
                MainViewController *mainVC = (MainViewController *)self.tabBarController;
                NSMutableArray *vcArray = [NSMutableArray arrayWithArray:mainVC.viewControllers];
                // 移除当前controller
                NSInteger index = [vcArray indexOfObject:self.navigationController];
                [vcArray removeObject:self.navigationController];
                
                UserType userType = [[dic objectForKey:@"usertype"] integerValue];
                switch (userType) {
                    case UserTypeNormal:{
                        // 加载需要显示的viewcontroller
                        CustomerViewController *customerVC = [[CustomerViewController alloc] init];
                        UINavigationController *customerNav = [mainVC UINavigationControllerWithRootVC:customerVC image:@"Me" title:@"Me"];
                        // 重新拼装 tabviewcontroller， 并显示新添加进去的 viewcontroller
                        [vcArray insertObject:customerNav atIndex:index];
                        mainVC.viewControllers = vcArray;
                        [mainVC setSelectedViewController:customerNav];
                        break;
                    }
                    case UserTypeDealer:{
                        // 加载需要显示的viewcontroller
                        SellerViewController *sellerVC = [[SellerViewController alloc] init];
                        UINavigationController *sellerNav = [mainVC UINavigationControllerWithRootVC:sellerVC image:@"Me" title:@"Me"];
                        // 重新拼装 tabviewcontroller， 并显示新添加进去的 viewcontroller
                        [vcArray insertObject:sellerNav atIndex:index];
                        mainVC.viewControllers = vcArray;
                        [mainVC setSelectedViewController:sellerNav];
                        break;
                    }
                    default:
                        break;
                }
                
                
            }else
            {
                //加入通知,登录后主界面要进行刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGOUT object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        }
        else{
            if (_isInLoginVC==YES) {
                [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"Get user information...", "")];
                [MMProgressHUD dismissWithError:[rootDic objectForKey:@"data"] afterDelay:3];
            }
            logInBtn.enabled=YES;
        }
        
        
    }else{
        
        if (status==1) {
            
            
            [MMProgressHUD dismissWithSuccess:nil];
            
            
            NSDictionary *userDic=[rootDic objectForKey:@"data"];
            
            NSUserDefaults *userSid=[NSUserDefaults standardUserDefaults];
            [userSid setObject:[userDic objectForKey:@"sid"] forKey:API_LOGIN_SID];
            [userSid synchronize];
            
            
            [self LinkNetWork:API_GETUSERINFO_URL_NEW];
            
            
        }
        else{
            
            if ([rootDic objectForKey:@"data"]==NULL) {
                [MMProgressHUD dismissWithError:NSLocalizedString(@"error", @"") afterDelay:3];
            }
            [MMProgressHUD dismissWithError:[rootDic objectForKey:@"data"] afterDelay:3];
            logInBtn.enabled=YES;
        }
    }
}


@end
