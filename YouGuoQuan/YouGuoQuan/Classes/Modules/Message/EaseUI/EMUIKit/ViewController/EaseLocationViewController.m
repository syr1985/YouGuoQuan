/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */


#import "EaseLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIViewController+HUD.h"
#import "EaseLocalDefine.h"
#import "JZLocationConverter.h"

static EaseLocationViewController *defaultLocation = nil;

@interface EaseLocationViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView *_mapView;
    MKPointAnnotation *_annotation;
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentLocationCoordinate;
    BOOL _isSendLocation;
}

@property (strong, nonatomic) NSString *addressString;

@end

@implementation EaseLocationViewController

@synthesize addressString = _addressString;

- (void)dealloc {
    NSLog(@"%s",__func__);
    _mapView.delegate = nil;
    _mapView = nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isSendLocation = YES;
    }
    return self;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isSendLocation = NO;
        _currentLocationCoordinate = [JZLocationConverter bd09ToGcj02:locationCoordinate];
    }
    return self;
}

+ (instancetype)defaultLocation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultLocation = [[EaseLocationViewController alloc] initWithNibName:nil bundle:nil];
    });
    
    return defaultLocation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSEaseLocalizedString(@"location.messageType", @"location message");
    
    //    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    //    [backButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/back"] forState:UIControlStateNormal];
    //    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //    [self.navigationItem setLeftBarButtonItem:backItem];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBack)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor darkTextColor];
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = YES;
    [self.view addSubview:_mapView];
    
    if (_isSendLocation) {
        _mapView.showsUserLocation = YES;//显示当前位置
        
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [sendButton setTitle:NSEaseLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [sendButton addTarget:self action:@selector(sendLocation) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sendButton]];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [self startLocation];
    }
    else{
        [self removeToLocation:_currentLocationCoordinate];
    }
}

- (void)actionBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            weakSelf.addressString = placemark.name;
            
            [weakSelf removeToLocation:userLocation.coordinate];
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [self hideHud];
    if (error.code == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:[error.userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSEaseLocalizedString(@"ok", @"OK")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                             }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *annoId = @"Annotation";
    
    // 获取可重用的锚点控件
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:annoId];
    // 如果可重用的锚点控件不存在，创建新的可重用锚点控件
    if (!annoView) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annoId];
        annoView.image = [UIImage imageNamed:@"位置-定位"];
    }
    return annoView;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
        {
            
        }
        default:
            break;
    }
}

#pragma mark - public

- (void)startLocation
{
    if([CLLocationManager locationServicesEnabled]){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 5;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    
    if (_isSendLocation) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [self showHudInView:self.view hint:NSEaseLocalizedString(@"location.ongoning", @"locating...")];
}

-(void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords
{
    if (_annotation == nil) {
        _annotation = [[MKPointAnnotation alloc] init];
    }
    else{
        [_mapView removeAnnotation:_annotation];
    }
    _annotation.coordinate = coords;
    [_mapView addAnnotation:_annotation];
}

- (void)removeToLocation:(CLLocationCoordinate2D)locationCoordinate
{
    [self hideHud];
    
    _currentLocationCoordinate = locationCoordinate;
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(_currentLocationCoordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    
    if (_isSendLocation) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    [self createAnnotationWithCoords:_currentLocationCoordinate];
}

- (void)sendLocation
{
    if (_delegate && [_delegate respondsToSelector:@selector(sendLocationLatitude:longitude:andAddress:)]) {
        [_delegate sendLocationLatitude:_currentLocationCoordinate.latitude longitude:_currentLocationCoordinate.longitude andAddress:_addressString];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
