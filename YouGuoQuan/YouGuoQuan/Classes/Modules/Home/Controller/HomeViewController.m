//
//  HomeViewController.m
//  RoomService
//
//  Created by YM on 15/12/26.
//  Copyright © 2015年 SYR. All rights reserved.
//

#import "HomeViewController.h"

#import "SCNavTabBarController.h"
#import "YouguoViewController.h"
#import "FocusViewController.h"
#import "VideoViewController.h"
#import "LocationViewController.h"
#import "DiscoveryViewController.h"
#import "SearchViewController.h"

#import "CityLocation.h"
#import "UIImage+Color.h"
#import "NSString+StringSize.h"
#import "AlertViewTool.h"
#import "JZLocationConverter.h"

#define KEY_USER_LOCATION @"LOCATION_CITY_YGQ"

@interface HomeViewController () <UITextFieldDelegate, UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;
@property (nonatomic, strong) NSArray *hotSearchs;
@end

@implementation HomeViewController

#pragma mark -
#pragma mark - 懒加载
- (NSArray *)hotSearchs {
    if (!_hotSearchs) {
        _hotSearchs = [NSArray new];
    }
    return _hotSearchs;
}

#pragma mark -
#pragma mark - 系统方法
- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *loginInfo = [SCUserDefault objectForKey:KEY_USER_ACCOUNT];
    if (loginInfo) {
        [LoginData loginDataWithDict:loginInfo];
    }
    // 配置控制器
    [self configViewController];
    
    [self configLocationCity];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(login)
                                                 name:kNotification_Logout
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (![LoginData sharedLoginData].userId) {
        SCNavTabBarController *navTabBarController = self.childViewControllers[0];
        if (navTabBarController.currentIndex == 2) {
            [navTabBarController resetIndex];
        }
    }
}

#pragma mark -
#pragma mark - 添加子控制器
- (void)configViewController {
    //self.view.backgroundColor = NavBackgroundColor;
    
    self.tabBarController.delegate = self;
    
    UICollectionViewFlowLayout *flowLayout_youguo = [[UICollectionViewFlowLayout alloc] init];
    YouguoViewController *youguoVC = [[YouguoViewController alloc] initWithCollectionViewLayout:flowLayout_youguo];
    youguoVC.title = @"人气";
    
    UICollectionViewFlowLayout *flowLayout_video = [[UICollectionViewFlowLayout alloc] init];
    flowLayout_video.minimumLineSpacing = 8;
    flowLayout_video.minimumInteritemSpacing = 7;
    flowLayout_video.sectionInset = UIEdgeInsetsMake(0, 6, 0, 6);
    VideoViewController *videoVC = [[VideoViewController alloc] initWithCollectionViewLayout:flowLayout_video];
    videoVC.title = @"视频";
    
    FocusViewController *focusVC = [[FocusViewController alloc] init];
    focusVC.title = @"关注";
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[youguoVC, videoVC, focusVC];
    navTabBarController.navTabBarColor     = [UIColor whiteColor];
    navTabBarController.navTabBarLineColor = NavTabBarColor;
    navTabBarController.navType = NavType_Custom;
    navTabBarController.titleFont = [UIFont systemFontOfSize:17];
    navTabBarController.isHomeFocusPage = YES;
    [navTabBarController addParentController:self];
    
    // 搜索栏
    UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索-浅"]];
    leftImage.frame = CGRectMake(10, 7, 15, 15);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [leftView addSubview:leftImage];
    _searchBar.delegate = self;
    _searchBar.leftView = leftView;
    _searchBar.font = [UIFont systemFontOfSize:14];
    _searchBar.leftViewMode = UITextFieldViewModeAlways;
    _searchBar.tintColor = [UIColor clearColor];
    _searchBar.layer.cornerRadius = 2;
    _searchBar.layer.masksToBounds = YES;
    
    [self.view bringSubviewToFront:_navView];
}

- (void)configLocationCity {
    NSString *saveCity = [SCUserDefault objectForKey:KEY_USER_LOCATION];
    if (saveCity) {
        [self resetLocationButton:saveCity];
    }
    
    __weak typeof(self) weakself = self;    
    [CityLocation sharedInstance].locationSuccess = ^(NSString *city){
        NSString *saveCity = [SCUserDefault objectForKey:KEY_USER_LOCATION];
        if (saveCity) {
            if (![saveCity isEqualToString:city]) {
                [weakself warningToChangeCity:city];
            } else {
                [weakself resetLocationButton:city];
            }
        } else {
            [weakself warningToChangeCity:city];
        }
    };
    
    [[CityLocation sharedInstance] startLocation];
}

- (void)resetLocationButton:(NSString *)city {
    CGFloat width = [NSString widthWithString:city
                                      maxSize:CGSizeMake(0, 30)
                                      strFont:[UIFont systemFontOfSize:14]];
    _buttonWidthConstraint.constant = width + 30;
    [_locationButton setTitle:city forState:UIControlStateNormal];
}

- (void)warningToChangeCity:(NSString *)city {
    NSString *msg = [NSString stringWithFormat:@"系统检测到您当前的城市是%@，是否要切换城市？",city];
    [AlertViewTool showAlertViewWithTitle:nil Message:msg cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
        [self resetLocationButton:city];
        [SCUserDefault setObject:city forKey:KEY_USER_LOCATION];
        [SCUserDefault synchronize];
    } cancelBlock:nil];
}

#pragma mark -
#pragma mark - 跳转定位页面
- (IBAction)locationForCity:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    LocationViewController *locationVC = [storyboard instantiateViewControllerWithIdentifier:@"LocationVC"];
    locationVC.hidesBottomBarWhenPushed = YES;
    __weak typeof(self) weakself = self;
    locationVC.cityBlock = ^(NSString *city) {
        [weakself resetLocationButton:city];
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    UIStoryboard *homeSB = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UITableViewController *searchVC = [homeSB instantiateViewControllerWithIdentifier:@"SearchVC"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    [self.navigationController presentViewController:nav animated:NO completion:nil];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UINavigationController *nav = (UINavigationController *)viewController;
    UIViewController *rootVC = nav.topViewController;
    if ([rootVC isKindOfClass:[self class]] || [rootVC isKindOfClass:[DiscoveryViewController class]]) {
        return YES;
    } else {
        if ([LoginData sharedLoginData].userId) {
            return YES;
        } else {
            [self login];
            return NO;
        }
    }
}

- (void)login {
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *loginVC = [loginSB instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self presentViewController:loginVC animated:YES completion:nil];
}

@end
