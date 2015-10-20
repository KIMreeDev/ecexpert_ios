//
//  KeyboardMonitor.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-14.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardMonitor : NSObject
@property (assign,nonatomic) BOOL keyboardIsVisible;
-(void)keyboardMonitorInit;
- (void)keyboardDidShow;
- (void)keyboardDidHide;
- (BOOL)keyboardIsVisible;
@end
