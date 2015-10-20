//
//  UIView+Gesture.h
//  haitaotong
//
//  Created by 淘海科技 on 14-1-15.
//  Copyright (c) 2014年 淘海科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Gesture)

/*
 * @brief 添加Tap手势到View
 */
- (void)g_addTapWithTarget:(id)target action:(SEL)action;

@end
