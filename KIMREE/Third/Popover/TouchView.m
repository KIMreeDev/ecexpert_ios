//
//  TouchView.m
//
//  Created by renchunyu on 14-5-20.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//


#import "TouchView.h"

@implementation TouchView

-(void)dealloc
{
    [_outsideBlock release];
    [_insideBlock release];
    [super dealloc];
}

-(void)setTouchedOutsideBlock:(TouchedOutsideBlock)outsideBlock
{
    [_outsideBlock release];
    _outsideBlock = [outsideBlock copy];
}

-(void)setTouchedInsideBlock:(TouchedInsideBlock)insideBlock
{
    [_insideBlock release];
    _insideBlock = [insideBlock copy];    
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *subview = [super hitTest:point withEvent:event];

    if(UIEventTypeTouches == event.type)
    {
        BOOL touchedInside = subview != self;
        if(!touchedInside)
        {
            for(UIView *s in self.subviews)
            {
                if(s == subview)
                {
                    //touched inside
                    touchedInside = YES;
                    break;
                }
            }            
        }
        
        if(touchedInside && _insideBlock)
        {
            _insideBlock();
        }
        else if(!touchedInside && _outsideBlock)
        {
            _outsideBlock();
        }
    }
    
    return subview;
}


@end
