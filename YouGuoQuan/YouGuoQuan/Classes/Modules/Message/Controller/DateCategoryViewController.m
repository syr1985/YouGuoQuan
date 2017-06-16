//
//  DateCategoryViewController.m
//  YouGuoQuan
//
//  Created by liushuai on 2017/1/2.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "DateCategoryViewController.h"
#import "EvaluateListViewController.h"
#import "DatingOrderViewController.h"

@interface DateCategoryViewController ()
@property (nonatomic, strong) NSArray *dateTypeArray;
@property (nonatomic, strong) NSArray *imageNameArray;
@end

@implementation DateCategoryViewController

- (NSArray *)dateTypeArray {
    if (!_dateTypeArray) {
        _dateTypeArray = @[@"吃饭",@"发呆",@"看电影",@"下午茶",@"私摄",@"旅行"];
    }
    return _dateTypeArray;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"约见";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"关闭"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBack)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = FontColor;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"他人评价"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(pushToEvalutionVC)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.tintColor = NavTabBarColor;
}

- (void)actionBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushToEvalutionVC {
    UIStoryboard *focusSB = [UIStoryboard storyboardWithName:@"Focus" bundle:nil];
    EvaluateListViewController *evaluateVC = [focusSB instantiateViewControllerWithIdentifier:@"EvaluateListVC"];
    evaluateVC.goodsId = _userId;
    evaluateVC.totalNumber = @"0";
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:evaluateVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    PublishDateViewController *vc = [[PublishDateViewController alloc] initWithDateType:indexPath.row userID:_userId];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    UIStoryboard *messageSB = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    DatingOrderViewController *datingOrderVC = [messageSB instantiateViewControllerWithIdentifier:@"DatingOrderVC"];
    datingOrderVC.userId = _userId;
    datingOrderVC.dateType = self.dateTypeArray[indexPath.row];
    [self.navigationController pushViewController:datingOrderVC animated:YES];
}

@end
