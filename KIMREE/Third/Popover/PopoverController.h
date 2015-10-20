//
//  PopoverController.h
//
//  Created by renchunyu on 14-5-20.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "PopoverView.h"
#import "TouchView.h"

@class PopoverController;
@protocol PopoverControllerDelegate <NSObject>

@optional
- (void)popoverControllerDidDismissPopover:(PopoverController *)popoverController;
- (void)presentedNewPopoverController:(PopoverController *)newPopoverController
          shouldDismissVisiblePopover:(PopoverController*)visiblePopoverController;
@end

@interface PopoverController : UIViewController
{
    TouchView *_touchView;
    PopoverView *_contentView;
    UIViewController *_viewController;
    UIWindow *_window;
    UIView *_parentView;
    UIView *_fromView;
    UIDeviceOrientation _deviceOrientation;
}
@property(nonatomic,assign) id<PopoverControllerDelegate> delegate;
/** @brief PopoverArrowDirectionAny, PopoverArrowDirectionVertical or PopoverArrowDirectionHorizontal for automatic arrow direction.
 **/
@property(nonatomic,assign) PopoverArrowDirection arrowDirection;

@property(nonatomic,assign) CGSize contentSize;
@property(nonatomic,assign) CGPoint origin;

/** @brief The tint of the popover. **/
@property(nonatomic,assign) PopoverTint tint;

/** @brief Initialize the popover with the content view controller
 **/
-(id)initWithViewController:(UIViewController*)viewController;

/** @brief Presenting the popover from a specified view **/
-(void)presentPopoverFromView:(UIView*)fromView;

/** @brief Presenting the popover from a specified point **/
-(void)presentPopoverFromPoint:(CGPoint)fromPoint;


/** @brief Dismiss the popover **/
-(void)dismissPopoverAnimated:(BOOL)animated;


@end
