//
//  PopScreenViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/4/21.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "PopScreenMenuViewController.h"

@interface PopScreenMenuViewController ()
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation PopScreenMenuViewController

- (NSArray *)titleArray {
    if (!_titleArray) {
        if (_type == ScreenMenuType_User) {
            _titleArray = @[@"查看全部",@"只看男神",@"只看女神"];
        } else if (_type == ScreenMenuType_Income) {
            _titleArray = @[@"全部明细",@"结算明细",@"平台收入",@"推广收入"];
        } else if (_type == ScreenMenuType_Recharge) {
            _titleArray = @[@"全部明细",@"充值明细",@"消费明细"];
        }
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.view.superview.layer.cornerRadius = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScreenMenuCell" forIndexPath:indexPath];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_screenMenuItemSelectedBlock) {
        _screenMenuItemSelectedBlock(indexPath.row);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
