//
//  CustomerViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/7.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "CustomerViewController.h"
#import "NearbyViewController.h"
#import "JRWebViewController.h"
#import "MemberSettingViewController.h"
#import "ShowQRCodeViewController.h"
#import "TradeRecordViewController.h"
#import "MagnetView.h"

@interface CustomerViewController () <UITextViewDelegate>

@property (strong,nonatomic ) UITextView         *information;
@property (strong,nonatomic ) ASIFormDataRequest *request;
@property (strong, nonatomic) UIViewController   *feedbackVC;

@end

@implementation CustomerViewController

/**
 *  用来定位clickView
 */
static NSInteger ClickViewTag = 100;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KM_REFRESH_LOGIN_USER_INFO object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.translucentTabBar = YES;
    self.translucentNavigationBar = YES;
    
    self.title = @"会员中心";
    
    [self initPageViews];
        
    // 初始化界面数据
    [self initPageInfo];
    
    // 点击手势
    [self initTapGR];
    
    // 右上方 设置按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)];
    
    // 监控登录用户数据刷新通知, 注意要在dealloc移除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initPageInfo) name:KM_REFRESH_LOGIN_USER_INFO object:nil];
}

/**
 *  初始化界面参数
 */
- (void)initPageViews{
    CGRect frame = self.view.frame;
    CGFloat x    = frame.origin.x;
    CGFloat y    = frame.origin.y;
    CGFloat w    = frame.size.width;
    CGFloat h    = frame.size.height;
    if (self.navigationController) {
        y += 64.0;
        h -= 64.0;
    }
    if (self.tabBarController) {
        h -= 49.0;
    }
    CGFloat headerH        = h/4.0;
    CGRect headerViewFrame = CGRectMake(x, y, w, headerH);
    CGRect scrollViewFrame = CGRectMake(x, y+headerH, w, h - headerH);
    
    // headerView
    CGFloat imageWH             = 80.0;
    CGFloat tagLabelW           = 70.0;
    CGFloat tagLabelH           = 15.0;
    CGFloat tagLabelFontSize    = 14.0;
    CGFloat labelUpDownDistance = 10.0;
    
    UIView *headerView = [[UIView alloc] initWithFrame:headerViewFrame];
    headerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    // image
    CGRect userImageViewFrame = CGRectMake(20, (headerH - imageWH) / 2.0, imageWH, imageWH);
    _userImageView = [[UIImageView alloc] initWithFrame:userImageViewFrame];
    _userImageView.image = [UIImage imageNamed:@"accountHeader"];
    _userImageView.backgroundColor = [UIColor clearColor];
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = imageWH / 2.0;
    _userImageView.layer.borderWidth = 3;
    _userImageView.layer.borderColor = RGB(202, 201, 200).CGColor;
    
    // user
    CGRect userTagLabelFrame = CGRectMake(20 + imageWH + 5, (headerH - labelUpDownDistance) / 2.0 - tagLabelH, tagLabelW, tagLabelH);
    UILabel *userTagLabel = [self buildLabelWithFrame: userTagLabelFrame andFontSize:tagLabelFontSize];
    userTagLabel.text = @"用户名:";
    
    CGRect userNameLabelFrame = CGRectMake(userTagLabelFrame.origin.x + tagLabelW, userTagLabelFrame.origin.y, w - (userTagLabelFrame.origin.x + tagLabelW) - 5, tagLabelH);
    _userNameLabel = [self buildLabelWithFrame:userNameLabelFrame andFontSize:tagLabelFontSize];
    
    // vip
    CGRect userVipTagLabelFrame = CGRectMake(20 + imageWH + 5, (headerH + labelUpDownDistance) / 2.0, tagLabelW, tagLabelH);
    UILabel *userVipTagLabel = [self buildLabelWithFrame:userVipTagLabelFrame andFontSize:tagLabelFontSize];
    userVipTagLabel.text = @"会员卡号:";
    
    CGRect vipNumberLabelFrame = CGRectMake(userTagLabelFrame.origin.x + tagLabelW , userVipTagLabelFrame.origin.y, w - (userVipTagLabelFrame.origin.x + tagLabelW) - 5, tagLabelH);
    _vipNumberLabel = [self buildLabelWithFrame:vipNumberLabelFrame andFontSize:tagLabelFontSize];
    
    [headerView addSubview:_userImageView];
    [headerView addSubview:userTagLabel];
    [headerView addSubview:_userNameLabel];
    [headerView addSubview:userVipTagLabel];
    [headerView addSubview:_vipNumberLabel];
    [self.view addSubview:headerView];
    
    
    // scroll
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    scrollView.backgroundColor = [UIColor clearColor];
//    scrollView.contentSize = scrollViewFrame.size; // 当contentSize <= scrollFrame 的时候，scroll不能进行滚动。 可以通过设置 contentInset 来解决
//    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 1, 1);
    scrollView.contentSize = CGSizeMake(scrollViewFrame.size.width + 0.5, scrollViewFrame.size.height + 0.5);
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled = YES;
//    scrollView.delaysContentTouches = NO;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollViewFrame.size.width, scrollViewFrame.size.height)];
    contentView.backgroundColor = [UIColor clearColor];
    
    CGFloat cardDistance = 10.0;
    CGFloat cardHeight   = contentView.frame.size.height / 3.0 - cardDistance;
    CGFloat rowHeight    = contentView.frame.size.height / 3.0;
    CGFloat rowWidth     = contentView.frame.size.width - 2 * cardDistance;
    CGFloat sizeSmall    = 1.0;
    CGFloat sizeLarge    = 1.2;
    CGFloat rowNum       = 0;
    
    // rowNum = 0
    rowNum = 0;
    CGRect vipCardFrame = CGRectMake(cardDistance, rowNum * rowHeight + cardDistance / 2.0, (rowWidth - cardDistance) * sizeLarge / (sizeSmall + sizeLarge), cardHeight);
    UIView *vipCard = [self buildCardViewWithFrame:vipCardFrame BackgroundColor:RGB(241, 79, 89) Image:@"vipcard_ecig" Title:@"会员卡"];
    _vipCardView = [vipCard viewWithTag:ClickViewTag];
    
    CGRect shopCardFrame = CGRectMake(vipCardFrame.origin.x + vipCardFrame.size.width + cardDistance,rowNum * rowHeight + cardDistance / 2.0, (rowWidth - cardDistance) * sizeSmall / (sizeSmall + sizeLarge), cardHeight);
    UIView *shopCard = [self buildCardViewWithFrame:shopCardFrame BackgroundColor:RGB(77, 167, 217) Image:@"products_ecig" Title:@"精品店展示"];
    _showProductsView = [shopCard viewWithTag:ClickViewTag];
    
    // rowNum = 1
    rowNum = 1;
    CGRect nearByFrame = CGRectMake(cardDistance, rowNum * rowHeight + cardDistance / 2.0, rowWidth, cardHeight);
    UIView *nearByCard = [self buildCardViewWithFrame:nearByFrame BackgroundColor:RGB(247, 191, 80) Image:@"shops_ecig" Title:@"周边体验店"];
    _nearbyStoreView = [nearByCard viewWithTag:ClickViewTag];
    
    // rowNum = 2
    rowNum = 2;
    CGRect recordFrame = CGRectMake(cardDistance, rowNum * rowHeight + cardDistance / 2.0, (rowWidth - cardDistance) * sizeSmall / (sizeSmall + sizeLarge), cardHeight);
    UIView *recordCard = [self buildCardViewWithFrame:recordFrame BackgroundColor:RGB(131, 199, 92) Image:@"myrecord_ecig" Title:@"我的记录"];
    _recordView = [recordCard viewWithTag:ClickViewTag];
    
    CGRect feedBackFrame = CGRectMake(recordFrame.origin.x + recordFrame.size.width + cardDistance,rowNum * rowHeight + cardDistance / 2.0, (rowWidth - cardDistance) * sizeLarge / (sizeSmall + sizeLarge), cardHeight);
    UIView *feedBackCard = [self buildCardViewWithFrame:feedBackFrame BackgroundColor:RGB(239, 97, 66) Image:@"feedback_ecig" Title:@"用户反馈"];
    _feedbackView = [feedBackCard viewWithTag:ClickViewTag];
    
    [contentView addSubview:vipCard];
    [contentView addSubview:shopCard];
    [contentView addSubview:nearByCard];
    [contentView addSubview:recordCard];
    [contentView addSubview:feedBackCard];
    [scrollView addSubview:contentView];
    [self.view addSubview:scrollView];
}

