//
//  MemberSettingViewController.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-21.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "MemberSettingViewController.h"
#import "TableGameViewController.h"
#import "AccountViewController.h"
#import "LoginViewController.h"
#import "QRCodeReaderViewController.h"
#import "HeartRateTestViewController.h"
#import "JRWebViewController.h"
#import "WXApi.h"
#import "GetDealer.h"
#import "AFNetworkingFactory.h"
#import "AppDelegate.h"

@interface MemberSettingViewController ()<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) ASIFormDataRequest *request;
@property(nonatomic, strong, readwrite) NSString *resultText;

@end

@implementation MemberSettingViewController

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
    
    CGRect frame = CGRectMake(0, -1, kScreen_Width, kScreen_Height);
    if (KM_DEVICE_OS_VERSION >= 7.0) {
        frame = CGRectMake(0, 64 - 1, kScreen_Width, kScreen_Height - 64 - 44);
    }
    
    self.title=NSLocalizedString(@"Account", @"");
    _memberTableView=[[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    
    
    _memberTableView.delegate=self;
    _memberTableView.dataSource=self;
    [self.view addSubview:_memberTableView];
    
    
    //    [self.navigationItem setHidesBackButton:YES];
    
    //隐藏多余分隔线
    [self setExtraCellLineHidden:_memberTableView];
    
    
}


#pragma mark
#pragma mark get user data

-(void)getUerData
{
    
    
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]!=nil) {
        
        
        if ([[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_headimage"] isEqualToString:@""]) {
            
            [_headView setImage:[UIImage imageNamed:@"accountHeader"]];
        }else{
            
            [_headView setImageWithURL:[NSURL URLWithString:[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_headimage"]]];
            
        }
        _userName =[NSString stringWithFormat:NSLocalizedString(@"Name:%@", @""),[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_name"]];
        _userNickname =[NSString stringWithFormat:NSLocalizedString(@"Nickname:%@", @""),[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_nickname"]];
        _userLevel=[NSString stringWithFormat:NSLocalizedString(@"Level:%@", @""),[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_degree"]];
        
    }else
    {
        _headView.image=[UIImage imageNamed:@"accountHeader"];
    }
    
    [_memberTableView reloadData];
    
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (KM_DEVICE_OS_VERSION >= 7.0) {
        self.navigationController.navigationBar.translucent = YES;
    }
    //临时设置左按键为扫描二维码
    //    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qrcode"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoQRCode)];
    
    
    
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]==nil) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"LogIn", @"") style:UIBarButtonItemStylePlain target:self action:@selector(logInOrOut)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"LogOut", @"") style:UIBarButtonItemStylePlain target:self action:@selector(logInOrOut)];
        //获取数据
        
    }
    [self getUerData];
    self.navigationController.navigationBarHidden=NO;
}

//扫描二维码界面
-(void)gotoQRCode
{
    
    static QRCodeReaderViewController *reader = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        reader                        = [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    reader.delegate = self;
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        //NSLog(@"Completion with result: %@", resultAsString);
    }];
    
    [self presentViewController:reader animated:YES completion:NULL];
    
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    //NSLog(@"看看%@",result);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        if ([[result substringToIndex:4] isEqualToString:@"http"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"QRCodeReader", nil) message:result delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
        }
        
        //用微信，无权限
        //        if ([WXApi isWXAppInstalled]) {
        //            NSString *str = [NSString stringWithFormat:@"weixin://qr/%@",result];
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        //        }else
        //        {
        //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有安装微信，现在去安装" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //            [alertView show];
        //
        //        }
        
        
        
        
    }];
    
    
    
    
    
    
    
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.hidesBottomBarWhenPushed=NO;
}


