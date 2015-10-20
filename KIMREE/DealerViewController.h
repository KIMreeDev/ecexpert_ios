//
//  DealerViewController.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-21.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapModel.h"

@protocol DealerViewControllerDelegate <NSObject>
- (void) didSelectedDealerItem:(mapModel *)mapModel;

@end

@interface DealerViewController : UIViewController
{
    UIWebView  *phoneCallWebView;
 
}
@property (assign, nonatomic) id <DealerViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *dealerInformationTable;
@property (strong, nonatomic) NSMutableArray *dataDealerlist;
@property (strong,nonatomic) mapModel *dealerItem;
@property(strong,nonatomic) NSArray *dealerCoordinate;
@end
