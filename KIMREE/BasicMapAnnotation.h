
//  BasicMapAnnotation.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-29.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BasicMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;
@property (nonatomic,assign) int tag;
@property (nonatomic,copy) NSString *title;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
                   tag:(int)tag;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (CLLocationCoordinate2D)coordinate;
@end
