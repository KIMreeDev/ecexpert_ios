
//  CallOutAnnotationView.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-29.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "CallOutAnnotationView.h"
#import <QuartzCore/QuartzCore.h>

@interface CallOutAnnotationView ()
@property (nonatomic,weak)id<CallOutAnnotationViewDelegate>delegate;
@end

@implementation CallOutAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier
                delegate:(id<CallOutAnnotationViewDelegate>)delegate
{
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0.0f, -45.0f);//泡泡框离标记多高 //yu mark
        self.frame = CGRectMake(0.0f, 0.0f, 180.0f, 55.0f);//设置标记的大小
        if (delegate) {
            self.delegate = delegate;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//            self.userInteractionEnabled = YES;
            [self addGestureRecognizer:tap];
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Arror_height)];
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    return self;
}

- (void)tapAction
{
    if ([_delegate respondsToSelector:@selector(didSelectAnnotationView:)]) {
        [_delegate didSelectAnnotationView:self];
    }
}

#pragma mark -
#pragma mark draw

- (void)getDrawPath:(CGContextRef)context rect:(CGRect)rect
{
    CGRect rrect = rect;
	CGFloat radius = 6.0;
    
	CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect), 
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, COLOR_WHITE_NEW.CGColor);//yu mark修改标记颜色
    [self getDrawPath:context rect:self.bounds];
    CGContextFillPath(context);
    
    //yu mark
   // CGPathRef path = CGContextCopyPath(context);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 1;
    //inser
    //self.layer.shadowPath = path;
    self.layer.shadowPath = CGContextCopyPath(context);
    
    
}
@end
