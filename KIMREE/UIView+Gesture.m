//
//  UIView+Gesture.m
//  haitaotong
//
//  Created by 淘海科技 on 14-1-15.
//  Copyright (c) 2014年 淘海科技. All rights reserved.
//

#import "UIView+Gesture.h"

@implementation UIView (Gesture)
/*
 * @brief 添加Tap手势到View
 */
- (void)g_addTapWithTarget:(id)target action:(SEL)action
{
  self.userInteractionEnabled = YES;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
  [self addGestureRecognizer:tap];
}
@end
