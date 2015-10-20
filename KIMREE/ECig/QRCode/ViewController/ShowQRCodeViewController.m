//
//  ShowQRCodeViewController.m
//  KMVip
//
//  Created by JIRUI on 15/4/27.
//  Copyright (c) 2015年 kimree. All rights reserved.
//

#import "BaseViewController.h"
#import "ShowQRCodeViewController.h"
#import "MDQRCodeGenerator.h"

@interface ShowQRCodeViewController ()

@property (strong, nonatomic) UIImageView *qrcodeView;
@property (strong, nonatomic) MDQRCodeGenerator *qrcodeMD;
@property (strong, nonatomic) UIButton *locationBtn;

@end

@implementation ShowQRCodeViewController

- (void)dealloc{
    NSLog(@"ShowQRCodeViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    UINavigationItem *naviItem = nil;
    if (self.navigationController) {
        naviItem = self.navigationItem;
    }else{
        UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:(CGRect){{0,0}, {KM_SCREEN_WIDTH,64}}];
        naviItem = [[UINavigationItem alloc] init];
        [naviBar pushNavigationItem:naviItem animated:YES];
        [self.view addSubview:naviBar];
        
    }
//    naviItem.title = NSLocalizedString(@"Show VIP Card", "");
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    // 返回手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)goBack{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - initView
- (void)initView{
    CGFloat w = KM_SCREEN_WIDTH * 2.0 / 3.0;
    CGFloat h = w;
    CGRect frame = CGRectMake((KM_SCREEN_WIDTH - w) / 2.0, (KM_SCREEN_HEIGHT - h) / 2.0, w, h);
    
    if (self.qrcodeMD == nil) {
        self.qrcodeMD = [[MDQRCodeGenerator alloc] init];
    }
    
    self.qrcodeView = [[UIImageView alloc] initWithFrame:frame];
    self.qrcodeView.image = [self.qrcodeMD createQRForString:_qrcodeInfo];
    [self.view addSubview:self.qrcodeView];
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
