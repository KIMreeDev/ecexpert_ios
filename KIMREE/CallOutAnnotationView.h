//  CallOutAnnotationView.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-29.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//
//
#import <MapKit/MapKit.h>

#define  Arror_height 15

@protocol CallOutAnnotationViewDelegate;
@interface CallOutAnnotationView : MKAnnotationView

@property (nonatomic,strong)UIView *contentView;


- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier
                delegate:(id<CallOutAnnotationViewDelegate>)delegate;
@end

@protocol CallOutAnnotationViewDelegate <NSObject>

- (void)didSelectAnnotationView:(CallOutAnnotationView *)view;

@end


