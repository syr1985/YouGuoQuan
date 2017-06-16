//
//  POISearchViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/5/23.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "POISearchViewController.h"
#import <MAMapKit/MAMapView.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "AlertViewTool.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface POISearchViewController ()<UISearchBarDelegate, MAMapViewDelegate, AMapSearchDelegate, CLLocationManagerDelegate>
@property (nonatomic,   weak) IBOutlet MAMapView *mapView;
@property (nonatomic,   weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic,   weak) IBOutlet UITableView *tableView;
@property (nonatomic,   weak) IBOutlet UIButton *locationBtn;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) AMapPOI *currentPOI;
@property (nonatomic, strong) NSMutableArray *locationArray;
@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation POISearchViewController

- (void)dealloc {
    _mapView.delegate = nil;
    _mapView = nil;
    NSLog(@"%s",__func__);
}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

- (NSMutableArray *)locationArray {
    if (!_locationArray) {
        _locationArray = [NSMutableArray new];
    }
    return _locationArray;
}

- (NSMutableArray *)annotationArray {
    if (!_annotationArray) {
        _annotationArray = [NSMutableArray new];
    }
    return _annotationArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configViewController];
}

- (void)configViewController {
    self.title = @"位置";
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回-黑"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionGoBack)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor darkTextColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(actionSendLocation)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.tintColor = NavTabBarColor;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    _tableView.rowHeight = 56;
    
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    _mapView.zoomLevel = 16;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    //地图跟踪模式
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    //后台定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
//    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(actionEndEditing)];
    [_mapView addGestureRecognizer:tap];
    
    [_mapView bringSubviewToFront:_locationBtn];
    
    [self startLocation];
}

- (void)actionEndEditing {
    [self.searchBar endEditing:YES];
}

- (void)actionGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发送位置
- (void)actionSendLocation {
    UIImage *image = [self getImageViewWithView:_mapView];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    __weak typeof(self) weakself = self;
    [NetworkTool uploadImage:imageData progress:nil success:^(NSString *url) {
        [weakself actionSendLocationInfoBlock:url];
    } failure:^{
        [weakself actionSendLocationInfoBlock:nil];
    }];
}

- (UIImage *)getImageViewWithView:(UIView *)view {
    UIGraphicsBeginImageContext(view.frame.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 发送位置
- (void)actionSendLocationInfoBlock:(NSString *)url {
    if (_sendLocationInfo) {
        _sendLocationInfo(_currentPOI, url);
    }
    [self actionGoBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window) {// 是否是正在使用的视图
            // Add code to preserve data stored in the views that might be
            // needed later.
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

#pragma mark - 开始定位
- (IBAction)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 0.1;
            [_locationManager requestWhenInUseAuthorization];
        }
        // 开始时时定位
        [_locationManager startUpdatingLocation];
    } else {
        //提示用户无法进行定位操作
        [SVProgressHUD showInfoWithStatus:@"请确认开启定位功能"];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations.count) {
//        _locationBtn.selected = YES;
        [_locationManager stopUpdatingLocation];
        CLLocationCoordinate2D coordinate = _mapView.userLocation.coordinate;
        _currentLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        [self searchNearBySearchKey:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
        }
            break;
        case kCLAuthorizationStatusDenied: {
            [SVProgressHUD showInfoWithStatus:@"请到设置页面打开应用的定位服务"];
        }
        default:
            break;
    }
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    static NSString *annoId = @"Annotation";
    // 获取可重用的锚点控件
    MAAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:annoId];
    // 如果可重用的锚点控件不存在，创建新的可重用锚点控件
    if (!annoView) {
        annoView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annoId];
        annoView.image = [UIImage imageNamed:@"位置-定位"];
    }
//    if ([annotation isKindOfClass:[MAUserLocation class]]) {
//        annoView.image = [UIImage imageNamed:@"位置-定位"];
//    }n
//    NSLog(@"%@",annotation);
    
    return annoView;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    _currentLocation = userLocation.location;
    
    //[self searchNearBySearchKey:nil];
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if(response.pois.count == 0) {
        return;
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
    
    [self.locationArray removeAllObjects];
    for (AMapPOI *p in response.pois) {
        //NSLog(@"%@",[NSString stringWithFormat:@"%@\nPOI: %@,%@", p.description,p.name,p.address]);
        //搜索结果存在数组
        [self.locationArray addObject:p];
    }
    if (self.locationArray.count) {
        _currentPOI = self.locationArray[0];
        [self moveToMapItem:_currentPOI];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Location"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Location"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = FontColor;
        cell.detailTextLabel.textColor = GaryFontColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }

    AMapPOI *p = self.locationArray[indexPath.row];
    cell.textLabel.text = p.name;
    cell.detailTextLabel.text = p.address;

    if (p == _currentPOI) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"位置-选中"]];
    } else {
        cell.accessoryView = nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar endEditing:YES];
    [self moveToMapItem:self.locationArray[indexPath.row]];
    [self.tableView reloadData];
}

- (void)moveToMapItem:(AMapPOI *)poi {
    _currentPOI = poi;
    
    self.navigationItem.rightBarButtonItem.enabled = poi != nil;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    MACoordinateRegion region = MACoordinateRegionMake(location, MACoordinateSpanMake(0.01, 0.01));
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.searchBar setShowsCancelButton:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.searchBar setShowsCancelButton:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchNearBySearchKey:searchBar.text];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text = @"";
    [self actionEndEditing];
    [self searchNearBySearchKey:nil];
}

#pragma mark - 根据location搜索周边地点
- (void)searchNearBySearchKey:(NSString *)searchKey {
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    //当前位置
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    
    //关键字
    request.keywords = searchKey;
    
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    // request.types = @"餐饮服务|生活服务";
    // request.radius =  5000; 
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [self.search AMapPOIAroundSearch:request];
}

@end
