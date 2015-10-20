//
//  UIView+Frame.h
//  haitaotong
//
//  Created by 淘海科技 on 13-11-22.
//  Copyright (c) 2013年 淘海科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;
@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;
@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;
@property(nonatomic,readonly) CGRect screenFrame;

@end