#pragma mark
#pragma mark  leftbutton and rightbutton
-(void) back
{
    
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]&&[[[self.navigationController.viewControllers objectAtIndex:1] title] isEqualToString:NSLocalizedString(@"Login", @"")]) {
        //需先禁用导航栏本身功能
        NSUInteger index = [[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}




-(void) logInOrOut
{
    
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]==nil) {
        
        LoginViewController *loginVC=[LoginViewController alloc];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }else{
        
        
        UIAlertView *logoutV=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Logout", @"") message:NSLocalizedString(@"Are sure logout?", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Sure", @""), nil];
        logoutV.tag=101;
        [logoutV show];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==101) {
        if (buttonIndex==1) {
            
            AFHTTPRequestOperationManager *manager = [AFNetworkingFactory networkingManager];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSDictionary *loginUserInfo = [appDelegate loginUser];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[loginUserInfo objectForKey:@"usertype"] forKey:@"usertype"];
            
            __unsafe_unretained AppDelegate *blockAppDelegate = appDelegate;
            __unsafe_unretained MemberSettingViewController *blockSelf = self;
            [manager POST:API_LOGOUT_URL_NEW parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *rootDic = (NSDictionary *)responseObject;
                NSInteger code = [[rootDic objectForKey:@"code"] integerValue];
                if (code == 1) {
                    blockAppDelegate.loginUser = nil;
                    blockSelf.navigationItem.rightBarButtonItem.title=NSLocalizedString(@"LogIn", @"");
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:API_LOGIN_SID];
                    [[LocalStroge sharedInstance] deleteFileforKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
                    //加入通知,注销后主界面要进行刷新
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGOUT object:nil];
                    //调用主视图方法注销
                    [_memberTableView reloadData];
                    
                    // 获取tabviewcontroller
                    MainViewController *mainVC = (MainViewController *)self.tabBarController;
                    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:mainVC.viewControllers];
                    // 移除当前controller
                    NSInteger index = [vcArray indexOfObject:self.navigationController];
                    [vcArray removeObject:self.navigationController];
                    // 加载需要显示的viewcontroller
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    UINavigationController *loginNav = [mainVC UINavigationControllerWithRootVC:loginVC image:@"Me" title:@"Me"];
                    
                    // 重新拼装 tabviewcontroller， 并显示新添加进去的 viewcontroller
                    [vcArray insertObject:loginNav atIndex:index];
                    mainVC.viewControllers = vcArray;
                    [mainVC setSelectedViewController:loginNav];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
            
        }
    }
    if (alertView.tag==102) {
        //清除缓存
        if (buttonIndex==1) {
            [self clearCache];
        }
        
    }
    
}




#pragma mark - Table view data source

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //抽奖在暂时去除
    // int num[3]={1,5,4};
    int num[4]={1,1,3,2};
    return num[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height[4]={160,50,50,50};
    return height[indexPath.section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:nil];
        cell.textLabel.font=[UIFont boldSystemFontOfSize:14];
        //cell.separatorInset = UIEdgeInsetsZero;
        
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = COLOR_LINE_GRAY;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor=COLOR_DARK_GRAY;
    if (indexPath.section==0) {
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        //获取个人信息视图
        [self personalInformation:cell];
        cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"accountBg"]];
        [cell addSubview:_headView];
        
    }else if(indexPath.section==1){
        
        cell.textLabel.text=NSLocalizedString(@"Heart rate test", nil);
        cell.imageView.image = [UIImage imageNamed:@"heartRateTest"];
        
    }else if (indexPath.section==2) {
        if (indexPath.row==0) {
            
            cell.textLabel.text=NSLocalizedString(@"About", nil);
            cell.imageView.image = [UIImage imageNamed:@"aboutUs"];
            
            
        }else if(indexPath.row==1){
            cell.textLabel.text=NSLocalizedString(@"Your suggestion", nil);
            cell.imageView.image = [UIImage imageNamed:@"feedBack"];
            
            
        }else if(indexPath.row==2){
            cell.textLabel.text=NSLocalizedString(@"Clear the cache", nil);
            cell.imageView.image = [UIImage imageNamed:@"clearCache"];
            
            
        }
        
    }else{
        
        if (indexPath.row==0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.text=NSLocalizedString(@"Current version", nil);
            cell.imageView.image = [UIImage imageNamed:@"versionNumber"];
            NSDictionary* dict = [[NSBundle mainBundle] infoDictionary];
            cell.detailTextLabel.text=[dict objectForKey:@"CFBundleShortVersionString"];
        }else if(indexPath.row==1){
            
            cell.textLabel.text=NSLocalizedString(@"Comment", nil);
            cell.imageView.image = [UIImage imageNamed:@"Comment"];
            
        }else if(indexPath.row==2){
            
            
            cell.textLabel.text=NSLocalizedString(@"Wheel of Fortune", nil);
            cell.imageView.image = [UIImage imageNamed:@"Luck"];
        }
        
    }
    
    return cell;
}


-(void)headViewInit
{
    _headView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 35, 90, 90)];
    _headView.layer.cornerRadius = 45;
    _headView.layer.masksToBounds = YES;
    [_headView.layer setBorderWidth:4];
    [_headView.layer setBorderColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.9].CGColor];
    _headView.contentMode = UIViewContentModeScaleAspectFit;
    [_headView setImage:[UIImage imageNamed:@"accountHeader"]];
}


