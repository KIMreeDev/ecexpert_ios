//
//  TradeInputViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/8.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import <objc/runtime.h>
#import "TradeInputViewController.h"
#import "AFNetworkingFactory.h"
#import "AppDelegate.h"

#import "ScanViewController.h"
#import "ZbarScanViewController.h"

#import "MainProductViewController.h"
#import "GiftProductViewController.h"
#import "ProductModel.h"


@interface TradeInputViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UITableView                   *tableView;
@property (strong, nonatomic) NSMutableArray                *customerArray;
@property (strong, nonatomic) NSMutableArray                *productArray;
@property (strong, nonatomic) NSMutableArray                *giftArray;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@property (strong, nonatomic) NSDateFormatter               *dateFormatter;
@property (strong, nonatomic) NSString                      *dateString;

@end

@implementation TradeInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"交易录入";
    
    [self initData];
    [self initTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addNewTrade)];
    
    
}

- (void)initData{
    self.dateString = @"yyyy-MM-dd";
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = self.dateString;
    
    self.manager = [AFNetworkingFactory networkingManager];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.translucent = NO;
    //    self.tabBarController.tabBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNewTrade{
    if (self.customerArray.count > 0 && self.productArray.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"录入交易" message:@"确定录入交易信息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        __unsafe_unretained TradeInputViewController *blockSelf = self;
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [blockSelf commitAddTradeRecord];
            }
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"录入交易" message:@"录入信息不足，无法完成交易录入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            // do nothing
        }];
    }
}

- (void)goback{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"放弃修改?" message:@"放弃修改数据?" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [super goback];
        }
    }];
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = RGBA(0, 0, 0, 0.3);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if( section == 1){
        if (self.productArray && self.productArray.count > 0) {
            return self.productArray.count;
        }else{
            return 1;
        }
    }else{
        if (self.giftArray && self.giftArray.count > 0) {
            return self.giftArray.count;
        }else{
            return 1;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UIButton *deleteBtn = (UIButton *)[cell.contentView viewWithTag:1];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        
        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = 1;
        deleteBtn.frame = CGRectMake(kScreen_Width - 30 - 22 - 10, (44 - 22) / 2.0, 22, 22);
        [deleteBtn setImage:[UIImage imageNamed:@"button_minus_red"] forState:UIControlStateNormal];
        deleteBtn.backgroundColor = [UIColor clearColor];
        [deleteBtn addTarget:self action:@selector(deleteBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteBtn];
    }
    deleteBtn.hidden = NO;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.textLabel.textColor = RGB(153, 138, 141);
    //    cell.detailTextLabel.textColor = RGB(153, 138, 141);
    
    if (indexPath.section == 0) {
        if (self.customerArray.count > 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSDictionary *customer      = [self.customerArray objectAtIndex:0];
            NSString *customer_name     = [customer objectForKey:@"customer_name"];
            NSString *customer_nickname = [customer objectForKey:@"customer_nickname"];
            NSString *customer_vip      = [customer objectForKey:@"customer_vip"];
            NSString *customer_phone    = [customer objectForKey:@"customer_phone"];
            
            NSString *text = [NSString stringWithFormat:@"%@ (电话:%@)",customer_name, customer_phone];
            cell.textLabel.text = text;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"会员卡号:%@", customer_vip];
        }else{
            [self cell:cell WithNoDataText:@"请选择买家" DeleteButton:deleteBtn];
        }
    }else if (indexPath.section == 1){
        if (self.productArray.count > 0) {
            ProductModel *product = [self.productArray objectAtIndex:indexPath.row];
            cell.textLabel.text = product.productNameZH.length > 0 ? product.productNameZH: product.productNameEN;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"数量:%zi",product.totalCount];
        }else{
            [self cell:cell WithNoDataText:@"请选择商品" DeleteButton:deleteBtn];
        }
        
    }else if (indexPath.section == 2){
        if (self.giftArray.count > 0) {
            ProductModel *product = [self.giftArray objectAtIndex:indexPath.row];
            cell.textLabel.text = product.productNameZH;
            //            cell.detailTextLabel.text = [NSString stringWithFormat:@"总数量:%zi    已派发:%zi",product.totalCount, product.dispatchCount];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"数量:%zi",product.totalCount];
            
        }else{
            [self cell:cell WithNoDataText:@"请选择赠品" DeleteButton:deleteBtn];
        }
    }
    
    return cell;
}

- (void)cell:(UITableViewCell *)cell WithNoDataText:(NSString *)text DeleteButton:(UIButton *)deleteBtn{
    deleteBtn.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = text;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}


