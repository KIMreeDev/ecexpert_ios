//
//  UIView+Nib.h
//  haitaotong
//
//  Created by 淘海科技 on 14-1-15.
//  Copyright (c) 2014年 淘海科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Nib)

/*
 * @brief 从文件名称与类名称一样的nib文件加载视图
 */
+ (UIView *)n_loadFromNib;

/*
 * @brief 从nib文件加载视图
 * @param nibName nib文件名称
 */
+ (UIView *)n_loadFromNibName:(NSString *)nibName;

@end
