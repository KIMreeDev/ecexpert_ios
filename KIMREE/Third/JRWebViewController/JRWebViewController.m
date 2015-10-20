//
//  HZWebViewController.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-14.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//已更改为本项目专用

#import "JRWebViewController.h"
#import "UIView+Screenshot.h"
#import "UIImage+Blur.h"
#import "JRWebViewProgress.h"
#import "JRWebViewProgressView.h"


#define HZFSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define HZUIColorFromRGB(colorRed,colorGreen,colorBlue)  [UIColor colorWithRed:(colorRed)/255.0 green:(colorGreen)/255.0 blue:(colorBlue)/255.0 alpha:1.0]
#define HZPNGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]

#define HZ_App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define HZ_App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

#define kNavBarHeight                   44
#define kTooBarHeight                   49
#define kNavigationAndStatusBarHeight   64
CGFloat const HZProgressBarHeight = 2.5;
NSInteger const HZProgresstagId = 222122323;

@implementation XToolBar
- (UIImage *)createImage:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)drawRect:(CGRect)rect {
    if(HZFSystemVersion >= 7.0f){
        //        [PBPNGIMAGE(@"pb_tabbar_background_os7") drawInRect:rect];
        [[self createImage:[UIColor whiteColor]] drawInRect:rect];
    }
    else
        [HZPNGIMAGE(@"pb_tabbar_background") drawInRect:rect];
}
@end

@interface JRWebViewController () <UIPopoverControllerDelegate ,UIActionSheetDelegate,NJKWebViewProgressDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIBarButtonItem *stopLoadingButton;
@property (strong, nonatomic) UIBarButtonItem *reloadButton;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) UIBarButtonItem *forwardButton;

@property (strong, nonatomic) UIPopoverController *activitiyPopoverController;

@property (nonatomic,strong) JRWebViewProgress *progressProxy;

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) XToolBar *toolBar;

@end

@implementation JRWebViewController

//不隐藏状态栏，貌似无效
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden
{
    return NO; //返回NO表示要显示，返回YES将hiden
}


- (void)load
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    [self.webView loadRequest:request];
    
}

- (void)clear
{
    [self.webView loadHTMLString:@"" baseURL:nil];
    self.titleLb.text = @"";
    self.title = @"";
}

#pragma mark - View controller lifecycle
- (void)dealloc
{
    NSLog(@"JRWebViewController dealloc");
}
- (UIViewController *)getCurrentRootViewController {
    
    UIViewController *result;
    
    // Try to find the root view controller programmically
    
    // Find the top window (that is not an alert view or other window)
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    
    return result;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _isTap=NO;
    self.navigationController.title = NSLocalizedString(@"News", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //  //blur background
    //  UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
    //  UIImage *screensImage = [[self getCurrentRootViewController].view screenshot];
    //  screensImage = [screensImage applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:1.8 maskImage:nil];
    //  [backgroundView setImage:screensImage];
    //  [self.view addSubview:backgroundView];
    
    
    
    //webview
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    
    [self.view addSubview:self.webView];
    
    
    
    //progress
    _progressProxy = [[JRWebViewProgress alloc] init];
    
    
    [self setupToolBarItems];
    //PBWebBrowserModeModal 模式自定义nav   ios7 以下PBWebBrowserModeNavigation 也自定义nav
    if(self.mode == WebBrowserModeModal){
        CGRect webViewRect = self.view.frame;
        
        if(HZFSystemVersion >= 7.0){
            self.edgesForExtendedLayout = UIRectEdgeNone;
            // 仅仅是  self.edgesForExtendedLayout = UIRectEdgeNone  界面任就显示异常， rect需要减去navigationBar 和 statusBar 的64
            webViewRect = CGRectMake(webViewRect.origin.x, 0, webViewRect.size.width, webViewRect.size.height-kTooBarHeight - kNavigationAndStatusBarHeight);
        }
        else{
            webViewRect = CGRectMake(webViewRect.origin.x, 0, webViewRect.size.width, webViewRect.size.height-kTooBarHeight);
        }
        self.webView.frame = webViewRect;
    }
    else if (self.mode == WebBrowserModeNavigation){
        CGRect webViewRect = self.view.frame;
        
        if(HZFSystemVersion >= 7.0)
            self.webView.frame = CGRectMake(webViewRect.origin.x, kNavBarHeight+20, webViewRect.size.width, webViewRect.size.height-kNavBarHeight-kTooBarHeight-20);
        else
            self.webView.frame = CGRectMake(webViewRect.origin.x, kNavBarHeight, webViewRect.size.width, webViewRect.size.height-kNavBarHeight-kTooBarHeight);
        [self setpNavBar];
        
    }
    
    //    //增加两个滑动手势,一点击手势
    //    UISwipeGestureRecognizer *upRecognizer;
    //    upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp)];
    //    [upRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    //    upRecognizer.delegate=self;
    //    [self.view addGestureRecognizer:upRecognizer];
    //
    //    UISwipeGestureRecognizer *downRecognizer;
    //    downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown)];
    //    [downRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    //    downRecognizer.delegate=self;
    //    [self.view addGestureRecognizer:downRecognizer];
    
    //点击手势,用来判断浏览行为
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleTap];//这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    
    //增加二维码扫描按钮
    //    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qrcode"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoQRCode)];
    
    
    if ([self.navigationController.viewControllers objectAtIndex:0] != self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    }
    
}

