//
//  CustomerViewController.h
//  ECExpert
//
//  Created by JIRUI on 15/5/7.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "BaseViewController.h"

@interface CustomerViewController : BaseViewController

@property (strong, nonatomic) UIView      *vipCardView;
@property (strong, nonatomic) UIView      *showProductsView;
@property (strong, nonatomic) UIView      *nearbyStoreView;
@property (strong, nonatomic) UIView      *feedbackView;
@property (strong, nonatomic) UIView      *recordView;

@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UILabel     *userNameLabel;
@property (strong, nonatomic) UILabel     *vipNumberLabel;

@end
