//
//  ShippingAddressViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/10.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "ShippingAddressViewController.h"

@interface ShippingAddressViewController () <UITableViewDelegate>

@end

@implementation ShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleString = @"收货地址";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 36;
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