//个人信息视图
-(void)personalInformation:(UITableViewCell *)cell
{
    [self headViewInit];
    
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]!=nil) {
        UILabel *userNameLabel=[[UILabel alloc] init];
        UILabel *userNicknameLabel=[[UILabel alloc] init];
        UILabel *userLevelLabel=[[UILabel alloc] init];
        [self labelInit:userNameLabel name:_userName size:CGRectMake(120, 40, 300, 25) numerOfLines:1 fontSize:13];
        [self labelInit:userNicknameLabel name:_userNickname size:CGRectMake(120, 65, 300, 25) numerOfLines:1 fontSize:13];
        [self labelInit:userLevelLabel name:_userLevel size:CGRectMake(120, 90, 300, 25) numerOfLines:1 fontSize:13];
        [cell addSubview:userNameLabel];
        [cell addSubview:userNicknameLabel];
        [cell addSubview:userLevelLabel];
        //登陆则获取头像
        if ([[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_headimage"] isEqualToString:@""]) {
            
            [_headView setImage:[UIImage imageNamed:@"accountHeader"]];
        }else{
            [_headView setImageWithURL:[NSURL URLWithString:[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_headimage"]]];
            
        }
        
    }else{
        
        UILabel *hintLabel=[[UILabel alloc] init];
        [self labelInit:hintLabel name:NSLocalizedString(@"Not logged in", nil) size:CGRectMake(140, 65, 300, 30) numerOfLines:1 fontSize:14];
        [cell addSubview:hintLabel];
        
        
    }
    
}




//初始化方法
-(void)labelInit:(UILabel*)label name:(NSString*)string size:(CGRect)frame numerOfLines:(int)num fontSize:(int)size{
    label.text=NSLocalizedString(string, @"");
    label.textColor=COLOR_WHITE_NEW;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.frame = frame;
    label.numberOfLines=num;
    //  label.font = [UIFont fontWithName:@"Helvetica" size:size];
    label.font =[UIFont boldSystemFontOfSize:size];
}

-(void) buttonInit:(UIButton*)button action:(SEL)action size:(CGRect)frame name:(NSString*)name{
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor clearColor];
    button.frame = frame;
    [button setTitleColor:COLOR_WHITE_NEW forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateNormal];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed=YES;
    
    if (indexPath.section==0)  //section 0
    {
        if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]!=nil) {
            AccountViewController *accountVC=[[AccountViewController alloc] init];
            [self.navigationController pushViewController:accountVC animated:YES];
        }else {
            
            [self logInOrOut];
            
        }
        
    }else if(indexPath.section==1){
        
        HeartRateTestViewController *heartRateVC=[[HeartRateTestViewController alloc] init];
        [self.navigationController pushViewController:heartRateVC animated:YES];
    }else if(indexPath.section==2){
        
        if (indexPath.row==0) {
            [self goToAbout];
        }else if (indexPath.row==1) {
            [self feedback];
        }else if (indexPath.row==2) {
            
            UIAlertView  *clearCacheHint=[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Confirm to clear the cache?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Sure", @""), nil];
            clearCacheHint.tag=102;
            [clearCacheHint show];
            
        }else if (indexPath.row==4) {
            TableGameViewController *secVC = [[TableGameViewController alloc] init];
            [self presentViewController:secVC animated:YES completion:^{
                
            }];
        }
        
        
    }else
    {
        if (indexPath.row==1) {
            
            NSString *str = [NSString stringWithFormat: @"https://itunes.apple.com/app/id%@", @"948643406"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }
        
    }
    
    
    
}




#pragma mark
#pragma mark  enter subview

-(void)clearCache
{
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [[[GetDealer shareInstance:nil] localArr] removeAllObjects];
                       
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
}




-(void)clearCacheSuccess
{
    
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil message:@"清理成功!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.6f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    
    [promptAlert show];
    
}

//清理窗口定时消失
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}






//about
-(void)goToAbout
{
    
    UIViewController *aboutVC=[[UIViewController alloc] init];
    
    aboutView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    aboutView.backgroundColor = COLOR_LIGHT_BLUE_THEME;
    
    UILabel *titleLabel=[[UILabel alloc] init];
    [self labelInit:titleLabel name:@"电子烟专家" size:CGRectMake(10, 80, 300, 30) numerOfLines:0 fontSize:26];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=COLOR_WHITE_NEW;
    [aboutView addSubview:titleLabel];
    
    //    UILabel *titleTwo=[[UILabel alloc] init];
    //    [self labelInit:titleTwo name:@"cigarette" size:CGRectMake(10, 70, 300, 20) numerOfLines:0 fontSize:14];
    //    titleTwo.textColor=COLOR_WHITE_NEW;
    //    titleTwo.textAlignment=NSTextAlignmentCenter;
    //    [aboutView addSubview:titleTwo];
    
    UILabel *aboutContent=[[UILabel alloc] init];
    [self labelInit:aboutContent name:@"       专注电子烟行业，是全球最大最全的电子烟门户APP。\n       为您提供电子烟行业最权威的新闻、品牌、政策、展会等最新资讯。" size:CGRectMake(10, 90, 300, 150) numerOfLines:0 fontSize:15];
    aboutContent.textColor=COLOR_WHITE_NEW;
    aboutContent.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:15];
    [aboutView addSubview:aboutContent];
    
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self buttonInit:exitBtn action:@selector(exit) size:CGRectMake(10, kScreen_Height-100, kScreen_Width-20, 45) name:NSLocalizedString(@"Back", @"")];
    [exitBtn setTitleColor:COLOR_WHITE_NEW forState:UIControlStateNormal];
    exitBtn.layer.borderColor = COLOR_WHITE_NEW.CGColor;
    exitBtn.layer.borderWidth = 1;
    exitBtn.layer.cornerRadius = 5;
    
    [aboutView addSubview:exitBtn];
    
    
    aboutVC.view = aboutView;
    [self presentViewController:aboutVC animated:YES completion:nil];
    
    
}

