//
//  UIView+Nib.m
//  haitaotong
//
//  Created by 淘海科技 on 14-1-15.
//  Copyright (c) 2014年 淘海科技. All rights reserved.
//

#import "UIView+Nib.h"

@implementation UIView (Nib)

/*
 * @brief 从文件名称与类名称一样的nib文件加载视图
 */
+ (UIView *)n_loadFromNib
{
  NSString *nibName = [self description];
  return [self n_loadFromNibName:nibName];
}

/*
 * @brief 从nib文件加载视图
 * @param nibName nib文件名称
 */
+ (UIView *)n_loadFromNibName:(NSString *)nibName
{
  Class klass = [self class];
  NSArray* objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
  for (id object in objects) {
    if ([object isKindOfClass:klass]) {
      return object;
    }
  }
  return nil;
}

@end
