//
//  GetPasswordViewController.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-15.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "GetPasswordViewController.h"

@interface GetPasswordViewController () <UITextFieldDelegate>

@property (strong,nonatomic) ASIFormDataRequest *request;
@end

@implementation GetPasswordViewController

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
    
    self.view.backgroundColor = COLOR_BACKGROUND;
    self.title = NSLocalizedString(@"Forgot password", @"");

    emailbox=[[UITextField alloc] initWithFrame:CGRectMake(10, 100, 300, 35)];
    [emailbox setBorderStyle:UITextBorderStyleRoundedRect];
    emailbox.placeholder = NSLocalizedString(@"EMAIL", @"");
    emailbox.tag = Tag_EmailTextField;
    emailbox.delegate =self;
    emailbox.autocorrectionType = UITextAutocorrectionTypeNo;
    emailbox.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailbox.returnKeyType = UIReturnKeyDone;
    emailbox.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    hintlabel=[[UILabel alloc] init];
    hintlabel.text = NSLocalizedString( @"The temp password has been sended your email,please check your mailbox", @"");
    hintlabel.lineBreakMode = NSLineBreakByWordWrapping;
    hintlabel.numberOfLines = 2;
    hintlabel.backgroundColor=[UIColor clearColor];
    hintlabel.textColor=COLOR_DARK_GRAY;
    hintlabel.font = [UIFont systemFontOfSize:15];
    hintlabel.frame =CGRectMake(10, 130, 300, 60);
    
    resetpsswordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    resetpsswordBtn.frame = CGRectMake(10, 200, kScreen_Width-20, 40);
    [resetpsswordBtn setTitle:NSLocalizedString(@"SEND", @"") forState:UIControlStateNormal];
    [resetpsswordBtn setBackgroundImage:[UIImage imageNamed:@"Login_button.png"] forState:UIControlStateNormal];
    [resetpsswordBtn setTitleColor:COLOR_BACKGROUND forState:UIControlStateNormal] ;
    resetpsswordBtn.BackgroundColor=[UIColor clearColor];
    resetpsswordBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 18.0];
    [resetpsswordBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:resetpsswordBtn];
    [self.view addSubview:hintlabel];
    [self.view addSubview:emailbox];
}


#pragma mark - RegisterBtnClicked Method
- (void)resetPassword:(id)sender{
    
    
    if ([(UITextField *)[self.view viewWithTag:Tag_EmailTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_EmailTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:nil message:NSLocalizedString(@"The message cannot be empty", "")  delegate:self cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        
    }
    else if (![Utils isValidateEmail:[(UITextField *)[self.view viewWithTag:Tag_EmailTextField] text]]) {
        
        [Utils alertTitle:nil message:NSLocalizedString(@"Wrong format", "")  delegate:nil cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        
        
    }
    else{
    
        [self LinkNetWork:API_RESETPASSWORD_URL];

    }
    
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
    
    //邮箱名
    [[self.view viewWithTag:Tag_EmailTextField] resignFirstResponder];

    
}



//网络请求

- (void)LinkNetWork:(NSString *)strUrl
{
    _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [_request setDelegate:self];
    [_request setShouldAttemptPersistentConnection:NO];
    [_request setTimeOutSeconds:10];
    [_request setPostValue:emailbox.text forKey:@"email"];
    [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"Sending...", @"")  ];
    [_request startAsynchronous];
}

- (void)requestFailed:(ASIFormDataRequest *)request
{
    [MMProgressHUD dismissWithError:NSLocalizedString(@"Failed to connect link to server!", "")];
}

- (void)requestFinished:(ASIFormDataRequest *)request
{
    NSData *jsonData = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    int status=[[rootDic objectForKey:@"code"] intValue];

        if (status==1) {
            [MMProgressHUD dismissWithSuccess:[rootDic objectForKey:@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            [MMProgressHUD dismissWithError:[rootDic objectForKey:@"data"]];
            
            
        }

}

-(void)dealloc
{
    
    [_request cancel];
    [_request clearDelegatesAndCancel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
