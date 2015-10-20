//
//  MagnetView.m
//  ECExpert
//
//  Created by Fran on 15/6/5.
//  Copyright (c) 2015年 Fran. All rights reserved.
//

#import "MagnetView.h"

@implementation MagnetView

#pragma mark - touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.orginFrame.size.height <= 0) {
        self.orginFrame = self.frame;
    }
    
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self.window];
    self.startPoint = point;
    
    UIView *superView = [self superview];
    [superView bringSubviewToFront:self];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self.window];
    
    CGRect moveFrame = CGRectMake(self.orginFrame.origin.x + (point.x - self.startPoint.x), self.orginFrame.origin.y + (point.y - self.startPoint.y), self.orginFrame.size.width, self.orginFrame.size.height);
    
//    [UIView beginAnimations:@"move" context:nil];
//    [UIView setAnimationDelay:0];
    self.frame = moveFrame;
//    [UIView commitAnimations];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resetView];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resetView];
}

- (void)resetView{
    [UIView beginAnimations:@"reset" context:nil];
    [UIView setAnimationDelay:0];
    self.frame = self.orginFrame;
    [UIView commitAnimations];
}

@end
