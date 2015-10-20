//
//  SearchViewController.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-29.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "SearchViewController.h"
#import "NearbyViewController.h"

@interface SearchViewController ()
@end

@implementation SearchViewController


- (void)viewDidLoad
{

    [super viewDidLoad];
    self.view.backgroundColor=COLOR_WHITE_NEW;
    self.title = NSLocalizedString(@"Search", "");


    _searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, 44)];
    _searchBar.delegate=self;
    [self.view addSubview:_searchBar];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 108, kScreen_Width, kScreen_Height-159) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];

    //隐藏无内容行
    _tableView.tableFooterView=[[UIView alloc] init];
    
    //数据初始化
    [self dataInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self searchBar:_searchBar textDidChange:_searchBar.text];
}

//更新
- (void) reloadData
{
    //数据初始化
    [self dataInit];
    //更新列表
    [self searchBar:_searchBar textDidChange:_searchBar.text];
}

-(void) dataInit
{
  
    
    if ([[GetDealer shareInstance:nil] localArr] ==nil) {
        _getDealer=[GetDealer shareInstance:API_DEALER_URL];
      
    }else{
       _dataList=[[GetDealer shareInstance:nil] localArr];
//       [[LocalStroge sharedInstance] addObject:_dataList forKey:F_DEALER_INFORMATION_SORT filePath:NSCachesDirectory];
    }
    
    //排序后重新存进去
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_LAST_LOCATION filePath:NSCachesDirectory]) {
        [self sortArray:_dataList];
//        [[LocalStroge sharedInstance] addObject:_dataList forKey:F_DEALER_INFORMATION_SORT filePath:NSCachesDirectory];
    }

    _nameAndAddresslist = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in _dataList) {
        [_nameAndAddresslist addObject:[NSString stringWithFormat:@"%@\n%@", [dic objectForKey:@"dealer_name"], [dic objectForKey:@"dealer_address"]]];
    }
    _showData = _nameAndAddresslist;
    
}

//数组排序
-(void)sortArray:(NSMutableArray*)array{

    
    NSArray *newResult =[array sortedArrayUsingComparator:^(id obj1,id obj2)
     {
         NSDictionary *dic1 = (NSDictionary *)obj1;
         NSDictionary *dic2 = (NSDictionary *)obj2;
         NSNumber *num1 = (NSNumber *)[dic1 objectForKey:@"dealer_distance"];
         NSNumber *num2 = (NSNumber *)[dic2 objectForKey:@"dealer_distance"];
         if ([num1 doubleValue] < [num2 doubleValue])
         {
             return (NSComparisonResult)NSOrderedAscending;
         }
         else
         {
             return (NSComparisonResult)NSOrderedDescending;
         }
         return (NSComparisonResult)NSOrderedSame;
     }];
    _dataList=[NSMutableArray arrayWithArray:newResult];
}



#pragma mark
#pragma mark uitableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_showData count]>0?[_showData count]:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:TableSampleIdentifier];
        cell.separatorInset=UIEdgeInsetsZero;
        cell.imageView.image=[UIImage imageNamed:@"dealerSearch"];
        cell.textLabel.numberOfLines=0;
        cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:14];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor=COLOR_LIGHT_BLUE_THEME;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = COLOR_LINE_GRAY;
        
 }

    
    if (_showData != nil && _showData.count >0) {

        cell.textLabel.text=[_showData objectAtIndex:indexPath.row];
        if ([[_dataList objectAtIndex:indexPath.row] objectForKey:@"dealer_distance"]) {
            cell.detailTextLabel.text=[NSString stringWithFormat:NSLocalizedString(@"%@km", nil),[[_dataList objectAtIndex:indexPath.row] objectForKey:@"dealer_distance"]];
        }

    }
    return cell;
}



//init method
-(UILabel*) labelInit:(UILabel*)label size:(CGRect)frame{
    
    label.backgroundColor=[UIColor clearColor];
    label.textColor=COLOR_ECIGARFAN_WHITE;
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment=UIBaselineAdjustmentAlignCenters;
    
    label.frame = frame;
    return label;
}

//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NearbyViewController *nearbyVC = self.navigationController.viewControllers.firstObject;
    if (!nearbyVC.displayVC) {
        nearbyVC.displayVC = [[DealerViewController alloc] init];
    }
    nearbyVC.displayVC.delegate = (id)nearbyVC;
    nearbyVC.displayVC.dealerItem =[[mapModel alloc] loadDataAndReturn:[_dataList objectAtIndex:[_nameAndAddresslist indexOfObject:[_showData objectAtIndex:indexPath.row]] ]];
    [nearbyVC.displayVC.dealerInformationTable reloadData];
    
    [self.navigationController pushViewController:nearbyVC.displayVC animated:YES];
  
}

#pragma mark
#pragma mark UISearchBarDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
   
    if (searchText!=nil && searchText.length>0) {
        _showData= [NSMutableArray array];
        for (NSString *tempStr in _nameAndAddresslist)
        {
            if ([tempStr rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
                [_showData addObject:tempStr];
              
            }
        }
    }
    else
    {
        _showData = [NSMutableArray arrayWithArray:_nameAndAddresslist];
    }
    
    [_tableView reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[self searchBar:self.searchBar textDidChange:nil];
    [_searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:self.searchBar textDidChange:nil];
    [_searchBar resignFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
