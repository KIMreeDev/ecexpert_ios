//
//  MainViewController.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-8-13.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController

-(UINavigationController*)UINavigationControllerWithRootVC:(UIViewController*)VC image:(NSString*)image title:(NSString*) title;

@end
