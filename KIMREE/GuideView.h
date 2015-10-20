//
//  GuideView.h
//  haitaotong
//
//  Created by 淘海科技 on 14-2-7.
//  Copyright (c) 2014年 淘海科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Addition.h"
#import "UIView+Frame.h"
#import "UIView+Gesture.h"
@class GuideView;
@protocol GuideViewDelegate <NSObject>

- (void)guideViewWillDisappear:(GuideView *)guideView;
- (void)guideViewDidDisappear:(GuideView *)guideView;

@end

@interface GuideView : UIView
@property (nonatomic,strong) NSArray *images;
@property (nonatomic) id<GuideViewDelegate> delegate;

+ (BOOL)isFirstLaunchApp;

- (id)initWithFrame:(CGRect)frame
             images:(NSArray *)images
           delegate:(id<GuideViewDelegate>)delegate;

- (id)initWithImages:(NSArray *)images
            delegate:(id<GuideViewDelegate>)delegate;

- (void)showInView:(UIView *)view;

@end













