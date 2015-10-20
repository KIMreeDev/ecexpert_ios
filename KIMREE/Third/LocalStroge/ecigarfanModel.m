//
//  ecigarfanModel.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-7-15.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "ecigarfanModel.h"

@implementation ecigarfanModel

-(ecigarfanModel *)initWithObject:(id)object{
    self = [super init];
    if (self) {
        self.model = object;

    }
    return self;
}



- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.model forKey:@"ecigarfanModel"];
    

}
- (id)initWithCoder:(NSCoder *)decoder
{

    if (self = [super init]) {
        self.model = [decoder decodeObjectForKey:@"ecigarfanModel"];
 
    }
    return self;

}


@end
