//
//  LaunchView.h
//  haitaotong
//
//  Created by 淘海科技 on 14-2-7.
//  Copyright (c) 2014年 淘海科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LaunchView;
@protocol LaunchViewDelegate <NSObject>
- (void)launchViewWillDisappear:(LaunchView *)launchView;
- (void)launchViewDidDisappear:(LaunchView *)launchView;
@end

@interface LaunchView : UIView

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign) id<LaunchViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
              image:(UIImage *)image
           delegate:(id<LaunchViewDelegate>)delegate;

- (id)initWithImage:(UIImage *)image
           delegate:(id<LaunchViewDelegate>)delegate;

- (id)initWithDelegate:(id<LaunchViewDelegate>)delegate;

- (void)showInView:(UIView *)view delay:(NSTimeInterval)interval;
@end












