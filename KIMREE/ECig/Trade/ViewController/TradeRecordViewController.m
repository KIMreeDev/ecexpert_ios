//
//  TradeRecordViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/15.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "TradeRecordViewController.h"
#import "TradeOutputViewController.h"
#import "AFNetworkingFactory.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

#import "MJRefresh.h"

@interface TradeRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

// 查询出来的数据
@property (strong, nonatomic) NSMutableArray      *recordArray;

// 组装后显示到界面的数据
@property (strong, nonatomic) NSMutableArray      *sectionArray;
@property (strong, nonatomic) NSMutableDictionary *sectionCellDic;

// request params
@property (assign, nonatomic) NSInteger           pageSize;
@property (assign, nonatomic) NSInteger           pageNo;
@property (assign, nonatomic) NSInteger           recordOwnerId;
@property (assign, nonatomic) UserType            type;

@property (strong, nonatomic) NSMutableDictionary *params;

@end

@implementation TradeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    switch (self.tradeRecordType) {
        case TradeRecordTypeCustomer:
            self.title = @"我的消费记录";
            break;
        case TradeRecordTypeDealer:
            self.title = @"交易记录";
            break;
        case TradeRecordTypeGift:
            self.title = @"派发赠品记录";
            break;
        default:
            break;
    }
    
    [self initData];
    [self initTableView];
    
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getRemoteRecord)];
    [self.tableView.footer beginRefreshing];
    self.tableView.footer.textColor = [UIColor whiteColor]; // 颜色设置要在设置刷新之后执行，不然会被默认颜色覆盖
}

- (void) getRemoteRecord{
    self.progressHUD.mode = MBProgressHUDModeText;
    __unsafe_unretained TradeRecordViewController *blockSelf = self;

    [self.manager POST:API_TRADE_RECORD_SELECT_URL parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSInteger code = [[resultDic objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSArray *records = [resultDic objectForKey:@"data"];
            [blockSelf.recordArray addObjectsFromArray:records];
            [blockSelf changeDataTypeToShow];
            
            [blockSelf.params setObject:[NSNumber numberWithInteger:( ++self.pageNo )] forKey:@"pageNo"];
        }else{
            blockSelf.progressHUD.labelText = @"刷新数据失败!";
            blockSelf.progressHUD.detailsLabelText = [resultDic objectForKey:@"data"];
            [blockSelf.progressHUD show:YES];
            [blockSelf.progressHUD hide:YES afterDelay:3];
        }
        [blockSelf.tableView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        blockSelf.progressHUD.labelText = @"刷新数据失败!";
        blockSelf.progressHUD.detailsLabelText = [error localizedDescription];
        [blockSelf.progressHUD show:YES];
        [blockSelf.progressHUD hide:YES afterDelay:3];
        [blockSelf.tableView.footer endRefreshing];
        
    }];
}

- (void)changeDataTypeToShow{
    [self.sectionArray removeAllObjects];
    [self.sectionCellDic removeAllObjects];
    
    for (NSDictionary *dic in self.recordArray) {
        NSString *section = [[dic objectForKey:@"trade_time"] substringWithRange:NSMakeRange(0, 10)];
        if (![self.sectionArray containsObject:section]) {
            [self.sectionArray addObject:section];
        }
        
        NSMutableArray *sectionDatas = [self.sectionCellDic objectForKey:section];
        if (sectionDatas == nil) {
            sectionDatas = [NSMutableArray array];
            [self.sectionCellDic setObject:sectionDatas forKey:section];
        }
        [sectionDatas addObject:dic];
        
    }
    
    [self.tableView reloadData];
}

- (void) initData{
    if (self.recordArray == nil) {
        self.recordArray = [NSMutableArray array];
    }
    
    if(self.sectionArray == nil){
        self.sectionArray = [NSMutableArray array];
    }
    
    if (self.sectionCellDic == nil) {
        self.sectionCellDic = [NSMutableDictionary dictionary];
    }
    
    self.manager = [AFNetworkingFactory networkingManager];
    
    self.pageNo = 1;
    self.pageSize = 10;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.tradeRecordType == TradeRecordTypeCustomer) {
        self.customerInfoDic = appDelegate.loginUser;
        self.recordOwnerId = [[self.customerInfoDic objectForKey:@"customer_id"] integerValue];
        self.type = [[self.customerInfoDic objectForKey:@"usertype"] integerValue];
        
    }else if (self.tradeRecordType == TradeRecordTypeDealer){
        self.sellerInfoDic = appDelegate.loginUser;
        self.recordOwnerId = [[self.sellerInfoDic objectForKey:@"dealer_id"] integerValue];
        self.type = [[self.sellerInfoDic objectForKey:@"usertype"] integerValue];
        
    }
    
    
    self.params = [NSMutableDictionary dictionary];
    [_params setObject:[NSNumber numberWithInteger:self.pageNo] forKey:@"pageNo"];
    [_params setObject:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
    [_params setObject:[NSNumber numberWithInteger:self.recordOwnerId] forKey:@"id"];
    [_params setObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView{
    CGFloat _x,_y,_w,_h;
    _w = KM_SCREEN_WIDTH,
    _x = 0;
    _y = 0;
    _h = KM_SCREEN_HEIGHT;
    if (self.navigationController) {
        _y = 64;
        _h -= 64;
    }
    if (self.tabBarController) {
        _h -= 49;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(_x, _y, _w, _h) style:UITableViewStylePlain];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = RGBA(0, 0, 0, 0.3);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    NSDictionary *cellDic = [[self.sectionCellDic objectForKey:[self.sectionArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"订单号: %@", [cellDic objectForKey:@"trade_no"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"交易时间: %@", [cellDic objectForKey:@"trade_time"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.sectionCellDic objectForKey:[self.sectionArray objectAtIndex:section]] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionArray objectAtIndex:section];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.sectionArray;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    return [self.sectionArray indexOfObject:title];
//}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSDictionary *cellDic = [self.recordArray objectAtIndex:section];
    TradeOutputViewController *tradeOutputVC = [[TradeOutputViewController alloc] init];
    tradeOutputVC.tradeRecordType = self.tradeRecordType;
    tradeOutputVC.tradeInfoDic = cellDic;
    [self.navigationController pushViewController:tradeOutputVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
//    sectionHeaderView.backgroundColor = [UIColor clearColor];
//    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(10, 10, 150, 20);
//    label.textColor = [UIColor whiteColor];
//    label.text = [self.sectionArray objectAtIndex:section];
//    
//    [sectionHeaderView addSubview:label];
//    return sectionHeaderView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 5;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
