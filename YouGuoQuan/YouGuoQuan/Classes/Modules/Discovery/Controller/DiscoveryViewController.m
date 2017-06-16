//
//  DiscoveryViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/10.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "SCNavTabBarController.h"
#import "RecommendViewController.h"
#import "NearbyPersonViewController.h"

#import "MoreMenuHelp.h"
#import "UIImage+Color.h"

@interface DiscoveryViewController ()

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubViewControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

// 添加子控制器
- (void)setupSubViewControllers {
    
    //    CrowdfundingViewController *crowdVC = [[CrowdfundingViewController alloc] init];
    //    crowdVC.title = @"众筹";
    
    RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
    recommendVC.title = @"推荐";
    
    UIStoryboard *discoverySB = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
    NearbyPersonViewController *nearbyVC = [discoverySB instantiateViewControllerWithIdentifier:@"NearbyPerson"];
    nearbyVC.title = @"附近";
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[recommendVC, nearbyVC];
    navTabBarController.navTabBarColor     = [UIColor whiteColor];
    navTabBarController.navTabBarLineColor = NavTabBarColor;
    navTabBarController.navType = NavType_Hidden;
    navTabBarController.titleFont = [UIFont systemFontOfSize:17];
    navTabBarController.showSpaceLine = YES;
    navTabBarController.setupScreenButton = YES;
    [navTabBarController addParentController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
