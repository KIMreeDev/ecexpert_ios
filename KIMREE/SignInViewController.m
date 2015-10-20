//
//  SignInViewController.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-15.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "SignInViewController.h"


@interface SignInViewController () <UITextFieldDelegate>

@property (nonatomic,assign) BOOL isRead;
@property (strong,nonatomic) ASIFormDataRequest *request;

@property (assign, nonatomic) UserType userType;

@end

@implementation SignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"SignIn", @"");
    self.view.backgroundColor = COLOR_BACKGROUND;
    
    
    // 用户类型  下面所有控件 y 下移 50
    self.userType = UserTypeNormal;// userType default : 0
    
    CGRect segmentFrame = CGRectMake((320 - 150)/2.0, 100, 150, 30);
    
    // items 的顺序与枚举 UserType 的顺序保持一致，确保对应的itemindex就是对应的枚举值
    segment = [[UISegmentedControl alloc] initWithItems:@[@"普通客户",@"销售商"]];
    segment.frame = segmentFrame;
    segment.tintColor = COLOR_LIGHT_BLUE_THEME;
    segment.selectedSegmentIndex = self.userType;
    [segment setEnabled:NO forSegmentAtIndex:1];
    [segment setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [self.view addSubview:segment];
    
    // 目前固定用户类型不可选
    segment.enabled = YES;
    
   
    submitBtn=[self buttonInit:submitBtn withImageNamed:@"Login_button" setTitle:@"SUBMIT" action:@selector(registerBtnClicked:) size:CGRectMake(10, 310 + 50, kScreen_Width-20, 40) withFontSize:18.0 color:COLOR_BACKGROUND];
 
  
    serviceBtn = [self buttonInit:serviceBtn withImageNamed:@"nil" setTitle:@"Use agreement" action:@selector(buttonClicked:) size:CGRectMake(200, 263 + 50, 120, 30) withFontSize:14.0 color:COLOR_LIGHT_BLUE_THEME];
    serviceBtn.tag = Tag_servicesButton;

    agreeInLabel = [self labelInit:agreeInLabel name:@"I have read,agree to the" frame:CGRectMake(50, 262 + 50, 170, 30) fontsize:14];
    
     //name
     nickname=[self textFieldInit:nickname placeholder:@"name" Frame:CGRectMake(10, 100 + 50, 300, 40) Tag:Tag_AccountTextField];
    
    //password
     passwordbox=[self textFieldInit:passwordbox placeholder:@"password" Frame:CGRectMake(10, 150 + 50, 300, 40) Tag:Tag_TempPasswordTextField];
     passwordbox.secureTextEntry = YES;
    
    //comfirm password
     comfirmpasswordbox=[self textFieldInit:comfirmpasswordbox placeholder:@"confirm password" Frame:CGRectMake(10, 200 + 50, 300, 40) Tag:Tag_ConfirmPasswordTextField];
     comfirmpasswordbox.secureTextEntry = YES;
    

    UIButton *checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
    checkbox.frame = CGRectMake(10, 259 + 50, 35, 35);
    checkbox.tag = Tag_isReadButton;
    [checkbox setImage:[UIImage imageNamed:@"radiobox_0.png"] forState:UIControlStateNormal];
    [checkbox addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nickname];
    [self.view addSubview:passwordbox];
    [self.view addSubview:comfirmpasswordbox];
    [self.view addSubview:submitBtn];
    [self.view addSubview:serviceBtn];
    [self.view addSubview:agreeInLabel];
    [self.view addSubview:checkbox];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (KM_DEVICE_OS_VERSION >= 7.0) {
        self.navigationController.navigationBar.translucent = YES;
    }
}

#pragma mark --init method
-(UIButton*) buttonInit:(UIButton*)button withImageNamed:(NSString*)string setTitle:(NSString*)name action:(SEL)action size:(CGRect)frame withFontSize:(float)size color:(UIColor*)color{
    
    button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.titleLabel.font = [UIFont boldSystemFontOfSize: size];
    [button setTitle:NSLocalizedString(name, @"") forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor clearColor];
    button.frame = frame;
    return button;
}

-(UILabel*) labelInit:(UILabel*)label name:(NSString*)string frame:(CGRect)frame fontsize:(float)size{
    
    label=[[UILabel alloc] init];
    label.text=NSLocalizedString(string, @"");
    label.backgroundColor=[UIColor clearColor];
    label.textColor=COLOR_DARK_GRAY;
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



-(void)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}


