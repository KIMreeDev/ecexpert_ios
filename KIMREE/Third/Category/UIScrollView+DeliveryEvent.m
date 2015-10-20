//
//  UIScrollView+DeliveryEvent.m
//  ECExpert
//
//  Created by Fran on 15/6/5.
//  Copyright (c) 2015年 Fran. All rights reserved.
//

#import "UIScrollView+DeliveryEvent.h"

@implementation UIScrollView (DeliveryEvent)

/**
 *  
 *
 *  @param view <#view description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    return NO;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view{
    return YES;
}

@end
