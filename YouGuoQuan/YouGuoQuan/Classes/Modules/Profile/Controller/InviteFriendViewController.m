//
//  InviteFriendTableViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/4.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "ShareTool.h"

@interface InviteFriendViewController ()

@end

@implementation InviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.titleString = @"邀请好友";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"我的推广"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(pushToMyInviteViewController)];
    rightItem.tintColor = NavTabBarColor;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToMyInviteViewController {
//    UIStoryboard *profileSB = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
//    UIViewController *myInviteVC = [profileSB instantiateViewControllerWithIdentifier:@"MyInviteVC"];
//    [self.navigationController pushViewController:myInviteVC animated:YES];
    [self performSegueWithIdentifier:@"MyInviteSegue" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 4;
    }
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [ShareTool shareToPlatformType:indexPath.row viewController:self];
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
