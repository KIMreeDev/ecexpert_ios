//
//  CigAndWineInfViewController.m
//  ECIGARFAN
//
//  Created by renchunyu on 14/12/5.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "CigAndWineInfViewController.h"
#import "MapView.h"

@interface CigAndWineInfViewController ()
{
    UIImageView *callImageView;
    UILabel *GPSLabel;
}
@end

@implementation CigAndWineInfViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=COLOR_WHITE_NEW;
    self.title = NSLocalizedString(@"Dealer information", "");
    //NSLog(@"%@",_dealerCoordinate);
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (!_dealerItem.dealerDistance) {
        int num[3]={2,3,1};
        return num[section];
    }else{
        int num[3]={3,3,1};
        return num[section];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row[3]={150,100,40};
    
    if (indexPath.section==0) {
        return row[indexPath.row];
    }else if(indexPath.section==1)
    {
        
        return 60;
        
    }else{
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 15;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:nil];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines=0;
        cell.separatorInset=UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        //拨号图标
        callImageView=[[UIImageView alloc] initWithFrame:CGRectMake(250, 0, 60, 60)];
        callImageView.image=[UIImage imageNamed:@"callImage"];
        //定位
        GPSLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
        GPSLabel.textColor=COLOR_WHITE_NEW;
        GPSLabel.textAlignment=NSTextAlignmentCenter;
        GPSLabel.font=[UIFont systemFontOfSize:13];
        GPSLabel.text=NSLocalizedString(@"Directions to Here", nil);
        
        
    }
    
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
            [cell addSubview:imageView];
            if ((_dealerItem.dealerLogo==NULL)||[_dealerItem.dealerLogo isEqualToString:@""]) {
                imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dealerLogo.jpg"]];
            }else{
                NSURL *url=[NSURL URLWithString:_dealerItem.dealerLogo];
                [imageView setImageWithURL:url];
            }
            
        }else if(indexPath.row==1){
            cell.textLabel.textColor=COLOR_LIGHT_BLUE_THEME;
            cell.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"Dealer address:%@", ""),_dealerItem.dealerAddress];
            cell.detailTextLabel.textColor=COLOR_LIGHT_BLUE;
            if (_dealerItem.dealerDistance) {
                cell.detailTextLabel.text=[NSString stringWithFormat:NSLocalizedString(@"%@km", nil),_dealerItem.dealerDistance];
            }
            
        }else{
            
            cell.backgroundColor=COLOR_LIGHT_BLUE_THEME;
            [cell addSubview:GPSLabel];
        }
        
        
    }else if (indexPath.section==1) {
        if (indexPath.row==0) {
            
            cell.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"Dealer name:%@", ""),_dealerItem.dealerName];
            
        }else if(indexPath.row==1){
            cell.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"Contact:%@", ""),_dealerItem.dealerConnector];
            
        }else if(indexPath.row==2)
        {
            
                 cell.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"Phone:%@", ""),_dealerItem.dealerTel];
            if ([_dealerItem.dealerTel isEqualToString:@""]){
                  cell.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"Phone:%@", ""),_dealerItem.dealerPhone];
            }
            if (![cell.textLabel.text isEqualToString:@""]) {
                [cell addSubview:callImageView];
            }
       
        }
        [self dynamicCell:cell defaultHeight:70];
        
    }else if (indexPath.section==2) {
        
        cell.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"Dealer description:%@", ""),_dealerItem.dealerDescription];
        cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:14];
        [self dynamicCell:cell defaultHeight:100];
        
    }
    
    return cell;
}


//动态cell
-(void)dynamicCell:(UITableViewCell*)cell defaultHeight:(float)height
{
    CGRect cellFrame = [cell frame];
    cellFrame.origin = CGPointMake(0, 0);
    CGRect rect = CGRectInset(cellFrame, 20, 10);
    cell.textLabel.frame = rect;
    [cell.textLabel sizeToFit];
    if (cell.textLabel.frame.size.height > (height-16)) {
        cellFrame.size.height = height + cell.textLabel.frame.size.height - (height-16);
    }
    else {
        cellFrame.size.height = height;
    }
    [cell setFrame:cellFrame];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section==0&&indexPath.row==1) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        _dealerCoordinate=[NSArray arrayWithObjects:_dealerItem.dealerLatitude,_dealerItem.dealerLongitude,nil];
        NSUserDefaults *dealerCoordinateArray=[NSUserDefaults standardUserDefaults];
        [dealerCoordinateArray setObject:_dealerCoordinate forKey:@"dealer_Id"];
        [dealerCoordinateArray synchronize];
        
    }else if(indexPath.section==0&&indexPath.row==2)
    {
        [self goThere];
        
    }else if(indexPath.section==1&&indexPath.row==2)
    {
        
        [self call];
        
    }
    
}


-(void)labelInit:(UILabel*)label name:(NSString*)string size:(CGRect)frame numerOfLines:(int)num fontSize:(int)size{
    label.text=string;
    label.textColor=COLOR_DARK_GRAY;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.frame = frame;
    label.numberOfLines=num;
    label.font = [UIFont fontWithName:@"Helvetica" size:size];
    label.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)call{
    
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_dealerItem.dealerTel]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的View 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}



//导航方法
- (void)goThere{
    
    CLLocationCoordinate2D to;
    to.latitude=[_dealerItem.dealerLatitude doubleValue];
    to.longitude=[_dealerItem.dealerLongitude doubleValue];
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
    
    toLocation.name = @"Destination";
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                   launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                             forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

