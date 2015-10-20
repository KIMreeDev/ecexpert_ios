//
//  SellerSettingViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/22.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "SellerSettingViewController.h"
#import "LoginViewController.h"
#import "GetDealer.h"
#import "HeartRateTestViewController.h"
#import "AFNetworkingFactory.h"
#import "AppDelegate.h"

@interface SellerSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate, UITextViewDelegate>{
    UIView *feedbackView,*aboutView;
}

@property (strong,nonatomic ) ASIFormDataRequest *request;
@property (strong,nonatomic ) UITextView         *information;
@property (strong, nonatomic) UITableView        *tableView;

@end

@implementation SellerSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Account", @"");
    
    
    [self initLogOutAction];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initLogOutAction{
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]==nil) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"LogIn", @"") style:UIBarButtonItemStylePlain target:self action:@selector(logInOrOut)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"LogOut", @"") style:UIBarButtonItemStylePlain target:self action:@selector(logInOrOut)];
        //获取数据
    }
}

-(void) logInOrOut{
    
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]==nil) {
        
        LoginViewController *loginVC=[LoginViewController alloc];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }else{
        UIAlertView *logoutV=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Logout", @"") message:NSLocalizedString(@"Are sure logout?", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Sure", @""), nil];
        __unsafe_unretained SellerSettingViewController *blockSelf = self;
        [logoutV showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
                // 通知服务器登出
                AFHTTPRequestOperationManager *manager = [AFNetworkingFactory networkingManager];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                NSDictionary *loginUserInfo = [appDelegate loginUser];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:[loginUserInfo objectForKey:@"usertype"] forKey:@"usertype"];
                
                __unsafe_unretained AppDelegate *blockAppDelegate = appDelegate;
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
                        [blockSelf.tableView reloadData];
                        
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
        }];
    }
    
}

- (void)initTableView{
    CGFloat _x,_y,_w,_h;
    _w = KM_SCREEN_WIDTH,
    _x = 0;
    _y = 0;
    _h = KM_SCREEN_HEIGHT;
    if (self.navigationController) {
        _y = 64;
        _h -= 64;
    }
    if (self.tabBarController) {
        _h -= 49;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(_x, _y, _w, _h) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = RGBA(0, 0, 0, 0.3);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        cell.textLabel.text=NSLocalizedString(@"Heart rate test", nil);
        cell.imageView.image = [UIImage imageNamed:@"heartRateTest"];
    }else if (section == 1){
        if (row == 0) {
            cell.textLabel.text=NSLocalizedString(@"About", nil);
            cell.imageView.image = [UIImage imageNamed:@"aboutUs"];
        }else if(row == 1){
            cell.textLabel.text=NSLocalizedString(@"Your suggestion", nil);
            cell.imageView.image = [UIImage imageNamed:@"feedBack"];
        }else if(row == 2){
            cell.textLabel.text=NSLocalizedString(@"Clear the cache", nil);
            cell.imageView.image = [UIImage imageNamed:@"clearCache"];
        }
    }else if (section == 2){
        if (row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.text=NSLocalizedString(@"Current version", nil);
            cell.imageView.image = [UIImage imageNamed:@"versionNumber"];
            NSDictionary* dict = [[NSBundle mainBundle] infoDictionary];
            cell.detailTextLabel.text=[dict objectForKey:@"CFBundleShortVersionString"];
        }else if(row == 1){
            cell.textLabel.text=NSLocalizedString(@"Comment", nil);
            cell.imageView.image = [UIImage imageNamed:@"Comment"];
        }else if(row == 2){
            cell.textLabel.text=NSLocalizedString(@"Wheel of Fortune", nil);
            cell.imageView.image = [UIImage imageNamed:@"Luck"];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else{
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        HeartRateTestViewController *heartRateVC=[[HeartRateTestViewController alloc] init];
        [self.navigationController pushViewController:heartRateVC animated:YES];
    }else if (section == 1){
        if (row == 0) {
            [self goToAbout];
        }else if (row == 1){
            [self feedback];
        }else if (row == 2){
            UIAlertView  *clearCacheHint=[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Confirm to clear the cache?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Sure", @""), nil];
            __unsafe_unretained SellerSettingViewController *blockSelf = self;
            [clearCacheHint showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [blockSelf clearCache];
                }
            }];
        }
    }else if (section == 2){
        if (row == 1) {
            NSString *str = [NSString stringWithFormat: @"https://itunes.apple.com/app/id%@", @"948643406"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}


#pragma mark -

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


/**
 *  清理缓存
 */
-(void)clearCache{
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


-(void)goToAbout
{
    
    UIViewController *aboutVC=[[UIViewController alloc] init];
    
    aboutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
