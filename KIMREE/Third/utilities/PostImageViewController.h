//
//  ImagePreviewView.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-28.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePreviewView.h"

/**
 * @brief 全屏显示静态图片，gif图片，拖拉放大缩小，保存图片至本地（gif会保存成静态）
 */
@interface PostImageViewController : UIViewController <ImagePreviewViewDelegate>
{
    ImagePreviewView *_previewView;
    NSString *_postImageURL;
}

- (void)sePostImageURL:(NSString *)url;

@end
