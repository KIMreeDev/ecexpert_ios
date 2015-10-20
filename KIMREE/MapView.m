//
//  MapView.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-29.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "MapView.h"

@interface MapView ()<MKMapViewDelegate,CallOutAnnotationViewDelegate>
{
    NSMutableArray *annoArr;
}
@property (nonatomic,weak)id<MapViewDelegate> delegate;

@end

@implementation MapView

@synthesize mapView = _mapView;
@synthesize delegate = _delegate;


- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        annoArr = [NSMutableArray array];
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.bounds];
        mapView.delegate = self;
        [self addSubview:mapView];
        self.mapView =  mapView;
        self.span = 30000;  //地图精度
        
        //地图类型
        self.mapView.mapType=MKMapTypeStandard;
        
        
    }
    return self;
}

- (id)initWithDelegate:(id<MapViewDelegate>)delegate
{
    if (self = [self init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    self.mapView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [super setFrame:frame];
}

- (void)beginLoad
{

    for (NSInteger i = 0; i < [_delegate numbersWithCalloutViewForMapView]; i++) {
        
        CLLocationCoordinate2D location = [_delegate coordinateForMapViewWithIndex:i];
        
        //去除显示位置
        //  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location,_span ,_span );
        //  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        // [_mapView setRegion:adjustedRegion animated:YES];
        
        BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:location.latitude andLongitude:location.longitude tag:(int)i];
        annotation.title = [_delegate titleForMapViewAtIndex:i];
        [_mapView  addAnnotation:annotation];
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (_isPushed) {
        return;
    }
    
	if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
    
        BasicMapAnnotation *annotation = (BasicMapAnnotation *)view.annotation;
        
        [self mapView:mapView didDeselectAnnotationView:view];
        self.calloutAnnotation = [[CalloutMapAnnotation alloc]
                                  initWithLatitude:annotation.latitude
                                  andLongitude:annotation.longitude
                                  tag:annotation.tag];
        [self.calloutAnnotation setTitle:annotation.title];
        [mapView addAnnotation:_calloutAnnotation];
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
}

- (void)didSelectAnnotationView:(CallOutAnnotationView *)view
{
    _isPushed = YES;
    CalloutMapAnnotation *annotation = (CalloutMapAnnotation *)view.annotation;
    if([_delegate respondsToSelector:@selector(calloutViewDidSelectedWithIndex:)])
    {
        [_delegate calloutViewDidSelectedWithIndex:annotation.tag];
    }
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
//    进入其他视图，本视图Annotation不取消选择
    if (_isPushed) {
        return;
    }
    
    for (id anno in mapView.annotations) {
        if ([anno isKindOfClass:[CalloutMapAnnotation class]]) {
            [mapView removeAnnotation:anno];
            _calloutAnnotation = nil;
        }
    }

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        CalloutMapAnnotation *calloutAnnotation = (CalloutMapAnnotation *)annotation;
        
        CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView)
        {
            annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView" delegate:self];
        }
        for (UIView *view in  annotationView.contentView.subviews) {
            [view removeFromSuperview];
        }
        [annotationView.contentView addSubview:[_delegate mapViewCalloutContentViewWithIndex:calloutAnnotation.tag]];
        return annotationView;
	} else if ([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        BasicMapAnnotation *basicMapAnnotation = (BasicMapAnnotation *)annotation;
        MKAnnotationView *annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:basicMapAnnotation
                                                          reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = NO;
            annotationView.image = [_delegate baseMKAnnotationViewImageWithIndex:basicMapAnnotation.tag];
        }
        [annotationView setAnnotation:basicMapAnnotation];
		return annotationView;
    }
	return nil;
}

//定位加载结束
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationOver" object:nil];
}

//刷新数据
- (void) refreshAnnotationView
{
    //相同的annotion则不添加
    if (((_selMapAnnotation.latitude == _calloutAnnotation.latitude)&&(_selMapAnnotation.longitude == _calloutAnnotation.longitude)&&([_selMapAnnotation.title isEqualToString: _calloutAnnotation.title]))) {
        [_mapView selectAnnotation:_calloutAnnotation animated:NO];
        [_mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
        return;
    }
    
    //不相同则移除annotion
    _isPushed = YES;
    for (id anno in _mapView.annotations) {
        if ([anno isKindOfClass:[CalloutMapAnnotation class]]) {
            [_mapView removeAnnotation:anno];
            _calloutAnnotation = nil;
        }
    }
    _isPushed = NO;
    
    //添加annotions
    for (id anno in _mapView.annotations) {
        if ([anno isKindOfClass:[BasicMapAnnotation class]]) {
            BasicMapAnnotation *basicMapAnnotation = (BasicMapAnnotation *)anno;
            BOOL isSelAnno = (_selMapAnnotation.latitude == basicMapAnnotation.latitude)&&(_selMapAnnotation.longitude == basicMapAnnotation.longitude)&&([_selMapAnnotation.title isEqualToString: basicMapAnnotation.title]);
            
            if (isSelAnno) {
                _calloutAnnotation = [[CalloutMapAnnotation alloc]
                                          initWithLatitude:basicMapAnnotation.latitude
                                          andLongitude:basicMapAnnotation.longitude
                                          tag:basicMapAnnotation.tag];
                [_calloutAnnotation setTitle:basicMapAnnotation.title];


                [_mapView addAnnotation:_calloutAnnotation];
                [_mapView selectAnnotation:_calloutAnnotation animated:NO];
                [_mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:NO];
                break;
            }
        }

    }

}

@end
