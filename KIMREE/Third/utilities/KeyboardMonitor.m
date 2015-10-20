//
//  Keyboard.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-14.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "KeyboardMonitor.h"

@implementation KeyboardMonitor




-(void)keyboardMonitorInit
{
    //增加键盘监听
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardDidHideNotification object:nil];
    _keyboardIsVisible = NO;

}


#pragma --keyboard
- (void)keyboardDidShow
{
    _keyboardIsVisible = YES;
}

- (void)keyboardDidHide
{
    _keyboardIsVisible = NO;
}

- (BOOL)keyboardIsVisible
{
    return _keyboardIsVisible;
}

@end
