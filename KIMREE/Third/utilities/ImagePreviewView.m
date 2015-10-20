//
//  ImagePreviewView.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-28.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import "ImagePreviewView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+animatedGIF.h"
#define kDeviceWidth                [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight               [UIScreen mainScreen].bounds.size.height
@implementation ImagePreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        _previewWidth = kDeviceWidth;
        _previewHeight = KDeviceHeight;
        
        _imageScrollView = [[UIScrollView alloc] init];
        _imageScrollView.delegate = self;
        _imageScrollView.bounces = YES;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        //_imageScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _imageScrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        [self addTapGesture];
        [self addSubview:_imageScrollView];
        
        [self initPreivewImageView];
        [self initSavePreviewImageButton];
    }
    return self;
}

#pragma mark - InitView methods

- (void)initPreivewImageView
{
    _previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _previewImageView.image = [UIImage imageNamed:@"thumb_pic.png"];
    [_imageScrollView addSubview:_previewImageView];
    [self resetLayoutByPreviewImageView];
}

- (void)initSavePreviewImageButton
{
    _saveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageButton.frame = CGRectMake(_previewWidth - 70, _previewHeight - 80, 49, 36);
    [_saveImageButton setImage:[UIImage imageNamed:@"icon_save.png"] forState:UIControlStateNormal];
    [_saveImageButton setImage:[UIImage imageNamed:@"icon_save_active.png"] forState:UIControlStateSelected];
    [_saveImageButton addTarget:self action:@selector(savePreviewImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageButton];
}

//在图片上加tap，点击后退出预览
- (void)addTapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_imageScrollView addGestureRecognizer:tapGesture];
}

#pragma mark - Public method

//从网络上加载，依赖外部包
- (void)initImageWithURL:(NSString *)url
{
    [self showProgressHUD];
    __block ImagePreviewView *blockSelf = self;
    if ([url hasSuffix:@"gif"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:url]];
            if (!image) {
                [self showCompletedHUD:NSLocalizedString(@"Load failed!", nil)];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_previewImageView setImage:image];
                    [self configPreviewImageViewWithImage:image];
                });
            }
        });
    }
    else {
        [_previewImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"thumb_pic.png"]success:^(UIImage *image,BOOL cached) {
            [blockSelf configPreviewImageViewWithImage:image];
        } failure:^(NSError *error) {
            [blockSelf showCompletedHUD:NSLocalizedString(@"Load failed!", nil)];
        }];
    }
}

#pragma mark - HUD methods

- (void)showProgressHUD
{
    if (_hud) return;
    
    _hud = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:_hud];
    _hud.delegate = self;
    [_hud show:YES];
}

- (void)showCompletedHUD:(NSString *)message
{
    assert(_hud);
    
    _hud.labelText = message;
    _hud.mode = MBProgressHUDModeText;
    [_hud hide:YES afterDelay:1];
}

#pragma mark - MBHUD delegate method

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    assert(hud == _hud);
    
    [_hud removeFromSuperview];
    _hud = nil;
}

#pragma mark - UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _previewImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //当捏或移动时，需要对center重新定义以达到居中显示位置
    [self centerPreviewImageView];
}

#pragma mark - private methods

//重置Scrollview
- (void)resetLayoutByPreviewImageView
{
    self.frame = CGRectMake(0, 0, _previewWidth, _previewHeight);
    _imageScrollView.frame = CGRectMake(0, 0, _previewWidth, _previewHeight);
    _saveImageButton.frame = CGRectMake(_previewWidth - 70, _previewHeight - 60, 49, 36);
    
    _imageScrollView.zoomScale = _imageScrollView.maximumZoomScale = _imageScrollView.minimumZoomScale = 1;
    
    CGRect bounds = _imageScrollView.bounds;
    CGRect imageFrame = _previewImageView.frame;
    
    CGFloat xScale = CGRectGetWidth(bounds) / CGRectGetWidth(imageFrame);
    CGFloat yScale = CGRectGetHeight(bounds) / CGRectGetHeight(imageFrame);
    CGFloat minScale = MIN(xScale, yScale);
    
    CGFloat width = CGRectGetWidth(imageFrame);
    CGFloat height = CGRectGetHeight(imageFrame);
    CGFloat top = MAX(0, floorf((CGRectGetHeight(bounds) - height) / 2));
    CGFloat left = MAX(0, floorf((CGRectGetWidth(bounds) - width) / 2));
    [_previewImageView setFrame:CGRectMake(left, top, width, height)];
    
    _imageScrollView.contentSize = CGSizeMake(width, height);
    _imageScrollView.contentOffset =  CGPointZero;
    _imageScrollView.maximumZoomScale = MAX(2, 2 * minScale);
    _imageScrollView.minimumZoomScale = minScale;
    _imageScrollView.zoomScale = minScale;
}

//使图像始终在屏幕正中央
- (void)centerPreviewImageView
{
    CGSize boundsSize = _imageScrollView.bounds.size;
    CGRect frameToCenter = _previewImageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2);
    } else {
        frameToCenter.origin.x = 0;
    }
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2);
    } else {
        frameToCenter.origin.y = 0;
    }
    //center
    if (!CGRectEqualToRect(_previewImageView.frame, frameToCenter)) {
        _previewImageView.frame = frameToCenter;
    }
}

/**
 * @brief 加载图片成功后设置image's frame
 */
- (void)configPreviewImageViewWithImage:(UIImage *)image
{
    CGRect rect = _previewImageView.frame;
    rect.size.width = image.size.width;
    rect.size.height = image.size.height;
    _previewImageView.frame = rect;
    [self resetLayoutByPreviewImageView];
    [_hud hide:YES afterDelay:1];
}

//接收点击图片事件
- (void)handleSingleTap:(UITapGestureRecognizer *)gesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTapPreviewView)]) {
        [_delegate didTapPreviewView];
    }
}

/**
 * @brief save image
 */
- (void)savePreviewImage
{
    [self showProgressHUD];
    //当前只支持保存普通图片
    UIImageWriteToSavedPhotosAlbum(_previewImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
    //该方法支持保存各种格式的图片
    /*
    ALAssetsLibrary *alLibrary = [[ALAssetsLibrary alloc] init];
    [alLibrary writeImageDataToSavedPhotosAlbum:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ww3.sinaimg.cn/large/89318f8cjw1e5pypooi1sg207i04b165.gif"]] metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"completion");
        [self showCompletedHUD:@"ok"];
    }];
    [alLibrary release];
     */
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message =NSLocalizedString(@"Ha ha!", nil);
    if (!error) {
        message = NSLocalizedString( @"Successfully saved to the photo album", nil);
        _saveImageButton.selected = YES;
        _saveImageButton.enabled = NO;
    }
    else {
        message = [error description];
    }
    
    [self showCompletedHUD:message];
}

@end
