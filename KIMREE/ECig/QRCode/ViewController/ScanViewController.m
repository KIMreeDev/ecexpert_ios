//
//  ScanViewController.m
//  Demo
//
//  Created by JIRUI on 15/4/23.
//  Copyright (c) 2015年 kimree. All rights reserved.
//

#import "BaseViewController.h"
#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"

#define SCAN_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCAN_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCAN_WIDTH (SCAN_SCREEN_WIDTH - 100)
#define SCAN_HEIGHT (SCAN_SCREEN_WIDTH - 100)

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    NSTimer *_timer;
    BOOL frontNavigationBarTranslucent, frontTabBarTranslucent;
}

@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation ScanViewController

- (void)dealloc{

    NSLog(@"ScanViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self paramInit];
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.translucent = YES;
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
    if ([_device hasTorch]) {
        [_device lockForConfiguration:nil];
        if ([_device torchMode] == AVCaptureTorchModeOff) {
            [_device setTorchMode: AVCaptureTorchModeOn];
        }else{
            [_device setTorchMode: AVCaptureTorchModeOff];
        }
        [_device unlockForConfiguration];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - param init
- (void) paramInit{
    // 1. 摄像头设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入
    NSError *error;
    _input = [[AVCaptureDeviceInput alloc] initWithDevice:_device error:&error];
    if (error != nil) {
        NSLog(@"no input device  %@", [error localizedDescription]);
        return;
    }
    
    // 3. 设置输出(Metadata元数据)
    _output = [[AVCaptureMetadataOutput alloc] init];
    CGFloat x = (SCAN_SCREEN_WIDTH - SCAN_WIDTH) / 2.0;
    CGFloat y = (SCAN_SCREEN_HEIGHT - SCAN_HEIGHT) / 2.0;
    CGRect scanRect = (CGRect){ {y / SCAN_SCREEN_HEIGHT, x / SCAN_SCREEN_WIDTH} , {SCAN_HEIGHT / SCAN_SCREEN_HEIGHT, SCAN_WIDTH / SCAN_SCREEN_WIDTH}};
    [_output setRectOfInterest:scanRect];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    // 4. 拍摄会话
    _session = [[AVCaptureSession alloc] init];
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    // 4.1 设置输出的格式
    // 提示：一定要先设置会话的输出为output之后，再指定输出的元数据类型！
//    [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    switch (self.scanType) {
        case ScanCodeTypeAll:{
                [_output setMetadataObjectTypes:@[AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode]];
            }
            break;
        case ScanCodeTypeBarCode:{
                [_output setMetadataObjectTypes:@[AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code]];
            }
            break;
        case ScanCodeTypeQRCode:{
                [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            }
            break;
        default:
            break;
    }
    
    
    // 5. 设置预览图层（用来让用户能够看到扫描情况）
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    [_preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_preview setFrame:self.view.bounds];
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    
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
    
    [_session startRunning];

}

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

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{

    // 1. 如果扫描完成，停止会话
    [_session stopRunning];
    // 2. 删除预览图层
    [_preview removeFromSuperlayer];
    
//    // 取消定时器
//    [_timer invalidate];
//    _timer = nil;
    
    AVMetadataMachineReadableCodeObject *result = metadataObjects[0];
    NSString *scanMsg = [result stringValue];
    
    __unsafe_unretained ScanViewController *blockSelf = self;
    if (_finishBlock != nil) {
        _finishBlock(blockSelf, scanMsg);
    }
//    [self goBack];
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
