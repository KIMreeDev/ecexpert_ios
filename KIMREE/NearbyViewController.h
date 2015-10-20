//
//  NearbyViewController.h
//  ECIGARFAN
//
//  Created by cool on 14-4-8.
//  Copyright (c) 2014年 cool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealerViewController.h"
#import "MapCell.h"
#import "SearchViewController.h"

@interface NearbyViewController : UIViewController
@property (strong,nonatomic) DealerViewController *displayVC;
- (void)location;
@end