/**
 *  初始化界面磁贴
 *
 *  @param cardFrame 磁贴Frame
 *  @param color     背景颜色
 *  @param imageName 中间显示图片
 *  @param title     磁贴功能名称
 *
 *  @return 初始化完成后的磁贴View
 */
- (UIView *)buildCardViewWithFrame:(CGRect)cardFrame BackgroundColor:(UIColor *)color Image:(NSString *)imageName Title:(NSString *)title{
    MagnetView *view = [[MagnetView alloc] initWithFrame:cardFrame];//
    view.backgroundColor = color;
    
    CGFloat clickViewWidth    = 100.0;
    CGFloat clickViewHeight   = cardFrame.size.height;
    CGRect clickViewFrame     = CGRectMake((cardFrame.size.width - clickViewWidth) / 2.0 , 0, clickViewWidth, clickViewHeight);
    UIView *clickView         = [[UIView alloc] initWithFrame:clickViewFrame];
    clickView.backgroundColor = [UIColor clearColor];
    clickView.tag = ClickViewTag;// 根据tag定位clickView
    
    CGFloat labelWidth         = clickViewWidth;
    CGFloat labelHeight        = 21.0;
    CGFloat imageWH            = 60.0;
    CGFloat imageLabelDistance = 5.0;
    
    CGFloat imageViewY = (clickViewHeight - (labelHeight + imageWH + imageLabelDistance)) / 2.0;
    CGFloat labelY     = imageViewY + imageWH + imageLabelDistance;
    
    CGRect imageViewFrame = CGRectMake((clickViewWidth - imageWH) / 2.0, imageViewY, imageWH, imageWH);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:imageName];
    
    CGFloat labelFontSize = 17.0;
    CGRect labelFrame = CGRectMake((clickViewWidth - labelWidth) / 2.0, labelY, labelWidth, labelHeight);
    UILabel *label = [self buildLabelWithFrame:labelFrame andFontSize:labelFontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    
    [clickView addSubview:imageView];
    [clickView addSubview:label];
    [view addSubview:clickView];
    
    return view;
}