//feedback view
-(void)feedback
{
    UIViewController *feedbackVC=[[UIViewController  alloc] init];
    feedbackVC.view.backgroundColor=COLOR_WHITE_NEW;
    feedbackVC.title=NSLocalizedString(@"Feedback", nil);
    
    UILabel *firsthint =[[UILabel alloc] init];
    [self labelInit:firsthint name:@"Please fill in your questions and suggestions" size:CGRectMake(10, 75, 310, 40) numerOfLines:2 fontSize:14];
    firsthint.textColor=COLOR_DARK_GRAY;
    firsthint.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:15];
    [feedbackVC.view addSubview:firsthint];
    
    _information = [[UITextView alloc] initWithFrame:CGRectMake(10, 115, 300, 130)];
    _information.layer.cornerRadius = 6;
    _information.layer.masksToBounds = YES;
    _information.backgroundColor =COLOR_BACKGROUND;
    _information.autocorrectionType = UITextAutocorrectionTypeNo;
    _information.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _information.returnKeyType = UIReturnKeyDone;
    _information.font = [UIFont systemFontOfSize:14];
    _information.delegate=self;
    [feedbackVC.view addSubview:_information];
    
    
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self buttonInit:submit action:@selector(sendFeedback) size:CGRectMake(10.0, 260, 300.0, 40.0) name:NSLocalizedString(@"Submit", @"")];
    submit.backgroundColor=COLOR_LIGHT_BLUE_THEME;
    submit.layer.masksToBounds=YES;
    submit.layer.cornerRadius=4;
    
    [feedbackVC.view addSubview:submit];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [feedbackVC.view addGestureRecognizer:tapGr];
    
    
    [self.navigationController pushViewController:feedbackVC animated:YES];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [feedbackView endEditing:YES];
}

-(void)exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark  ----------send email
-(void)sendFeedback
{
    if ([_information.text isEqualToString:@""]) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"No content submit", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles: nil];
        alertView.tag=100;
        [alertView show];
    }else
    {
        [self LinkNetWork:API_FEEDBACK_URL];
    }
}



#pragma -mark
#pragma -mark 网络请求

- (void)LinkNetWork:(NSString *)strUrl
{
    _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [_request setDelegate:self];
    [_request setShouldAttemptPersistentConnection:NO];
    [_request setTimeOutSeconds:10];
    [_request setPostValue:_information.text forKey:@"question_content"];
    // [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"submit...", "")];
    [_request startAsynchronous];
}

- (void)requestFailed:(ASIFormDataRequest *)request
{
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Failed to connect link to server!", "") dismissAfter:1.0f];
}

- (void)requestFinished:(ASIFormDataRequest *)request
{
    NSData *jsonData = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    int status=[[rootDic objectForKey:@"code"] intValue];
    if (status==1) {
        //[MMProgressHUD dismissWithSuccess:[rootDic objectForKey:@"msg"]];
        [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Successful submission!", "") dismissAfter:1.0f];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        // [MMProgressHUD dismissWithError:[rootDic objectForKey:@"data"]];
        [JDStatusBarNotification showWithStatus:[rootDic objectForKey:@"data"] dismissAfter:1.0f];
        
        [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Failed to connect link to server!", "") dismissAfter:1.0f];
    }
    
}

-(void)dealloc
{
    
    [_request cancel];
    [_request clearDelegatesAndCancel];
    
}


@end
