//
//  NearbyViewController.m
//  ECIGARFAN
//
//  Created by cool on 14-4-8.
//  Copyright (c) 2014年 cool. All rights reserved.
//

#import "NearbyViewController.h"
#import "MapView.h"
#import "LocalStroge.h"
#import "mapModel.h"
#import "GetDealer.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReaderDelegate.h"


@interface NearbyViewController ()<MapViewDelegate,CLLocationManagerDelegate,getDearlerDelegate,UIAlertViewDelegate,QRCodeReaderDelegate>
@property (nonatomic,strong) MapView *mapView;
@property (nonatomic,strong) NSMutableArray *annotations;
@property (strong,nonatomic) mapModel *item;
@property (strong,nonatomic) NSMutableArray *DistanceArray;
@property (nonatomic,strong) CLLocationManager *manager;
@property (strong,nonatomic) UIButton *locationBtn;
@property (strong,nonatomic) GetDealer *getDealer;
@property (strong, nonatomic) SearchViewController *searchView;
@end

@implementation NearbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}



-(void)setDefaultLocation:(mapModel*)model
{
    if (!_mapView.selMapAnnotation) {
        _mapView.selMapAnnotation = [[BasicMapAnnotation alloc] init];
    }
    [_mapView.selMapAnnotation setTitle:model.dealerName];
    [_mapView.selMapAnnotation setLatitude:(CLLocationDegrees)[model.dealerLatitude doubleValue]];
    [_mapView.selMapAnnotation setLongitude:(CLLocationDegrees)[model.dealerLongitude doubleValue]];
    
    [_mapView refreshAnnotationView];    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
    

    //如果没有数据，重新加载
    if (![[GetDealer shareInstance:nil] localArr].count) {
        _getDealer=[GetDealer shareInstance:API_DEALER_URL];
        _getDealer.delegate=self;
        _annotations = [[GetDealer shareInstance:nil] localArr];
    }
    
    if (_mapView.isPushed) {
        _mapView.isPushed = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //请求数据
    _getDealer=[GetDealer shareInstance:API_DEALER_URL];
    _getDealer.delegate=self;

    self.view.backgroundColor=COLOR_WHITE_NEW;
    self.title = NSLocalizedString(@"Nearby", "");
    
    _annotations = [[GetDealer shareInstance:nil] localArr];
    //初始化
    [self mapViewInit];
    
    //首次使用默认位置
    [self getAnnotationFirst];
    
    //定位
    [self location];
    
    //数据
    _item=[[mapModel alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationOver) name:@"locationOver" object:nil];

}


-(void)mapViewInit
{
    if (_mapView==nil) {
        _mapView = [[MapView alloc] initWithDelegate:self];
        _mapView.frame=self.view.bounds;
        [self.view addSubview:_mapView];
    }

    
    [_mapView beginLoad];
    
    //右搜索菜单
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchList"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Search", nil) style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //临时设置左按键为扫描二维码
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qrcode"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoQRCode)];
    
    _locationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [_locationBtn setImage:[UIImage imageNamed:@"location_higlight"] forState:UIControlStateDisabled];
    _locationBtn.frame = CGRectMake(5, kScreen_Height-125, 50, 50);
    
    [_locationBtn addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_locationBtn];

}


#pragma mark
#pragma mark getDealerDelegate
-(void)reloadView
{
    _locationBtn=nil;
    _annotations = [[GetDealer shareInstance:nil] localArr];
    [self mapViewInit];
    [self location];
}



-(void)getAnnotationFirst
{
    
        if ([[LocalStroge sharedInstance] getObjectAtKey:F_LAST_LOCATION filePath:NSCachesDirectory]) {
            CLLocation *defaultLocation=[[LocalStroge sharedInstance] getObjectAtKey:F_LAST_LOCATION filePath:NSCachesDirectory];
            
            MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
            theRegion.center.latitude =defaultLocation.coordinate.latitude;
            theRegion.center.longitude =defaultLocation.coordinate.longitude;
            
            theRegion.span.longitudeDelta = 0.025;
            theRegion.span.latitudeDelta = 0.025;
            [_mapView.mapView setRegion:theRegion animated:NO];
        }else
        {
            MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
            theRegion.center.latitude =22.5361990000;
            theRegion.center.longitude =114.0260650000;
            theRegion.span.longitudeDelta = 0.025;
            theRegion.span.latitudeDelta = 0.025;
            [_mapView.mapView setRegion:theRegion animated:NO];
            
        }
    
    
}