#pragma mark - UIButtonClicked Method
- (void)buttonClicked:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case Tag_isReadButton:
        {
            //是否阅读协议
            if (_isRead) {
                
                [btn setImage:[UIImage imageNamed:@"radiobox_0.png"] forState:UIControlStateNormal];
                _isRead = NO;
            }else{
                
                [btn setImage:[UIImage imageNamed:@"radiobox_1.png"] forState:UIControlStateNormal];
                
                _isRead = YES;
            }
        }
            break;
        case Tag_servicesButton:
        {
            
            float inch4Add;
            if (IS_INCH4) {
                inch4Add=88.0f;
            }else {
                inch4Add=0;
            }
            
            
            //服务协议
            
            UIViewController *userAgreementVC=[[UIViewController alloc] init];
            userAgreementVC.view.backgroundColor=COLOR_BACKGROUND;
                        
            // 将 状态栏(height : 20) 位置空出
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, 320, 568 - 20)];
            webView.backgroundColor = COLOR_WHITE_NEW;
            [userAgreementVC.view addSubview: webView];
            //NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:API_USEAGREEMENT_URL]];
            //[webView loadRequest:request];
        
            //根据语言版本，显示不同的协议
            NSString *filePath;
            if ([[SystemHelper currentLanguage] isEqualToString:@"en"]) {
                filePath = [[NSBundle mainBundle]pathForResource:@"agreement_strings_eng" ofType:@"html"];
            }else {
               filePath = [[NSBundle mainBundle]pathForResource:@"agreement_strings" ofType:@"html"];
            }
            
            NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
            
            
            // new back view
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 60, kScreen_Width, 60)];
            bottomView.backgroundColor = COLOR_WHITE_NEW;
            
            UIButton *exit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [exit setTitleColor:COLOR_WHITE_NEW forState:UIControlStateNormal];
            [self buttonInit:exit withImageNamed:@"Login_button" action:@selector(exit) size:CGRectMake(10.0, 10.0, 300.0, 40.0) name:@"Back"];
            
            [bottomView addSubview:exit];
            [userAgreementVC.view addSubview:bottomView];

            

            // replace by font code
//            UIButton *exit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            [exit setTitleColor:COLOR_WHITE_NEW forState:UIControlStateNormal];
//            [self buttonInit:exit withImageNamed:@"Login_button" action:@selector(exit) size:CGRectMake(10.0, 430.0+inch4Add, 300.0, 40.0) name:@"Back"];
//           
//            [userAgreementVC.view addSubview:exit];
            
            [self presentViewController:userAgreementVC animated:YES completion:nil];
            self.navigationController.navigationBarHidden=YES;
        }
            break;
            
        default:
            break;
    }
    
}


-(void) buttonInit:(UIButton*)button withImageNamed:(NSString*)string action:(SEL)action size:(CGRect)frame name:(NSString*)name{
    [button setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor clearColor];
    button.frame = frame;
    [button setTitle:NSLocalizedString(name, @"") forState:UIControlStateNormal];
}

-(void)exit
{
    self.navigationController.navigationBarHidden=NO;
    [self dismissViewControllerAnimated:YES completion:nil];

}




#pragma mark - RegisterBtnClicked Method
- (void)registerBtnClicked:(id)sender{
    
    if (!_isRead) {
        [Utils alertTitle:nil message:NSLocalizedString(@"Please read and tick the appropriate box below", "")  delegate:nil cancelBtn:NSLocalizedString(@"Sure", "") otherBtnName:nil];
    }else{
        
        if ([self checkValidityTextField]) {
            
            //[self continueRegister];
            [self LinkNetWork:API_SIGNIN_URL_NEW];
            
            
        }
    }
}

/**
 *	@brief	验证文本框是否为空
 */
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
    if ([(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:nil message:NSLocalizedString(@"NO comfirm password", "") delegate:self cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        
        return NO;
    }
    
 
    if ([[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] length] < 6) {
        
        [Utils alertTitle:nil message:NSLocalizedString(@"Password lengh must be over 6 numbers including letters!", "") delegate:nil cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        return NO;
    }
    if (![[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:[(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text]]) {
        [Utils alertTitle:nil message:NSLocalizedString(@"The two input password does not match!", "") delegate:nil cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        return NO;
    }
    
    
    
    return YES;
    
}

#pragma mark - UITextFieldDelegate Method



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
    //密码
    [[self.view viewWithTag:Tag_TempPasswordTextField] resignFirstResponder];
    //确认密码
    [[self.view viewWithTag:Tag_ConfirmPasswordTextField] resignFirstResponder];
    
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
    
}


//网络请求

- (void)LinkNetWork:(NSString *)strUrl
{
    _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [_request setDelegate:self];
    [_request setShouldAttemptPersistentConnection:NO];
    [_request setTimeOutSeconds:10];
    
    [_request setPostValue:nickname.text forKey:@"username"];
    [_request setPostValue:passwordbox.text forKey:@"userpassword"];
    [_request setPostValue:[NSNumber numberWithInteger:segment.selectedSegmentIndex] forKey:@"usertype"];

    
    [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"Registering...", @"")];
    [_request startAsynchronous];
}

- (void)requestFailed:(ASIFormDataRequest *)request
{
    [MMProgressHUD dismissWithError:NSLocalizedString(@"Failed to connect link to server!", "")];
}

- (void)requestFinished:(ASIFormDataRequest *)request
{
    NSData *jsonData = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    int status=[[rootDic objectForKey:@"code"] intValue];
    if (status==1) {
        [MMProgressHUD dismissWithSuccess:[rootDic objectForKey:@"msg"] title:@"Success" afterDelay:0.75f];
 
        
        //注册后将账号密码传递过去
        NSArray *array=[[NSArray alloc] initWithObjects:nickname.text,passwordbox.text,[NSNumber numberWithInteger:segment.selectedSegmentIndex], nil];
        [_delegate setNameAndPwdAndUserType:array];
        array=nil;
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    else
    {
        [MMProgressHUD dismissWithError:[rootDic objectForKey:@"data"]];
        

    }
    

}


@end
