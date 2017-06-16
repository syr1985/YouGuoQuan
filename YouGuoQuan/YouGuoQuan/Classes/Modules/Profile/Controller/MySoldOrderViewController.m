//
//  MySoldOrderViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "MySoldOrderViewController.h"
#import "SCNavTabBarController.h"
#import "AllSoldOrderListViewController.h"

@interface MySoldOrderViewController ()

@end

@implementation MySoldOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = _fromSellWeixinPage ? @"打赏列表" : @"我售出的";
    
    UIStoryboard *soldSB = [UIStoryboard storyboardWithName:@"Sold" bundle:nil];
    AllSoldOrderListViewController *allSoldOrderVC = [soldSB instantiateViewControllerWithIdentifier:@"AllSoldOrderListVC"];
    allSoldOrderVC.type = SoldOrderType_All;
    allSoldOrderVC.fromSellWeixinPage = _fromSellWeixinPage;
    allSoldOrderVC.title = @"全部";
    
    AllSoldOrderListViewController *undoSoldListVC = [soldSB instantiateViewControllerWithIdentifier:@"AllSoldOrderListVC"];
    undoSoldListVC.type = SoldOrderType_Undo;
    undoSoldListVC.fromSellWeixinPage = _fromSellWeixinPage;
    undoSoldListVC.title = @"未处理";
    
    AllSoldOrderListViewController *doneSoldListVC = [soldSB instantiateViewControllerWithIdentifier:@"AllSoldOrderListVC"];
    doneSoldListVC.type = SoldOrderType_Done;
    doneSoldListVC.fromSellWeixinPage = _fromSellWeixinPage;
    doneSoldListVC.title = @"已处理";
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[allSoldOrderVC, undoSoldListVC, doneSoldListVC];
    navTabBarController.navTabBarColor     = [UIColor whiteColor];
    navTabBarController.navTabBarLineColor = [UIColor whiteColor];
    navTabBarController.titleFont = [UIFont systemFontOfSize:14];
    navTabBarController.navType = NavType_Order;
    navTabBarController.showSpaceLine = YES;
    [navTabBarController addParentController:self];
    
    if (_fromSellWeixinPage) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回-黑"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(backToViewController)];
        leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)backToViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