#pragma mark-

-(void)gotoQRCode
{
    static QRCodeReaderViewController *reader = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        reader                        = [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    reader.delegate = self;
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
       // NSLog(@"Completion with result: %@", resultAsString);
    }];
    
    [self presentViewController:reader animated:YES completion:NULL];
    
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([[result substringToIndex:4] isEqualToString:@"http"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"QRCodeReader", nil) message:result delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}




-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    if (_locationBtn.enabled==NO) {
        _locationBtn.enabled=YES;
    }
}


#pragma mark  ---定位方法

- (void)location {
    

    _locationBtn.enabled=NO;
    //定位功能开启的情况下进行定位
    _manager = [[CLLocationManager alloc] init];
    //设置每50米更新一次定位
    _manager.distanceFilter = 50;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    _manager.delegate=self;
    
    
    // if location services are restricted do nothing
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
         _locationBtn.enabled=YES;
        //弹出 请打开定位的提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to locate", @"") message:NSLocalizedString(@"Your phone is not currently open location service, if you want to open the location service, please refer to the privacy Settings->Privacy->Location, open Location Services", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Sure", @""), nil];
        alert.tag=101;
        [alert show];
        return ;
    }
    
        NSString * ver = [[UIDevice currentDevice] systemVersion];
        if ([ver floatValue] >= 8.0f) {
            [_manager requestAlwaysAuthorization];
        }
  
    [_manager startMonitoringSignificantLocationChanges];
    [_manager startUpdatingLocation];
    _mapView.mapView.showsUserLocation =(_mapView.mapView.showsUserLocation) ? NO : YES;
   
    if (_mapView.mapView.showsUserLocation==NO) {
        _locationBtn.enabled=YES;
    }
    
    [_mapView.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
}

#pragma mark  location 新方法定位



- (void)locationManager:(CLLocationManager *)manager

       didFailWithError:(NSError *)error

{
     _locationBtn.enabled=YES;
    [manager stopUpdatingLocation];
  //  NSLog(@"Fixed GPS positioning failure");
    //NSString *errorString;
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            //errorString = @"Access to Location Services denied by user";
            //Do something...
            [[[UIAlertView alloc] initWithTitle:@"Hint" message:@"Please open the location service!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Sure", nil] show];
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
           // errorString = @"Location data unavailable";
            [[[UIAlertView alloc] initWithTitle:@"Hint" message:@"Location service is not available!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Sure", nil] show];
            //Do something else...
            break;
        default:
            //errorString = @"An unknown error has occurred";
            [[[UIAlertView alloc] initWithTitle:@"Hint" message:@"Location error!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Sure", nil] show];
            break;
    }
}


//新方法
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
  
    [[LocalStroge sharedInstance] addObject:[locations lastObject] forKey:F_LAST_LOCATION filePath:NSCachesDirectory];
    
    //显示具体地址
    
//        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
//        [geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray*placemarks,NSError* error)
//         {
//    
//                      for (CLPlacemark* place in placemarks) {
//                          //NSLog(@"+++++++");
//                          NSLog(@"name %@",place.name); //位置
//                          NSLog(@"thoroughfare %@",place.thoroughfare);//街道
//                          //子街道
//                          NSLog(@"subthoroughfare %@",place.subAdministrativeArea);
//                          //市
//                          NSLog(@"loclitity %@",place.locality);
//                          //区
//                          NSLog(@"subLocality %@",place.subLocality);
//                          //国家
//                          NSLog(@"country %@",place.country);
//                          NSLog(@"_______________________这里是分割线");
//                      }
//             
//         }];
    //定位完毕更新距离
    [self getDistance];
    //更新搜索视图的信息
    [_searchView reloadData];
}



-(void)search
{
    if (!_searchView) {
        _searchView = [[SearchViewController alloc] init] ;
    }
    [self.navigationController pushViewController:_searchView animated:YES];
 
}


#pragma mark
#pragma mark MapViewDelegate

- (NSInteger)numbersWithCalloutViewForMapView
{
    return [_annotations count];
}

- (CLLocationCoordinate2D)coordinateForMapViewWithIndex:(NSInteger)index
{

    _item= [[mapModel alloc] loadDataAndReturn:[_annotations objectAtIndex:index]];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [_item.dealerLatitude doubleValue];
	coordinate.longitude = [_item.dealerLongitude doubleValue];
    
    return coordinate;
}

