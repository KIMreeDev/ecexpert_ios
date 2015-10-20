//
//  AccounTableViewController.m
//  ECIGARFAN
//
//  Created by cool on 14-6-8.
//  Copyright (c) 2014年 cool. All rights reserved.
//

#import "AccountViewController.h"
#import "LoginViewController.h"

@interface AccountViewController ()

@property (nonatomic,strong) ItemTableViewController *itemView;
@property (strong,nonatomic) ASIFormDataRequest      *request;
//显示个人信息
@property (strong,nonatomic) UIImageView *headView,*headViewBg;
@property (strong,nonatomic) UILabel *nickname,*sign,*gender,*region,*birthday,*email,*phone,*account,*level;
//出生日期
@property (nonatomic, strong) UIDatePicker            *birthdayDatePicker;
@property (nonatomic,strong ) UIView                  *birthdayView;


@property (nonatomic,strong ) UIButton *sureButton             , *cancelButton;
@property (nonatomic, strong) NSDate                  *birthdayData;
//头像
@property (strong,nonatomic ) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImage                 *photo;
//
@property (nonatomic,strong ) UITableView             *accountTableView;
@property (nonatomic,strong ) NSDictionary            *userInformationDic;
@property (nonatomic,assign ) BOOL                    itemChanged;

@end

@implementation AccountViewController


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
    self.title = NSLocalizedString(@"Account information", @"");
    
    _accountTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -1, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
    _accountTableView.backgroundColor =COLOR_BACKGROUND;
    _accountTableView.delegate=self;
    _accountTableView.dataSource=self;
    [self.view addSubview:_accountTableView];
    
    //第一行初始化
    [self firstRowInit];
    //日期选择器
    [self birthdayPickerInit];
}


-(void)firstRowInit
{
    //头像背景
    _headViewBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 160)];
    _headViewBg.image=[UIImage imageNamed:@"accountBg"];
    //头像
    _headView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 110, 100, 100)];
    _headView.layer.cornerRadius = 50;
    _headView.layer.masksToBounds = YES;
    [_headView.layer setBorderWidth:4];
    [_headView.layer setBorderColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.8].CGColor];
    //自动适应,保持图片宽高比
    _headView.contentMode = UIViewContentModeScaleAspectFit;
    [_headView setUserInteractionEnabled:YES];
    
    //label初始化
    _account=[self LabelInit:_account name:@"张三丰" size:CGRectMake(135, 165, kScreen_Width-135, 20) numerOfLines:1 fontSize:13];
    _account.textAlignment=NSTextAlignmentLeft;
    _level=[self LabelInit:_level name:@"会员级别:" size:CGRectMake(135, 185, kScreen_Width-135, 20) numerOfLines:1 fontSize:13];
    _level.textAlignment=NSTextAlignmentLeft;
    
    //添加头像手势
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
    singleTap.numberOfTapsRequired=1;
    [_headView addGestureRecognizer:singleTap];
    
    
    
}




