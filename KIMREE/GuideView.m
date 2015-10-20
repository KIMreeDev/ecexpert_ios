//
//  GuideView.m
//  haitaotong
//
//  Created by 淘海科技 on 14-2-7.
//  Copyright (c) 2014年 淘海科技. All rights reserved.
//

#import "GuideView.h"

@interface GuideView ()
{
  UIScrollView *_scrollView;
}
@end

@implementation GuideView

+ (BOOL)isFirstLaunchApp
{
  BOOL isSecondLaunch = [S_USER_DEFAULTS boolForKey:@"GuideIsSecondLaunch"];
  return !isSecondLaunch;
}

- (void)createScrollView
{
  _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.pagingEnabled = YES;
  _scrollView.bounces = NO;
  [self addSubview:_scrollView];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self createScrollView];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
             images:(NSArray *)images
           delegate:(id<GuideViewDelegate>)delegate
{
  self = [super initWithFrame:frame];
  if (self) {
    [self createScrollView];
    self.images = images;
    self.delegate = delegate;
  }
  return self;
}

- (id)initWithImages:(NSArray *)images
            delegate:(id<GuideViewDelegate>)delegate
{
  self = [super initWithFrame:[UIScreen mainScreen].bounds];
  if (self) {
    [self createScrollView];
    self.images = images;
    self.delegate = delegate;
  }
  return self;
}

- (void)showInView:(UIView *)view
{
  [_scrollView removeAllSubviews];
  NSInteger count = self.images.count;
  UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(110, _scrollView.height-50, 100, 20)];
    
  _scrollView.contentSize = CGSizeMake(_scrollView.width*count, _scrollView.height);
  for (NSInteger i=0; i<count; i++) {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.width*i, 0, _scrollView.width, _scrollView.height)];
    imageView.image = [self.images objectAtIndex:i];
 
    label.text = NSLocalizedString(@"Tap to enter", @"");
    label.textColor =COLOR_ECIGARFAN_WHITE;
    label.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:label];

    [_scrollView addSubview:imageView];
  }
  [view addSubview:self];
  [_scrollView g_addTapWithTarget:self action:@selector(hidden)];
}

- (void)hidden
{
  THLog(@"_scrollView.contentOffset.x = %f",_scrollView.contentOffset.x);
  if (_scrollView.contentOffset.x != _scrollView.width * (self.images.count-1)) {
    return;
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(guideViewWillDisappear:)]) {
    [self.delegate guideViewWillDisappear:self];
  }
  [UIView animateWithDuration:1.0f
                   animations:^(void){
                     self.transform = CGAffineTransformMakeScale(1.2, 1.2);
                     self.alpha = 0.0f;
                   }
                   completion:^(BOOL finished){
                     if (finished) {
                       if (self.delegate && [self.delegate respondsToSelector:@selector(guideViewDidDisappear:)]) {
                         [self.delegate guideViewDidDisappear:self];
                       }
                       [self removeFromSuperview];
                     }
                   }];
}

@end



















