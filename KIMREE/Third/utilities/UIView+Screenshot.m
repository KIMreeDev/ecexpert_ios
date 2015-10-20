//
//  UIView+Screenshot.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-7.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "UIView+Screenshot.h"
/*
    图形上下文的一个处理过程
 */
@implementation UIView (Screenshot)
- (UIImage *)screenshot {
    //创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)
    UIGraphicsBeginImageContext(self.bounds.size);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        //利用view层次结构并将其绘制到当前的上下文中
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else{
        //将当前layer的呈现拷贝到context上
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    //从图形上下文中获取刚刚生成的 UIImage
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束上下文的绘制
    UIGraphicsEndImageContext();
    //将image进行压缩
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    return image;
}
@end