-(void)birthdayPickerInit
{
    //birthday date picker
    if (self.birthdayDatePicker == nil) {
        _birthdayDatePicker = [[UIDatePicker alloc] init];
        _birthdayDatePicker.backgroundColor = COLOR_BACKGROUND;
        [_birthdayDatePicker addTarget:self action:@selector(setBirthdayData) forControlEvents:UIControlEventValueChanged];
        _birthdayDatePicker.datePickerMode = UIDatePickerModeDate;
        NSDate *currentDate = [NSDate date];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setYear:-18];
        NSDate *selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate  options:0];
        [_birthdayDatePicker setDate:selectedDate animated:NO];
        [_birthdayDatePicker setMaximumDate:currentDate];
    }
    
    _birthdayView=[[UIView alloc] init];
    _birthdayView.frame=CGRectMake(0, kScreen_Height, kScreen_Width, 310);
    //增加两按钮
    _sureButton=[UIButton buttonWithType:UIButtonTypeSystem];
    _sureButton.frame = CGRectMake(160, 0, 160, 50);
    _sureButton.backgroundColor=COLOR_LIGHT_BLUE_THEME;
    [_sureButton setTitleColor:COLOR_WHITE_NEW forState:UIControlStateNormal];
    _sureButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _sureButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0,20);
    [_sureButton setTitle:NSLocalizedString(@"Save", "") forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(saveBirthday) forControlEvents:UIControlEventTouchUpInside];
    [_birthdayView addSubview:_sureButton];
    
    _cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton.frame = CGRectMake(0, 0, 160, 50);
    _cancelButton.backgroundColor=COLOR_LIGHT_BLUE_THEME;
    [_cancelButton setTitleColor:COLOR_WHITE_NEW forState:UIControlStateNormal];
    _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _cancelButton.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0,0);
    [_cancelButton setTitle:NSLocalizedString(@"Cancel", "") forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [_birthdayView addSubview:_cancelButton];
    
    //加dayDatePicker
    _birthdayDatePicker.frame = CGRectMake(0, 50, 320, 260);
    [_birthdayView addSubview:_birthdayDatePicker];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_itemChanged==YES) {
        [_accountTableView reloadData];
        _itemChanged=NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int a[3]={3,5,1};
    return a[section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section==0)&&(indexPath.row==0)) {
        return 220;
    }else
        return 50;
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





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *TableSampleIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:nil];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = COLOR_LIGHT_BLUE_THEME;
        
        //获取本地数据
        _userInformationDic= [[LocalStroge  sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
        
    }
    
    
    
    if (indexPath.section==0&&indexPath.row==0) {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        //加载背景，头像，及用户名，会员级别
        _account.text=[_userInformationDic objectForKey:@"customer_name"];
        _level.text=[NSString stringWithFormat:NSLocalizedString(@"Level:%@", @""),[_userInformationDic objectForKey:@"customer_degree"]];
        
        [cell addSubview:_account];
        [cell addSubview:_level];
        [cell addSubview:_headViewBg];
        
        if ([[_userInformationDic objectForKey:@"customer_headimage"] isEqualToString:@""]) {
            [_headView setImage:[UIImage imageNamed:@"accountHeader.png"]];
        }else{
            [_headView setImageWithURL:[NSURL URLWithString:[_userInformationDic objectForKey:@"customer_headimage"]]];
        }
        
        [cell addSubview:_headView];
        
    }  if (indexPath.section==0&&indexPath.row==1) {
        
        cell.textLabel.text=NSLocalizedString(@"Nickname", nil);
        _nickname=[self LabelInit:_nickname name:[_userInformationDic objectForKey:@"customer_nickname"] size:CGRectMake(100, 0, 190, 50) numerOfLines:1 fontSize:15];
        [cell addSubview:_nickname];
        
    }  if (indexPath.section==0&&indexPath.row==2) {
        
        cell.textLabel.text=NSLocalizedString(@"Signature", nil);
        _sign=[self LabelInit:_sign name:[_userInformationDic objectForKey:@"customer_sign"] size:CGRectMake(100, 0, 190, 50) numerOfLines:1 fontSize:15];
        [cell addSubview:_sign];
        
        
    }  if (indexPath.section==1&&indexPath.row==0) {
        
        cell.textLabel.text=NSLocalizedString(@"Gender", nil);
        
        _gender=[self LabelInit:_gender name:nil size:CGRectMake(100, 0, 190, 50) numerOfLines:1 fontSize:15];
        [cell addSubview:_gender];
        
        if ([[_userInformationDic objectForKey:@"customer_sex"] isEqualToString:@"0"]) {
            _gender.text =NSLocalizedString(@"male", @"");
        }else if([[_userInformationDic objectForKey:@"customer_sex"]isEqualToString:@"1"])
        {
            _gender.text =NSLocalizedString(@"female", @"");
        }
        
        
    }  if (indexPath.section==1&&indexPath.row==1) {
        
        
        cell.textLabel.text=NSLocalizedString(@"Region", nil);
        _region=[self LabelInit:_region name:[_userInformationDic objectForKey:@"customer_address"] size:CGRectMake(100, 0, 190, 50) numerOfLines:1 fontSize:15];
        [cell addSubview:_region];
        
        
    }  if (indexPath.section==1&&indexPath.row==2) {
        
        cell.textLabel.text=NSLocalizedString(@"Birthday", nil);
        _birthday=[self LabelInit:_birthday name:[_userInformationDic objectForKey:@"customer_birth"] size:CGRectMake(100, 0, 190, 50) numerOfLines:1 fontSize:15];
        [cell addSubview:_birthday];
        
    }  if (indexPath.section==1&&indexPath.row==3) {
        
        
        cell.textLabel.text=NSLocalizedString(@"Email", nil);
        _email=[self LabelInit:_email name:[_userInformationDic objectForKey:@"customer_email"] size:CGRectMake(100, 0, 190, 50) numerOfLines:1 fontSize:15];
        [cell addSubview:_email];
        
    }  if (indexPath.section==1&&indexPath.row==4) {
        
        
        cell.textLabel.text=NSLocalizedString(@"Phone", nil);
        _phone=[self LabelInit:_phone name:[_userInformationDic objectForKey:@"customer_phone"] size:CGRectMake(100, 0, 190, 50) numerOfLines:1 fontSize:15];
        [cell addSubview:_phone];
        
    }  if (indexPath.section==2&&indexPath.row==0) {
        
        
        cell.textLabel.text=NSLocalizedString(@"Password", nil);
        
    }
    
    
    // [self getUserInformation];
    
    return cell;
}


