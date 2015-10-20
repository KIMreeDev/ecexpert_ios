//  MapCell.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-29.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//
#import <UIKit/UIKit.h>


#import <Foundation/Foundation.h>



@interface MapCell : UIView


@property (nonatomic,strong)IBOutlet UILabel *title;
@property (nonatomic,strong)IBOutlet UILabel *subtitle;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@end
