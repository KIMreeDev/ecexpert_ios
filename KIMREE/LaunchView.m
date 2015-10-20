//
//  LaunchView.m
//  haitaotong
//
//  Created by 淘海科技 on 14-2-7.
//  Copyright (c) 2014年 淘海科技. All rights reserved.
//

#import "LaunchView.h"

@interface LaunchView ()
{
  UIImageView *_launchImageView;
}
@end

@implementation LaunchView

- (void)createLaunchImageView
{
  _launchImageView = [[UIImageView alloc] initWithFrame:self.bounds];
  _launchImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [self addSubview:_launchImageView];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self createLaunchImageView];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
              image:(UIImage *)image
           delegate:(id<LaunchViewDelegate>)delegate
{
  self = [super initWithFrame:frame];
  if (self) {
    [self createLaunchImageView];
    self.image = image;
    self.delegate = delegate;
  }
  return self;
}

- (id)initWithImage:(UIImage *)image
           delegate:(id<LaunchViewDelegate>)delegate
{
  self = [super initWithFrame:[UIScreen mainScreen].bounds];
  if (self) {
    [self createLaunchImageView];
    self.image = image;
    self.delegate = delegate;
  }
  return self;
}

- (id)initWithDelegate:(id<LaunchViewDelegate>)delegate
{
  self = [super initWithFrame:[UIScreen mainScreen].bounds];
  if (self) {
    [self createLaunchImageView];//启动图片
    NSString *imageNamed = [SystemHelper isLongScreen] ? @"Default_h" : @"Default";
    self.image = [UIImage imageNamed:imageNamed];
    self.delegate = delegate;
  }
  return self;
}

- (void)showInView:(UIView *)view delay:(NSTimeInterval)interval
{
  _launchImageView.image = self.image;
  [view addSubview:self];
  [self performSelector:@selector(hidden) withObject:nil afterDelay:interval];
}

- (void)hidden
{
  if (self.delegate && [self.delegate respondsToSelector:@selector(launchViewWillDisappear:)]) {
    [self.delegate launchViewWillDisappear:self];
  }
  [UIView animateWithDuration:1.5f
                   animations:^(void){
                     self.alpha = 0.0f;
                   }
                   completion:^(BOOL finished){
                     if (finished) {
                       if (self.delegate && [self.delegate respondsToSelector:@selector(launchViewDidDisappear:)]) {
                         [self.delegate launchViewDidDisappear:self];
                       }
                       [self removeFromSuperview];
                     }
                   }];
}

@end














