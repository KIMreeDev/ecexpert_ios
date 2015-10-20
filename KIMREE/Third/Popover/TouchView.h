//
//  TouchView.h
//
//  Created by renchunyu on 14-5-20.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void (^TouchedOutsideBlock)();
typedef void (^TouchedInsideBlock)();

@interface TouchView : UIView
{
    TouchedOutsideBlock _outsideBlock;
    TouchedInsideBlock  _insideBlock;
}

-(void)setTouchedOutsideBlock:(TouchedOutsideBlock)outsideBlock;

-(void)setTouchedInsideBlock:(TouchedInsideBlock)insideBlock;

@end
