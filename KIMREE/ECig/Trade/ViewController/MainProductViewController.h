//
//  MainProductViewController.h
//  ECExpert
//
//  Created by JIRUI on 15/5/9.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"

@interface MainProductViewController : BaseViewController

@property (copy, nonatomic  ) NSString       *barCode;

@property (strong, nonatomic) NSMutableArray *productArray;
@property (strong, nonatomic) ProductModel   *mainProduct;
@property (strong, nonatomic) UITableView    *supTableView;

// 界面是否处于编辑状态，用于区别 录入交易 和 查看交易记录 功能， default NO
@property (assign, nonatomic) BOOL           isEdit;

@end
