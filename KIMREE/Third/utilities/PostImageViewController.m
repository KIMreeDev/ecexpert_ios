//
//  ImagePreviewView.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-28.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import "PostImageViewController.h"
#define kDeviceWidth                [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight               [UIScreen mainScreen].bounds.size.height

@interface PostImageViewController ()

@end

@implementation PostImageViewController

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
    // Do any additional setup after loading the view from its nib.
    [self initPreviewImage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        _previewView.previewWidth = kDeviceWidth;
        _previewView.previewHeight = KDeviceHeight;
    }
    else {
        _previewView.previewWidth = KDeviceHeight;
        _previewView.previewHeight = kDeviceWidth;
    }
    
    [_previewView resetLayoutByPreviewImageView];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)initPreviewImage
{
    _previewView = [[ImagePreviewView alloc] initWithFrame:CGRectZero];
    _previewView.delegate = self;
    [self.view addSubview:_previewView];
    [_previewView initImageWithURL:_postImageURL];
}

#pragma mark - XWImagePreviewView delegate method

- (void)didTapPreviewView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Public method

- (void)sePostImageURL:(NSString *)url
{
    _postImageURL = @"";
    _postImageURL = url;
}

@end