//初始化方法
-(UILabel*)LabelInit:(UILabel*)label name:(NSString*)string size:(CGRect)frame numerOfLines:(int)num fontSize:(int)size{
    label=[[UILabel alloc] init];
    label.text=NSLocalizedString(string, @"");
    label.textColor=COLOR_MIDDLE_GRAY;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentRight;
    label.frame = frame;
    label.numberOfLines=num;
    label.font = [UIFont fontWithName:@"Helvetica" size:size];
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed=YES;
    
    if (!(indexPath.section==0&indexPath.row==0)) {
        
        
        
        
        if (indexPath.section==1&indexPath.row==2) {
            [self popDatePicker];
        }else{
            
            _itemView=[[ItemTableViewController alloc] init];
            
            if(indexPath.section==0&indexPath.row==1){
                _itemView.itemTitle=NSLocalizedString(@"Nickname", "");
                _itemView.itemText=_nickname.text;
            } if(indexPath.section==0&indexPath.row==2){
                _itemView.itemTitle=NSLocalizedString(@"Signature", "");
                _itemView.itemText=_sign.text;
            } if(indexPath.section==1&indexPath.row==0){
                _itemView.itemTitle=NSLocalizedString(@"Gender", "");
                _itemView.itemText=_gender.text;
            } if(indexPath.section==1&indexPath.row==1){
                _itemView.itemTitle=NSLocalizedString(@"Region", "");
                _itemView.itemText=_region.text;
            } if(indexPath.section==1&indexPath.row==3){
                _itemView.itemTitle=NSLocalizedString(@"Email", "");
                _itemView.itemText=_email.text;
            } if(indexPath.section==1&indexPath.row==4){
                _itemView.itemTitle=NSLocalizedString(@"Phone", "");
                _itemView.itemText=_phone.text;
            } if(indexPath.section==2&indexPath.row==0){
                _itemView.itemTitle=NSLocalizedString(@"Password", "");
                
            }
            
            
            _itemChanged=YES;
            _itemView.title=_itemView.itemTitle;
            //后台必须传nickname，否则出错，后台修正
            _itemView.nickName=_nickname.text;
            [self.navigationController  pushViewController:_itemView animated:YES];
            
        }
    }
}


#pragma mark - IBActions     PHOTO

- (void)choosePhoto
{
    UIActionSheet *choosePhotoActionSheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"change your icon", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take photo from camera", @""), NSLocalizedString(@"take photo from library", @""), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"change your icon", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take photo from library", @""), nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
    _imagePickerController.sourceType = sourceType;
    
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    _photo = [info objectForKey:UIImagePickerControllerEditedImage];
    _photo =[self OriginImage:_photo scaleToSize:CGSizeMake(180, 180)];
    
    _headView.image=_photo;
    
    //    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    //    {
    //        //如果采自于摄像头（注意模拟器产生异常）
    //
    //    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        //模态对话框隐藏之后执行上传
        
        // [self uploadPotoSave];
        [self LinkNetWork:API_UPLOADUSERHEADER_URL_NEW];
        
    }];
}


//缩放图片

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //需要尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回改变图片
}





-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:API_LOGIN_SID];
    [[LocalStroge sharedInstance] deleteFileforKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
    
    LoginViewController *secVC=[[LoginViewController alloc] init];
    [self.navigationController pushViewController:secVC animated:YES];
}

#pragma -mark   ------------birthday

- (void)setBirthdayData
{
    _birthdayData = _birthdayDatePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    _birthday.text = [dateFormatter stringFromDate:_birthdayData];
    
}

