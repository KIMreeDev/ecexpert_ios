//
//  UIColor+additions.m

//  ECIGARFAN
//
//  Created by cool on 14-4-12.
//  Copyright (c) 2014年 cool. All rights reserved.
//

#import "UIColor+additions.h"

@implementation UIColor (additions)

+ (UIColor *)randomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}

@end