/**
 *  初始化label
 *
 *  @param labelFrame labelFrame
 *  @param fontSize   label字体大小
 *
 *  @return 组装好frame和字体的label
 */
- (UILabel *)buildLabelWithFrame:(CGRect)labelFrame andFontSize:(CGFloat)fontSize{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

- (void)initPageInfo{
    NSString *userName = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_nickname"];
    if (userName.length == 0) {
        userName = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_name"];
    }
    self.userNameLabel.text = userName;
    self.vipNumberLabel.text = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_vip"];
    
    if ([[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_headimage"] isEqualToString:@""]) {
        [self.userImageView setImage:[UIImage imageNamed:@"accountHeader"]];
    }else{
        [self.userImageView setImageWithURL:[NSURL URLWithString:[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_headimage"]]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - 磁贴点击事件
- (void)settingAction{
    [self.navigationController pushViewController:[[MemberSettingViewController alloc] init] animated:YES];
}

- (void)initTapGR{
    
    // 会员卡
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vipCardTapAction)];
    [self.vipCardView addGestureRecognizer:singleTap];
    
    // 产品展示
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProductsTapAction)];
    [self.showProductsView addGestureRecognizer:singleTap];
    
    // 周边体验店
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nearbyStoreTapAction)];
    [self.nearbyStoreView addGestureRecognizer:singleTap];
    
    // 我的记录
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordTapAction)];
    [self.recordView addGestureRecognizer:singleTap];
    
    // 用户反馈
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feedbackTapAction)];
    [self.feedbackView addGestureRecognizer:singleTap];
    
}

- (void)vipCardTapAction{
    NSString *customerId = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_id"];
    NSString *customerVip = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_vip"];
    
    ShowQRCodeViewController *showQRCode = [[ShowQRCodeViewController alloc] init];
    showQRCode.qrcodeInfo = [NSString stringWithFormat:@"{\"customer_id\":%@, \"customer_vip\":%@}", customerId, customerVip];
    showQRCode.title = @"出示会员卡";
    [self.navigationController pushViewController:showQRCode animated:YES];
}

- (void)showProductsTapAction{
    JRWebViewController *webVC=[[JRWebViewController alloc] init];
    webVC.URL=[NSURL URLWithString:@"http://www.kimree.com.cn"];
    webVC.mode=WebBrowserModeModal;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)nearbyStoreTapAction{
//    [self.navigationController pushViewController:[[NearbyViewController alloc] init] animated:YES];
    [self.tabBarController setSelectedIndex:1];
}

- (void)recordTapAction{
    TradeRecordViewController *tradeRecordVC = [[TradeRecordViewController alloc] init];
    tradeRecordVC.tradeRecordType = TradeRecordTypeCustomer;
    [self.navigationController pushViewController:tradeRecordVC animated:YES];
}

- (void)feedbackTapAction{
    [self feedback];
}

#pragma mark -

//feedback view
-(void)feedback{
    UIViewController *feedbackVC=[[UIViewController  alloc] init];
    self.feedbackVC = feedbackVC;
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
    _information.delegate = self;
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

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.feedbackVC.view endEditing:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
