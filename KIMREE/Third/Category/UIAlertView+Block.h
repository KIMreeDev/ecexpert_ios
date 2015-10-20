//
//  UIAlertView+Block.h
//  ECExpert
//
//  Created by Fran on 15/5/27.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewCompleteBlock) (NSInteger buttonIndex);

@interface UIAlertView (Block)

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showAlertViewWithCompleteBlock:(AlertViewCompleteBlock) block;

@end