// TableViewCell中删除按钮的点击事件
- (void)deleteBtnClickAction:(UIButton *)btn{
    UITableViewCell *cell = (UITableViewCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除数据" message:@"您确定要删除选中数据?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    __unsafe_unretained TradeInputViewController *blockSelf = self;
    __unsafe_unretained NSIndexPath *blockIndexPath = indexPath;
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [blockSelf commitDeleteDataWithIndexPath: blockIndexPath];
        }
    }];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && self.customerArray.count > 0) {
        //TODO: customer
    }else if (section == 1 && self.productArray.count > 0){
        
        MainProductViewController *mainProductVC = [[MainProductViewController alloc] init];
        mainProductVC.supTableView = self.tableView;
        mainProductVC.isEdit = YES;
        mainProductVC.productArray = self.productArray;
        mainProductVC.mainProduct = self.productArray[row];
        
        [self.navigationController pushViewController:mainProductVC animated:YES];
        
    }else if (section == 2 && self.giftArray.count > 0){
        
        GiftProductViewController *giftVC = [[GiftProductViewController alloc] init];
        giftVC.supTableView = self.tableView;
        giftVC.giftArray = self.giftArray;
        giftVC.giftProduct = self.giftArray[row];
        giftVC.pageEditType = GiftPageEditTypeALL;
        
        [self.navigationController pushViewController:giftVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    //    sectionHeaderView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    sectionHeaderView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor whiteColor];
    title.frame = CGRectMake(10, (40 - 21) / 2.0, 100, 21);
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
    add.frame = CGRectMake(kScreen_Width - 30 - 10, (40 - 30) / 2.0, 30, 30);
    add.tintColor = [UIColor whiteColor];
    
    [sectionHeaderView addSubview:title];
    [sectionHeaderView addSubview:add];
    
    if (section == 0) {
        title.text = @"买家";
        [add addTarget:self action:@selector(addBuyerAction) forControlEvents:UIControlEventTouchUpInside];
    }else if (section == 1){
        title.text = @"商品列表";
        [add addTarget:self action:@selector(addProductAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        title.text = @"赠品列表";
        [add addTarget:self action:@selector(addGiftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    sectionFooterView.backgroundColor = [UIColor clearColor];
    return sectionFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 20;
//}

- (void)addBuyerAction{
    NSLog(@"addBuyerAction");
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    scanVC.title = @"扫描客户会员卡";
    scanVC.scanType = ScanCodeTypeQRCode;
    
    __unsafe_unretained TradeInputViewController *blockSelf = self;
    scanVC.finishBlock = ^(ScanViewController *vc, NSString *vipCard){
        // 关闭扫描界面
        [vc goBack];
        
        NSData *jsonData = [vipCard dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        
        blockSelf.progressHUD.mode = MBProgressHUDModeIndeterminate;
        blockSelf.progressHUD.labelText = @"Loading...";
        [blockSelf.progressHUD show:YES];
        [blockSelf.manager POST:API_CHECKVIP_URL parameters:jsonDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *jsonDic = (NSDictionary *)responseObject;
            NSInteger code = [[jsonDic objectForKey:@"code"] integerValue];
            if (code == 1) {
                
                if (blockSelf.customerArray == nil) {
                    blockSelf.customerArray = [NSMutableArray array];
                }
                [blockSelf.customerArray removeAllObjects];
                [blockSelf.customerArray insertObject:[jsonDic objectForKey:@"data"] atIndex:0];
                [blockSelf.tableView reloadData];
                
                [blockSelf.progressHUD hide:YES];
            }else{
                blockSelf.progressHUD.mode = MBProgressHUDModeText;
                blockSelf.progressHUD.labelText = [jsonDic objectForKey:@"data"];
                [blockSelf.progressHUD hide:YES afterDelay:3];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            blockSelf.progressHUD.mode = MBProgressHUDModeText;
            blockSelf.progressHUD.labelText = [error localizedDescription];
            [blockSelf.progressHUD hide:YES afterDelay:3];
        }];
    };
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)addProductAction{
    
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    scanVC.title = @"扫描产品条形码";
    scanVC.scanType = ScanCodeTypeBarCode;
    
    __unsafe_unretained TradeInputViewController *blockSelf = self;
    scanVC.finishBlock = ^(ScanViewController *vc, NSString *barCode){
        // 关闭扫描界面
        [vc goBack];
        
        ProductModel *product = nil;
        for (int i = 0; i < blockSelf.productArray.count; i++) {
            ProductModel *temp = blockSelf.productArray[i];
            if ([temp.scanCode isEqualToString:barCode]) {
                product = temp;
            }
        }
        
        if (product) {
            // 扫描的商品在商品列表中已经存在，再次扫描时不会向服务器发送请求，仅在本地修改总数量即可
            product.totalCount += 1;
            [blockSelf.productArray removeObject:product];
            [blockSelf.productArray insertObject:product atIndex:0];
            [blockSelf.tableView reloadData];
        }else{
            
            blockSelf.progressHUD.mode = MBProgressHUDModeIndeterminate;
            blockSelf.progressHUD.labelText = @"Loading...";
            [blockSelf.progressHUD show:YES];
            
            [blockSelf.manager GET:[NSString stringWithFormat:API_BAR_CODE_URL, barCode] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *rootDic = (NSDictionary *)responseObject;
                NSInteger code = [[rootDic objectForKey:@"code"] integerValue];
                if (code == 1) {
                    ProductModel *product = [ProductModel objectWithKeyValues:[rootDic objectForKey:@"data"]];
                    product.scanCode = barCode;
                    product.totalCount = 1;
                    
                    if (blockSelf.productArray == nil) {
                        blockSelf.productArray = [NSMutableArray array];
                    }
                    [blockSelf.productArray insertObject:product atIndex:0];
                    [blockSelf.tableView reloadData];
                    
                    [blockSelf.progressHUD hide:YES];
                }else{
                    blockSelf.progressHUD.mode = MBProgressHUDModeText;
                    blockSelf.progressHUD.labelText = [NSString stringWithFormat:@"%@",[rootDic objectForKey:@"data"]];
                    [blockSelf.progressHUD hide:YES afterDelay:3];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                blockSelf.progressHUD.mode = MBProgressHUDModeText;
                blockSelf.progressHUD.labelText = [error localizedDescription];
                [blockSelf.progressHUD hide:YES afterDelay:3];
            }];
            
        }
        
    };
    
    [self.navigationController pushViewController:scanVC animated:YES];
    
}

- (void)addGiftAction{
    
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    scanVC.title = @"扫描赠品条形码";
    scanVC.scanType = ScanCodeTypeBarCode;
    
    __unsafe_unretained TradeInputViewController *blockSelf = self;
    scanVC.finishBlock = ^(ScanViewController *vc, NSString *barCode){
        // 关闭扫描界面
        [vc goBack];
        
        ProductModel *product = nil;
        for (int i = 0; i < blockSelf.giftArray.count; i++) {
            ProductModel *temp = blockSelf.giftArray[i];
            if ([temp.scanCode isEqualToString:barCode]) {
                product = temp;
            }
        }
        
        if (product) {
            // 如果已经添加过赠品，再次扫描时只增加总数和分派数，不会跳转到详情页
            product.totalCount += 1;
            //            product.dispatchCount += 1;
            [blockSelf.giftArray removeObject:product];
            [blockSelf.giftArray insertObject:product atIndex:0];
            [blockSelf.tableView reloadData];
        }else{
            
            // 第一次增加赠品的时候，需要跳转到详情页去设置必要的信息
            blockSelf.progressHUD.mode = MBProgressHUDModeIndeterminate;
            blockSelf.progressHUD.labelText = @"Loading...";
            [blockSelf.progressHUD show:YES];
            
            [blockSelf.manager GET:[NSString stringWithFormat:API_BAR_CODE_URL, barCode] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *rootDic = (NSDictionary *)responseObject;
                NSInteger code = [[rootDic objectForKey:@"code"] integerValue];
                if (code == 1) {
                    ProductModel *product = [ProductModel objectWithKeyValues:[rootDic objectForKey:@"data"]];
                    NSString *now = [blockSelf.dateFormatter stringFromDate:[NSDate date]];
                    product.scanCode = barCode;
                    product.totalCount = 1;
                    //                    product.dispatchCount = 1;
                    //                    product.effectiveDate = [blockSelf.dateFormatter dateFromString:now];
                    //                    product.expirationDate = [NSDate dateWithTimeInterval:(24*60*60*6) sinceDate:product.effectiveDate];
                    
                    if (blockSelf.giftArray == nil) {
                        blockSelf.giftArray = [NSMutableArray array];
                    }
                    [blockSelf.giftArray insertObject:product atIndex:0];
                    [blockSelf.tableView reloadData];
                    
                    [blockSelf.progressHUD hide:YES];
                    
                    //                    GiftProductViewController *giftVC = [[GiftProductViewController alloc] init];
                    //                    giftVC.supTableView = self.tableView;
                    //                    giftVC.giftArray = self.giftArray;
                    //                    giftVC.giftProduct = product;
                    //                    giftVC.pageEditType = GiftPageEditTypeALL;
                    //                    [self.navigationController pushViewController:giftVC animated:YES];
                }else{
                    blockSelf.progressHUD.mode = MBProgressHUDModeText;
                    blockSelf.progressHUD.labelText = [NSString stringWithFormat:@"%@",[rootDic objectForKey:@"data"]];
                    [blockSelf.progressHUD hide:YES afterDelay:3];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                blockSelf.progressHUD.mode = MBProgressHUDModeText;
                blockSelf.progressHUD.labelText = [error localizedDescription];
                [blockSelf.progressHUD hide:YES afterDelay:3];
            }];
            
        }
        
    };
    
    [self.navigationController pushViewController:scanVC animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)commitDeleteDataWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self.customerArray removeObjectAtIndex:indexPath.row];
    }else if (indexPath.section == 1) {
        [self.productArray removeObjectAtIndex:indexPath.row];
    }else if (indexPath.section == 2) {
        [self.giftArray removeObjectAtIndex:indexPath.row];
    }
    
    [self.tableView reloadData];
}

- (void)commitAddTradeRecord{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[self.customerArray firstObject] objectForKey:@"customer_id"] forKey:@"customer_id"];
    [params setObject:[[(AppDelegate *)[[UIApplication sharedApplication] delegate] loginUser] objectForKey:@"dealer_id"] forKey:@"dealer_id"];
    
    // 主产品
    NSMutableArray *tradeProducts = [NSMutableArray array];
    for (ProductModel *product in self.productArray) {
        NSMutableDictionary *productDic = [NSMutableDictionary dictionary];
        [productDic setObject:product.scanCode forKey:@"scanCode"];
        [productDic setObject:[NSNumber numberWithInteger:product.totalCount] forKey:@"totalCount"];
        [tradeProducts addObject:productDic];
    }
    NSData *productsData = [NSJSONSerialization dataWithJSONObject:tradeProducts options:NSJSONWritingPrettyPrinted error:nil];
    NSString *productsString = [[NSString alloc] initWithData:productsData encoding:NSUTF8StringEncoding];
    
    [params setObject:productsString  forKey:@"main_products"];
    
    // 赠品
    NSMutableArray *giftProducts = [NSMutableArray array];
    for (ProductModel *product in self.giftArray) {
        NSMutableDictionary *productDic = [NSMutableDictionary dictionary];
        [productDic setObject:product.scanCode forKey:@"scanCode"];
        [productDic setObject:[NSNumber numberWithInteger:product.totalCount] forKey:@"totalCount"];
        //        [productDic setObject:[NSNumber numberWithInteger:product.dispatchCount] forKey:@"dispatchCount"];
        //        [productDic setObject:product.effectiveDate forKey:@"effectiveDate"];
        //        [productDic setObject:product.expirationDate forKey:@"expirateDate"];
        
        [giftProducts addObject:productDic];
    }
    NSData *giftData = [NSJSONSerialization dataWithJSONObject:giftProducts options:NSJSONWritingPrettyPrinted error:nil];
    NSString *giftString = [[NSString alloc] initWithData:giftData encoding:NSUTF8StringEncoding];
    
    [params setObject:giftString forKey:@"gift_products"];
    
    NSLog(@"%@", params);
    
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    self.progressHUD.labelText = @"Loading...";
    [self.progressHUD show:YES];
    __unsafe_unretained TradeInputViewController *blockSelf = self;
    [self.manager POST:API_TRADE_INPUT_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = (NSDictionary *)responseObject;
        NSInteger code = [[jsonDic objectForKey:@"code"] integerValue];
        if (code == 1) {
            [blockSelf.navigationController popViewControllerAnimated:YES];
            blockSelf.progressHUD.mode = MBProgressHUDModeText;
            blockSelf.progressHUD.labelText = [jsonDic objectForKey:@"data"];
            [blockSelf.progressHUD hide:YES afterDelay:3];
        }else{
            blockSelf.progressHUD.mode = MBProgressHUDModeText;
            blockSelf.progressHUD.labelText = [jsonDic objectForKey:@"data"];
            [blockSelf.progressHUD hide:YES afterDelay:3];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        blockSelf.progressHUD.mode = MBProgressHUDModeText;
        blockSelf.progressHUD.labelText = [error localizedDescription];
        [blockSelf.progressHUD hide:YES afterDelay:3];
    }];
    
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