- (void)goback{
    // 退出界面前，让tabBar显示出来，并且异常自定义的toolBar
    [self showTabBar:self.tabBarController];
    _toolBar.hidden=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

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
    [self dismissViewControllerAnimated:YES completion:^{
        if ([[result substringToIndex:4] isEqualToString:@"http"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"QRCodeReader", nil) message:result delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
        }
    }];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //版本地狱ios7 并且是PBWebBrowserModeNavigation 模式就隐藏系统的nav用自定义的
    if(self.mode == WebBrowserModeNavigation){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    self.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    if (self.URL) {
        [self load];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self clear];
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Helpers

- (void)setpNavBar
{
    CGRect navRect = CGRectMake(0, 0, self.view.bounds.size.width, kNavBarHeight);
    if(HZFSystemVersion >= 7.0f){
        navRect.origin.y = 20;
    }
    
    UIView *navView = [[UIView alloc] initWithFrame:navRect];
    navView.backgroundColor = HZUIColorFromRGB(246,246,246);
    UIButton *backBt = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = HZPNGIMAGE(@"navigationbar_back");
    
    [backBt setBackgroundImage:image forState:UIControlStateNormal];
    CGSize imageSize = image.size;
    backBt.frame = CGRectMake(10, 5, imageSize.width, imageSize.height);
    [backBt addTarget:self action:@selector(gotoHomePage:) forControlEvents:UIControlEventTouchUpInside];
    //  [navView addSubview:backBt];
    [self.view addSubview:navView];
    
    CGFloat offset = 15.0f;
    self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0, navRect.size.width-(offset+10), kNavBarHeight)];
    self.titleLb.numberOfLines = 1;
    self.titleLb.textAlignment = NSTextAlignmentCenter;
    self.titleLb.backgroundColor = [UIColor clearColor];
    [navView addSubview:self.titleLb];
}



- (UIImage *)leftTriangleImage
{
    static UIImage *image;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        CGSize size = CGSizeMake(14.0f, 16.0f);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.0f, 8.0f)];
        [path addLineToPoint:CGPointMake(14.0f, 0.0f)];
        [path addLineToPoint:CGPointMake(14.0f, 16.0f)];
        [path closePath];
        [path fill];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    return image;
}

- (UIImage *)rightTriangleImage
{
    
    static UIImage *rightTriangleImage;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        UIImage *leftTriangleImage = [self leftTriangleImage];
        
        CGSize size = leftTriangleImage.size;
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGFloat x_mid = size.width / 2.0f;
        CGFloat y_mid = size.height / 2.0f;
        
        CGContextTranslateCTM(context, x_mid, y_mid);
        
        CGContextRotateCTM(context, M_PI);
        [leftTriangleImage drawAtPoint:CGPointMake((x_mid * -1), (y_mid * -1))];
        
        rightTriangleImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    return rightTriangleImage;
    
    
}

- (void)setupToolBarItems
{
    
    //  NSLog(@"%f",self.view.frame.size.height);
    
    self.toolBar = [[XToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, kTooBarHeight)];
    self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.toolBar setBarStyle:UIBarStyleDefault];
    // self.toolBar.backgroundColor = [UIColor clearColor];
    self.toolBar.tintColor=COLOR_LIGHT_BLUE_THEME;
    //到底部只能放到父视图去，否则无效，
    //[self.view addSubview:self.toolBar];
    [self.parentViewController.view addSubview:self.toolBar];
    
    
    self.stopLoadingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                           target:self.webView
                                                                           action:@selector(stopLoading)];
    
    self.reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                      target:self.webView
                                                                      action:@selector(reload)];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[self leftTriangleImage]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self.webView
                                                      action:@selector(goBack)];
    
    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[self rightTriangleImage]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self.webView
                                                         action:@selector(goForward)];
    
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homePage"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoHomePage:)];
    
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                  target:self
                                                                                  action:@selector(action:)];
    
    UIBarButtonItem *space_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                            target:nil
                                                                            action:nil];
    space_.width = 35.0f;
    
    self.toolbarItems = @[closeButton,space_,self.stopLoadingButton, space_, self.backButton, space_, self.forwardButton, space_, actionButton];
    [self.toolBar setItems:self.toolbarItems animated:YES];
    
}

- (void)toggleState
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    
    NSMutableArray *toolbarItems = [self.toolbarItems mutableCopy];
    if (self.webView.loading) {
        toolbarItems[2] = self.stopLoadingButton;
    } else {
        toolbarItems[2] = self.reloadButton;
    }
    self.toolbarItems = [toolbarItems copy];
    
    [self.toolBar setItems:self.toolbarItems animated:YES];
}