-(void) popDatePicker
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    if (IS_INCH4) {
        _birthdayView.frame=CGRectMake(0, 303, kScreen_Width, 310);
    }else {
        _birthdayView.frame=CGRectMake(0, 215, kScreen_Width, 310);
    }
    [self.view addSubview:_birthdayView];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
    
}

-(void)animationFinished{
    
    
}


-(void)cancel
{
    [self pushDatePicker];
    
    
}




-(void)saveBirthday
{
    [self LinkNetWork:API_EDITUSERINFO_URL_NEW];
    [self  pushDatePicker];
    
}


- (void)pushDatePicker{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    [UIView setAnimationDelegate:self];
    _birthdayView.frame=CGRectMake(0, kScreen_Height, kScreen_Width, 310);
    // 动画完毕后调用animationFinished
    //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}



#pragma -mark -------------------------------网络请求

//网络请求

- (void)LinkNetWork:(NSString *)strUrl
{
    _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [_request setDelegate:self];
    [_request setShouldAttemptPersistentConnection:NO];
    [_request setTimeOutSeconds:10];
    
    if ([strUrl isEqualToString:API_GETUSERINFO_URL_NEW]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSDictionary *loginUserInfo = appDelegate.loginUser;
        [_request setPostValue:[loginUserInfo objectForKey:@"usertype"] forKey:@"usertype"];
        _request.tag=102;
    }
    if ([strUrl isEqualToString:API_EDITUSERINFO_URL_NEW]) {
        _request.tag=103;
        [_request setPostValue:_nickname.text forKey:@"customer_nickname"];
        [_request setPostValue:_birthday.text forKey:@"customer_birth"];
        //[MMProgressHUD showWithTitle:nil status:@"Sending..." ];
    }
    if ([strUrl isEqualToString:API_UPLOADUSERHEADER_URL_NEW]) {
        _request.tag=104;
        //图片本地处理，不压缩
        NSData *imageData = UIImageJPEGRepresentation(_photo, 1);
        [_request addData:imageData withFileName:@"head.jpeg" andContentType:@"image/jpeg" forKey:@"customer_headimage"];
        
        // 菊花圈
        [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"Sending...", @"")  ];
    }
    
    [_request startAsynchronous];
}

- (void)requestFailed:(ASIFormDataRequest *)request
{
    //    if (request.tag==102) {
    //        [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"Get user information...", "")];
    //        [MMProgressHUD dismissWithError:NSLocalizedString(@"Failed to connect link to server!", "")];
    //    }
    
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Failed to connect link to server!", "") dismissAfter:1.0f];
}

- (void)requestFinished:(ASIFormDataRequest *)request
{
    NSData *jsonData = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    int status=[[rootDic objectForKey:@"code"] intValue];
    if (request.tag==102) {
        if (status==1) {
            
            [[LocalStroge sharedInstance] deleteFileforKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
            [[LocalStroge sharedInstance] addObject:[rootDic objectForKey:@"data"] forKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
            
            [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Successful modification!", "") dismissAfter:1.0f];
            [_accountTableView reloadData];
            
            //TODO: by Fran
            // 修改数据后要重新查询登录用户信息，查询成功后需要刷新界面显示，在需要刷新显示数据的地方接收该通知进行处理
            [[NSNotificationCenter defaultCenter] postNotificationName:KM_REFRESH_LOGIN_USER_INFO object:nil];
        }
        else{
            
        }
        
        
    }
    if (request.tag==103) {
        
        if (status==1) {
            
            [self LinkNetWork:API_GETUSERINFO_URL_NEW];
            
        }
        else{
            
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"login timeout,please login again", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", @"") otherButtonTitles: nil];
            [alertView show];
            
        }
        
        
    }
    if (request.tag==104) {
        if (status==1) {
            
            [self LinkNetWork:API_GETUSERINFO_URL_NEW];
            
            [MMProgressHUD dismissWithSuccess:NSLocalizedString(@"Successful modification!", "") title:@"" afterDelay:1];
            
        }
        else{
            
            // 之前的逻辑是修改图片没成功
            //            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"login timeout,please login again", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", @"") otherButtonTitles: nil];
            //            [alertView show];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[rootDic objectForKey:@"data"] delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", @"") otherButtonTitles: nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
            }];
        }
        
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
