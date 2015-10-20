//
//  CameraSwitchButton.h
//  ECExpert
//
//  Created by renchunyu on 15/1/22.
//  Copyright (c) 2015年 renchunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * The camera switch button.
 */
@interface CameraSwitchButton : UIButton

#pragma mark - Managing Properties
/** @name Managing Properties */

/**
 * @abstract The edge color of the drawing.
 * @discussion The default color is the white.
 */
@property (nonatomic, strong) UIColor *edgeColor;

/**
 * @abstract The fill color of the drawing.
 * @discussion The default color is the darkgray.
 */
@property (nonatomic, strong) UIColor *fillColor;

/**
 * @abstract The edge color of the drawing when the button is touched.
 * @discussion The default color is the white.
 */
@property (nonatomic, strong) UIColor *edgeHighlightedColor;

/**
 * @abstract The fill color of the drawing when the button is touched.
 * @discussion The default color is the black.
 */
@property (nonatomic, strong) UIColor *fillHighlightedColor;

@end
