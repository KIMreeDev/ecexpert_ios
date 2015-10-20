//
//  SellerViewController.h
//  ECExpert
//
//  Created by JIRUI on 15/5/8.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "BaseViewController.h"

@interface SellerViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView      *giftRecordView;
@property (weak, nonatomic) IBOutlet UIView      *tradeView;
@property (weak, nonatomic) IBOutlet UIView      *sellRecordView;

@property (weak, nonatomic) IBOutlet UIImageView *dealerImageView;
@property (weak, nonatomic) IBOutlet UILabel     *dealerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *customerNameLabel;// dealerEmail
@property (weak, nonatomic) IBOutlet UILabel     *dealerPhoneLabel;


@end
