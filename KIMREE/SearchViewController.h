//
//  SearchViewController.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-29.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealerViewController.h"
#import "GetDealer.h"

@interface SearchViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *dataList,*showData,*nameAndAddresslist;
@property (strong, nonatomic)  UISearchBar *searchBar;
@property (strong, nonatomic)  UITableView *tableView;
@property (strong,nonatomic) GetDealer *getDealer;
- (void) reloadData;
@end