- (void)finishLoad
{
    [self toggleState];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

//显示加载进度view
- (JRWebViewProgressView *)setupHZProgressSubviewWithTintColor:(UIColor *)tintColor{
    
    JRWebViewProgressView *progressView;
    for (UIView *subview in [self.view subviews])
    {
        if (subview.tag == HZProgresstagId)
        {
            progressView = (JRWebViewProgressView *)subview;
        }
    }
    
    if(!progressView)
    {
        progressView =  [[JRWebViewProgressView alloc] initWithFrame:CGRectMake(0, self.webView.frame.origin.y, self.webView.frame.size.width, HZProgressBarHeight)];
        progressView.tag = HZProgresstagId;
        //		progressView.backgroundColor = tintColor;
        [self.view addSubview:progressView];
    }
    else
    {
        CGRect progressFrame = progressView.frame;
        progressFrame.origin.y = self.webView.frame.origin.y;
        progressView.frame = progressFrame;
    }
    
    return progressView;
    
}
- (void)viewUpdatesForPercentage:(float)percentage andTintColor:(UIColor *)tintColor
{
    JRWebViewProgressView *progressView = [self setupHZProgressSubviewWithTintColor:tintColor];
    [progressView setProgress:percentage animated:YES];
    return;
}
#pragma mark - Button actions
- (void)gotoHomePage:(id)sender
{
    
    
    //NSURL *url = [[NSURL alloc]initWithString:@"http://m.ecig100.com/"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    
}






- (void)action:(id)sender
{
    UIActionSheet *moreSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"用Safari打开",@"复制链接", nil];
    [moreSheet showInView:self.view];
}

#pragma mark - Web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //用点击行为来判断，点击行为目前判断不准确,不知道是否点击在超链接上
    
    //根据是否是主页来判断是否隐藏工具栏
    if ([request.URL isEqual:self.URL]) {
        [self showTabBar:self.tabBarController];
        _toolBar.hidden=YES;
        
    }else if(_isTap==YES){
        
        [self hideTabBar:self.tabBarController];
        _toolBar.hidden=NO;
        _isTap=NO;
    }
    
    
    
    if ([[request.URL absoluteString] hasPrefix:@"sms:"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    if ([[request.URL absoluteString] hasPrefix:@"http://www.youtube.com/v/"] ||
        [[request.URL absoluteString] hasPrefix:@"http://itunes.apple.com/"] ||
        [[request.URL absoluteString] hasPrefix:@"https://itunes.apple.com/"] ||
        [[request.URL absoluteString] hasPrefix:@"http://phobos.apple.com/"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //标题空时，设为资讯
    if ([self.title isEqualToString:@""]) {
        self.title=NSLocalizedString(@"News", nil);
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self toggleState];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self finishLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.titleLb.text = self.title;
    
    //底栏标题不变
    self.tabBarItem.title=NSLocalizedString(@"News", nil);
    self.URL = self.webView.request.URL;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self finishLoad];
}

#pragma mark - Popover controller delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.activitiyPopoverController = nil;
}


#pragma mark
#pragma mark NJKWebViewProgressDelegate
- (void)webViewProgress:(JRWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    
    if(progress >= 1.0000f)
        self.webView.backgroundColor = [UIColor clearColor];
    [self viewUpdatesForPercentage:progress andTintColor:[UIColor redColor]];
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [UIView animateWithDuration:0.27 animations:^{
            
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[UIApplication sharedApplication] openURL:self.URL];
            break;
        case 1:{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.URL.absoluteString;
        }
            break;
        default:
            break;
    }
}

//增加隐藏及显示底栏的方法，系统的方法有bug

- (void) hideTabBar:(UITabBarController *) tabbarcontroller {
    
    
    float value;
    if (IS_INCH4) {
        value=568.0f;
        
    }else
    {
        value=480.0f;
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, value, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, value)];
        }
    }
    [UIView commitAnimations];
    
    
    for(UIView *view in self.view.subviews)
    {
        view.userInteractionEnabled=YES;
    }
    
    
    
    //  NSLog(@"%@",self.view.subviews);
    
    
}

- (void) showTabBar:(UITabBarController *) tabbarcontroller {
    
    
    float value;
    if (IS_INCH4) {
        
        value=519.0f;
    }else
    {
        
        value=431.0f;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        //NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, value, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, value)];
        }
    }
    [UIView commitAnimations];
}

//根据手势隐藏导航栏
-(void)handleSwipeUp
{
    
    // [self.navigationController  setNavigationBarHidden:YES animated:YES];
    if (_toolBar.hidden==YES) {
        [self hideTabBar:self.tabBarController];
    }
    
    
}

-(void)handleSwipeDown
{
    
    // [self.navigationController  setNavigationBarHidden:NO animated:YES];
    if (_toolBar.hidden==YES) {
        [self showTabBar:self.tabBarController];
    }
    
    
}

-(void)handleSingleTap
{
    _isTap=YES;
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end


