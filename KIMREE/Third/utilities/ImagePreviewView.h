//
//  ImagePreviewView.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-28.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

/**
 * @brief 图片预览，静态图片，gif图片，拖拉放大缩小，保存图片至本地（gif会保存成静态）
 */
@protocol ImagePreviewViewDelegate <NSObject>

@optional
- (void)didTapPreviewView;

@end

@interface ImagePreviewView : UIView <UIScrollViewDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *_hud;
    UIScrollView *_imageScrollView;
    UIImageView *_previewImageView;
    UIButton *_saveImageButton;
}

@property (nonatomic) CGFloat previewWidth;
@property (nonatomic) CGFloat previewHeight;
@property (nonatomic, assign) id<ImagePreviewViewDelegate> delegate;

- (void)initImageWithURL:(NSString *)url;
- (void)resetLayoutByPreviewImageView;

@end
