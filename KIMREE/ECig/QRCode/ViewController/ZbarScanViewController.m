//
//  ZbarScanViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/26.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "ZbarScanViewController.h"
#import "ZBarSDK.h"

#define SCAN_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCAN_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCAN_WIDTH (SCAN_SCREEN_WIDTH - 100)
#define SCAN_HEIGHT (SCAN_SCREEN_WIDTH - 100)

@interface ZbarScanViewController ()<ZBarReaderViewDelegate> {
    NSTimer *_timer;
    ZBarReaderView *_readerView;
}

@end

@implementation ZbarScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self paramInit];
    [self navigationInit];
    [_readerView start];
}

/**
 *  初始化navigationBar的返回按钮和开灯按钮
 */
- (void)navigationInit{
    UINavigationItem *naviItem = nil;
    if (self.navigationController) {
        naviItem = self.navigationItem;
    }else{
        UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:(CGRect){{0,0}, {SCAN_SCREEN_WIDTH,64}}];
        naviItem = [[UINavigationItem alloc] init];
        [naviBar pushNavigationItem:naviItem animated:YES];
        [self.view addSubview:naviBar];
        
    }
    //    naviItem.title = NSLocalizedString(@"Scan QR Code", "");
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan_light"] style:UIBarButtonItemStylePlain target:self action:@selector(light)];
    
    // 返回手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
}

- (void)goBack{
    // 取消定时器,确保定时器取消，不然无法释放
    [_timer invalidate];
    _timer = nil;
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)light{
    if ([_readerView torchMode] == 1) {
        _readerView.torchMode = 0;
    }else{
        _readerView.torchMode = 1;
    }
}

- (void) paramInit{
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    //初始化
    _readerView = [[ZBarReaderView alloc] init];
    _readerView.frame = frame;
    _readerView.backgroundColor = [UIColor clearColor];
    
    // 设置扫描条形码的参数
    [_readerView.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    //设置代理
    _readerView.readerDelegate = self;
    
    //不显示跟踪框
    _readerView.tracksSymbols = YES;
    
    //关闭闪关灯
    _readerView.torchMode = 0;
    
    //二维码拍摄的屏幕大小
    CGRect rvBounsRect = _readerView.frame;
    
    //二维码拍摄时，可扫描区域的大小
    CGFloat x = (SCAN_SCREEN_WIDTH - SCAN_WIDTH) / 2.0;
    CGFloat y = (SCAN_SCREEN_HEIGHT - SCAN_HEIGHT) / 2.0;
    CGFloat w = SCAN_WIDTH;
    CGFloat h = SCAN_HEIGHT;
    
//    CGRect scanRect = (CGRect){ {y / SCAN_SCREEN_HEIGHT, x / SCAN_SCREEN_WIDTH} , {h / SCAN_SCREEN_HEIGHT, w / SCAN_SCREEN_WIDTH}};
    
    //设置ZBarReaderView的scanCrop属性
    _readerView.scanCrop = [self getScanCrop:CGRectMake(x, y, w, h) readerViewBounds:rvBounsRect];
    [self.view addSubview:_readerView];
    
    
    // 6. 设置遮掩层
    UIColor *alphaColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIView *topView = [[UIView alloc] initWithFrame:(CGRect){{0,0}, {SCAN_SCREEN_WIDTH, y}}];
    topView.backgroundColor = alphaColor;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:(CGRect){{0,y+SCAN_HEIGHT}, {SCAN_SCREEN_WIDTH, SCAN_SCREEN_HEIGHT - SCAN_HEIGHT}}];
    bottomView.backgroundColor = alphaColor;
    
    UIView *leftView = [[UIView alloc] initWithFrame:(CGRect){{0,y}, {x, SCAN_HEIGHT}}];
    leftView.backgroundColor = alphaColor;
    
    UIView *rightView = [[UIView alloc] initWithFrame:(CGRect){{x+SCAN_WIDTH,y}, {SCAN_SCREEN_WIDTH - x - SCAN_WIDTH, SCAN_HEIGHT}}];
    rightView.backgroundColor = alphaColor;
    
    UIView *centerView = [[UIView alloc] initWithFrame:(CGRect){{x,y}, {SCAN_WIDTH, SCAN_HEIGHT}}];
    UIImageView *borderView = [[UIImageView alloc] initWithFrame:centerView.bounds];
    borderView.image = [UIImage imageNamed:@"scan_border"];
    borderView.contentMode = UIViewContentModeScaleToFill;
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:(CGRect){{5,5}, {SCAN_WIDTH-10,5}}];
    lineView.image = [UIImage imageNamed:@"scan_line"];
    lineView.contentMode = UIViewContentModeScaleToFill;
    
    [centerView addSubview:borderView];
    [centerView addSubview:lineView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(lineMove:) userInfo:lineView repeats:YES];
    
    centerView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    [self.view addSubview:leftView];
    [self.view addSubview:rightView];
    [self.view addSubview:centerView];
}

/**
 *  扫描动画效果
 *
 *  @param timer 定时器
 */
- (void)lineMove:(NSTimer *) timer{
    UIImageView *lineView = (UIImageView*)timer.userInfo;
    CGFloat maxY = SCAN_HEIGHT - 10;
    CGFloat minY = 5;
    CGFloat lineY = lineView.frame.origin.y;
    CGFloat increase = 5;
    CGFloat nextY = lineY;
    if ((lineY + increase > maxY)) {
        nextY = minY;
        
        CGRect nextFrame = (CGRect){{lineView.frame.origin.x,nextY}, {lineView.frame.size.width, lineView.frame.size.height}};
        lineView.frame = nextFrame;
        
    }else{
        nextY = lineY + increase;
        
        [UIView beginAnimations:nil context:nil];
        CGRect nextFrame = (CGRect){{lineView.frame.origin.x,nextY}, {lineView.frame.size.width, lineView.frame.size.height}};
        lineView.frame = nextFrame;
        [UIView commitAnimations];
    }
}

/**
 *  设置可扫描区的scanCrop的方法
 *
 *  @param rect     扫描区域大小
 *  @param rvBounds 扫描屏幕大小
 *
 *  @return <#return value description#>
 */
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)rvBounds
{
    CGFloat x,y,width,height;
    x = rect.origin.y / rvBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / rvBounds.size.width;
    width = (rect.origin.y + rect.size.height) / rvBounds.size.height;
    height = 1 - rect.origin.x / rvBounds.size.width;
    
    //    x = rect.origin.x / rvBounds.size.width;
    //    y = rect.origin.y / rvBounds.size.height;
    //    width = rect.size.width / rvBounds.size.width;
    //    height = rect.size.height / rvBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZBarReaderViewDelegate
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image{
    [_readerView stop];
    [_readerView removeFromSuperview];
    
    NSString *scanResult = @"";
    for (ZBarSymbol *symbol in symbols) {
        scanResult = symbol.data;
        break;
    }
    
    __unsafe_unretained ZbarScanViewController *blockSelf = self;
    if (_finishBlock != nil) {
        _finishBlock(blockSelf, scanResult);
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
