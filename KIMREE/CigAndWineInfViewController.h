//
//  CigAndWineInfViewController.h
//  ECIGARFAN
//
//  Created by renchunyu on 14/12/5.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapModel.h"

@interface CigAndWineInfViewController : UIViewController
{
    UIWebView  *phoneCallWebView;
    
    
}

@property (strong, nonatomic) NSMutableArray *dataDealerlist;
@property (strong,nonatomic) mapModel *dealerItem;
@property(strong,nonatomic) NSArray *dealerCoordinate;
@property (weak, nonatomic) IBOutlet UITableView *cigAndWineTableView;
@end
