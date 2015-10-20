//
//  UIView+Addition.h
//  haitaotong
//
//  Created by 淘海科技 on 14-1-17.
//  Copyright (c) 2014年 淘海科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)
//是否显示底部横线
- (void)addBottomLine:(UIColor *)lineColor;
//是否显示顶部横线
- (void)addTopLine:(UIColor *)lineColor;
//是否显示左部竖线
- (void)addLeftLine:(UIColor *)lineColor;
//是否显示右部竖线
- (void)addRightLine:(UIColor *)lineColor;
//显示四周边框
- (void)showBorder:(UIColor *)lineColor;
//四周边框变圆
- (void)circleWithCornerRadius:(CGFloat)radius;
//移除子视图
- (void)removeAllSubviews;
@end
