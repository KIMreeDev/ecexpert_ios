//
//  PopoverView.h
//
//  Created by renchunyu on 14-5-20.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    PopoverArrowDirectionUp = 1UL << 0,
    PopoverArrowDirectionDown = 1UL << 1,
    PopoverArrowDirectionLeft = 1UL << 2,
    PopoverArrowDirectionRight = 1UL << 3,

    PopoverArrowDirectionVertical = PopoverArrowDirectionUp | PopoverArrowDirectionDown,
    PopoverArrowDirectionHorizontal = PopoverArrowDirectionLeft | PopoverArrowDirectionRight,
    
    PopoverArrowDirectionAny = PopoverArrowDirectionUp | PopoverArrowDirectionDown |
    PopoverArrowDirectionLeft | PopoverArrowDirectionRight
    
} PopoverArrowDirection;


#define PopoverArrowDirectionIsVertical(direction)    ((direction) == PopoverArrowDirectionVertical || (direction) == PopoverArrowDirectionUp || (direction) == PopoverArrowDirectionDown)

#define PopoverArrowDirectionIsHorizontal(direction)    ((direction) == PopoverArrowDirectionHorizontal || (direction) == PopoverArrowDirectionLeft || (direction) == PopoverArrowDirectionRight)


typedef enum {
    PopoverBlackTint = 1UL << 0, // default
    PopoverLightGrayTint = 1UL << 1,
    PopoverGreenTint = 1UL << 2,
    PopoverRedTint = 1UL << 3,
    PopoverDefaultTint = PopoverBlackTint
} PopoverTint;

@interface PopoverView : UIView
{
    //default PopoverArrowDirectionUp
    PopoverArrowDirection _arrowDirection;
    UIView *_contentView;
    UILabel *_titleLabel;
}
@property(nonatomic,retain) NSString *title;
@property(nonatomic,assign) CGPoint relativeOrigin;
@property(nonatomic,assign) PopoverTint tint;

-(void)setArrowDirection:(PopoverArrowDirection)arrowDirection;
-(PopoverArrowDirection)arrowDirection;

-(void)addContentView:(UIView*)contentView;

@end
