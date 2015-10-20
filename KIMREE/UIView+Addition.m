//
//  UIView+Addition.m
//  haitaotong
//
//  Created by 淘海科技 on 14-1-17.
//  Copyright (c) 2014年 淘海科技. All rights reserved.
//

#import "UIView+Addition.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Addition)

//是否显示底部横线
- (void)addBottomLine:(UIColor *)lineColor
{
  UIView *_line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
  _line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  _line.backgroundColor = lineColor;
  [self addSubview:_line];
}

//是否显示顶部横线
- (void)addTopLine:(UIColor *)lineColor
{
  UIView *_line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
  _line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  _line.backgroundColor = lineColor;
  [self addSubview:_line];
}

//是否显示左部竖线
- (void)addLeftLine:(UIColor *)lineColor
{
  UIView *_line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
  _line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  _line.backgroundColor = lineColor;
  [self addSubview:_line];
}

//是否显示右部竖线
- (void)addRightLine:(UIColor *)lineColor
{
  UIView *_line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-0.5, 0, 0.5, self.frame.size.height)];
  _line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  _line.backgroundColor = lineColor;
  [self addSubview:_line];
}

//是否显示四周边框
- (void)showBorder:(UIColor *)lineColor
{
  self.layer.borderWidth = 0.5;
  self.layer.borderColor = lineColor.CGColor;
}

//四周边框变圆
- (void)circleWithCornerRadius:(CGFloat)radius
{
  self.layer.masksToBounds = YES;
  self.layer.cornerRadius = radius;
}

//移除子视图
- (void)removeAllSubviews
{
  for (UIView *view in self.subviews) {
    [view removeFromSuperview];
  }
}
@end