- (NSString *)titleForMapViewAtIndex:(NSInteger)index
{
    if (_item) {
        return _item.dealerName;
    }else{
        _item= [[mapModel alloc] loadDataAndReturn:[_annotations objectAtIndex:index]];
        return _item.dealerName;
    }
}

- (UIImage *)baseMKAnnotationViewImageWithIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"pin_1"];
}

- (UIView *)mapViewCalloutContentViewWithIndex:(NSInteger)index
{
    _item= [[mapModel alloc] loadDataAndReturn:[_annotations objectAtIndex:index]];
    
    
    MapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"MapCell" owner:self options:nil] objectAtIndex:0];
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=4;
    cell.title.text = _item.dealerName;
    cell.subtitle.text = _item.dealerPhone;
    cell.typeImage.image=[UIImage imageNamed:@"ecigInformation"];
     [cell bringSubviewToFront:_mapView];
    [cell setBackgroundColor:COLOR_WHITE_NEW]; //yu mark 标记颜色
    
    return cell;
}

- (void)calloutViewDidSelectedWithIndex:(NSInteger)index
{
    if (!_displayVC) {
        _displayVC=[[DealerViewController alloc] init];
    }
    _displayVC.delegate = (id)self;
    _displayVC.dealerItem= [[mapModel alloc] loadDataAndReturn:[_annotations objectAtIndex:index]];
    _displayVC.dealerCoordinate = [NSArray arrayWithObjects:_item.dealerLatitude,_item.dealerLongitude,nil];
    
    [_displayVC.dealerInformationTable reloadData];
    [self.navigationController pushViewController:_displayVC animated:YES];
}

#pragma mark - DealerViewControllerDelegate

- (void) didSelectedDealerItem:(mapModel *)model
{
    [self setDefaultLocation:model];

}

#pragma mark getDistance
-(void) getDistance
{
    
    NSMutableDictionary *dealerDic;
    NSMutableArray *dealerArray=[[NSMutableArray alloc] initWithArray:_annotations];
   
    
    CLLocation *currentLocation=[[LocalStroge sharedInstance] getObjectAtKey:F_LAST_LOCATION filePath:NSCachesDirectory];
    _DistanceArray=[[NSMutableArray alloc] init];
    for (int i=0; i<[_annotations count]; i++) {
        CLLocation *itemLocation=[[CLLocation alloc] initWithLatitude:[[[_annotations objectAtIndex:i] objectForKey:@"dealer_lat"] doubleValue] longitude:[[[_annotations objectAtIndex:i] objectForKey:@"dealer_lng"] doubleValue]];
        CLLocationDistance meters=[currentLocation distanceFromLocation:itemLocation];
        [_DistanceArray addObject:[NSString stringWithFormat:@"%.3f",meters/1000]];
        
        dealerDic=[[NSMutableDictionary alloc] initWithDictionary:[_annotations objectAtIndex:i]];

        [dealerDic setObject:[NSString stringWithFormat:@"%.3f",meters/1000] forKey:@"dealer_distance"];
        
        [dealerArray replaceObjectAtIndex:i withObject:dealerDic];
        
    }
    [[GetDealer shareInstance:nil] setLocalArr:dealerArray];
//    [[LocalStroge sharedInstance] addObject:dealerArray forKey:F_DEALER_INFORMATION filePath:NSCachesDirectory];
}



-(void)locationOver
{

    //定位完全结束
    if (_locationBtn.enabled==NO) {
        _locationBtn.enabled=YES;
    }
}


#pragma -mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==101) {
        if (buttonIndex==1)
        {
            //目前无法跳转定位设置界面,ios已禁用
         
        }

    }
}

//导航方法
- (void)goThere{
    
    CLLocationCoordinate2D to;
    NSUserDefaults *dealerCoordinateArray=[NSUserDefaults standardUserDefaults];
    if ([dealerCoordinateArray objectForKey:@"dealer_Id"]) {
        
        to.latitude=[[(NSArray*)[dealerCoordinateArray objectForKey:@"dealer_Id"] objectAtIndex:0] doubleValue];
        
         to.longitude=[[(NSArray*)[dealerCoordinateArray objectForKey:@"dealer_Id"] objectAtIndex:1] doubleValue];
    }
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
    
    
    toLocation.name = @"Destination";
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                   launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                             forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
}


-(void)dealloc
{
    
    [_getDealer cancelRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
