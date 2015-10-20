//
//  GiftProductViewController.h
//  ECExpert
//
//  Created by JIRUI on 15/5/12.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"

typedef enum {
    GiftPageEditTypeNone, // 查看交易记录，所有字段都不能编辑
    GiftPageEditTypeDispatch, // 赠品查询状态，可以修改赠品已发放数量
    GiftPageEditTypeALL // 录入交易状态，能编辑的字段都能编辑
}GiftPageEditType;

@interface GiftProductViewController : BaseViewController

@property (strong, nonatomic) NSMutableArray   *giftArray;
@property (strong, nonatomic) ProductModel     *giftProduct;
@property (strong, nonatomic) UITableView      *supTableView;

// 界面是否处于编辑状态，用于区别 录入交易 和 查看交易记录 功能， default GiftPageEditTypeNone
@property (assign, nonatomic) GiftPageEditType pageEditType;

@end
