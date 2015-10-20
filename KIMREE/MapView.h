//  MapView.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-29.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BasicMapAnnotation.h"
#import "CallOutAnnotationView.h"
#import "CalloutMapAnnotation.h"

@protocol MapViewDelegate;
@interface MapView : UIView

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,assign) double span;//default 40000
@property (nonatomic,strong) BasicMapAnnotation *selMapAnnotation;
@property (nonatomic,strong) CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic,assign) BOOL isPushed;

- (id)initWithDelegate:(id<MapViewDelegate>)delegate;
- (void)beginLoad;
- (void) refreshAnnotationView;
@end


@protocol MapViewDelegate <NSObject>

- (NSInteger)numbersWithCalloutViewForMapView;
- (CLLocationCoordinate2D)coordinateForMapViewWithIndex:(NSInteger)index;
- (UIView *)mapViewCalloutContentViewWithIndex:(NSInteger)index;
- (UIImage *)baseMKAnnotationViewImageWithIndex:(NSInteger)index;
- (NSString *)titleForMapViewAtIndex:(NSInteger)index;
@optional
- (void)calloutViewDidSelectedWithIndex:(NSInteger)index;


@end