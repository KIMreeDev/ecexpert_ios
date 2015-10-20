//  BasicMapAnnotation.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-29.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//
#import "BasicMapAnnotation.h"

@implementation BasicMapAnnotation

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
                   tag:(int)tag
{
	if (self = [super init])
    {
		self.latitude = latitude;
		self.longitude = longitude;
        self.tag = tag;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate
{
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	self.latitude = newCoordinate.latitude;
	self.longitude = newCoordinate.longitude;
}


@end
