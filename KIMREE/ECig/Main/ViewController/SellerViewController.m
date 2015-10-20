//
//  SellerViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/8.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "SellerViewController.h"
//#import "MemberSettingViewController.h"
#import "SellerSettingViewController.h"
#import "TradeInputViewController.h"
#import "TradeRecordViewController.h"
#import "ScanViewController.h"
#import "AFNetworking.h"

@interface SellerViewController ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation SellerViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KM_REFRESH_LOGIN_USER_INFO object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.translucentTabBar = NO;
    self.translucentNavigationBar = NO;
    
    self.title = @"销售中心";
    
    self.manager = [AFHTTPRequestOperationManager manager];
    [_manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [_manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [_manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    
    // 初始化界面数据
    [self initPageInfo];
    
    // 右上方 设置按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)];
    
    // 点击手势
    [self initTapGR];
    
    // 监控登录用户数据刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initPageInfo) name:KM_REFRESH_LOGIN_USER_INFO object:nil];
}


- (void)initPageInfo{
    NSString *userName = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_nickname"];
    if (userName.length == 0) {
        userName = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_name"];
    }
    self.dealerNameLabel.text = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"dealer_connector"];
    self.customerNameLabel.text = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"dealer_email"];
    self.dealerPhoneLabel.text = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"dealer_telephone"];
    
    if ([[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"dealer_headimage"] length] <= 0) {
        [self.dealerImageView setImage:[UIImage imageNamed:@"accountHeader"]];
    }else{
        [self.dealerImageView setImageWithURL:[NSURL URLWithString:[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"dealer_headimage"]]];
        
        self.dealerImageView.layer.masksToBounds = YES;
        self.dealerImageView.layer.cornerRadius = 50.5;
        self.dealerImageView.layer.borderWidth = 3;
        self.dealerImageView.layer.borderColor = RGB(202, 201, 200).CGColor;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)settingAction{
    [self.navigationController pushViewController:[[SellerSettingViewController alloc] init] animated:YES];
}

- (void)initTapGR{
    // 赠品查询
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giftRecordAction)];
    [self.giftRecordView addGestureRecognizer:singleTap];
    
    // 交易录入
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tradeInputAction)];
    [self.tradeView addGestureRecognizer:singleTap];
    
    // 交易记录
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tradeRecordAction)];
    [self.sellRecordView addGestureRecognizer:singleTap];
}

- (void)giftRecordAction{
    // 扫描客户会员卡后，查询客户的赠品记录
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    scanVC.title = @"扫描客户会员卡";
    scanVC.scanType = ScanCodeTypeQRCode;
    
    __unsafe_unretained SellerViewController *blockSelf = self;
    scanVC.finishBlock = ^(ScanViewController *vc, NSString *vipCard){
        // 关闭扫描界面
        [vc goBack];
        
        NSData *jsonData = [vipCard dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        
        blockSelf.progressHUD.mode = MBProgressHUDModeIndeterminate;
        blockSelf.progressHUD.labelText = @"Loading...";
        [blockSelf.progressHUD show:YES];
        [self.manager POST:API_CHECKVIP_URL parameters:jsonDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *jsonDic = (NSDictionary *)responseObject;
            NSInteger code = [[jsonDic objectForKey:@"code"] integerValue];
            if (code == 1) {
                TradeRecordViewController *giftRecordVC = [[TradeRecordViewController alloc] init];
                giftRecordVC.tradeRecordType = TradeRecordTypeGift;
                giftRecordVC.customerInfoDic = [jsonDic objectForKey:@"data"];
                [blockSelf.navigationController pushViewController:giftRecordVC animated:YES];
                
                [blockSelf.progressHUD hide:YES];
            }else{
                blockSelf.progressHUD.mode = MBProgressHUDModeText;
                blockSelf.progressHUD.labelText = [jsonDic objectForKey:@"data"];
                [blockSelf.progressHUD hide:YES afterDelay:3];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            blockSelf.progressHUD.mode = MBProgressHUDModeText;
            blockSelf.progressHUD.labelText = [error localizedDescription];
            [blockSelf.progressHUD hide:YES afterDelay:3];
        }];
    };
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)tradeInputAction{
    TradeInputViewController *tradeInputVC = [[TradeInputViewController alloc] init];
    [self.navigationController pushViewController:tradeInputVC animated:YES];
}

- (void)tradeRecordAction{
    TradeRecordViewController *tradeRecordVC = [[TradeRecordViewController alloc] init];
    tradeRecordVC.tradeRecordType = TradeRecordTypeDealer;
    [self.navigationController pushViewController:tradeRecordVC animated:YES];
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
