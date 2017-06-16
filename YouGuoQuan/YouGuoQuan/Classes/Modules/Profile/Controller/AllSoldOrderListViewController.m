//
//  AllSoldOrderListViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "AllSoldOrderListViewController.h"

#import "UndoSoldOrderForTrendsViewCell.h"
#import "UndoSoldOrderForWeiXinViewCell.h"
#import "UndoSoldOrderForMeetingViewCell.h"
#import "UndoSoldOrderForRewardViewCell.h"

#import "DoneSoldOrderForRewardViewCell.h"
#import "DoneSoldOrderForWeiXinViewCell.h"
#import "DoneSoldOrderForMeetingViewCell.h"

#import <MJRefresh.h>
#import "MyOrderModel.h"

@interface AllSoldOrderListViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@end

static NSString * const kNotification_RefreshTableView = @"OperateSoldOrderSuccess";

@implementation AllSoldOrderListViewController

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray new];
    }
    return _modelArray;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView)
                                                 name:kNotification_RefreshTableView
                                               object:nil];
    
    self.pageNo = 1;
    self.pageSize = 10;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadNewData)];
    // 设置文字
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置刷新控件
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                             refreshingAction:@selector(loadMoreData)];
    // 设置文字
    [footer setTitle:@"上拉刷新数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"到底了" forState:MJRefreshStateNoMoreData];
    footer.automaticallyRefresh = NO;
    footer.hidden = YES;
    // 设置footer
    self.tableView.mj_footer = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTableView {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -
#pragma mark - 数据接口
- (void)loadNewData {
    _pageNo = 1;
    [self getMySoldOrderList];
}

- (void)loadMoreData {
    _pageNo++;
    [self getMySoldOrderList];
}

- (void)loadSuccessWithData:(id)result {
//    NSLog(@"%@",result);
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSDictionary *dict in result) {
        MyOrderModel *model = [MyOrderModel myOrderModelWithDict:dict];
        [muArray addObject:model];
    }
    self.tableView.mj_footer.hidden = muArray.count < self.pageSize;
    if (self.pageNo == 1) {
        [self.tableView.mj_header endRefreshing];
        self.modelArray = muArray;
        [self.tableView reloadData];
        self.noResultView.hidden = muArray.count != 0;
    } else {
        [self.tableView.mj_footer endRefreshing];
        [self.modelArray addObjectsFromArray:muArray];
        [self.tableView reloadData];
    }
}

- (void)loadFailure {
    if (self.pageNo == 1) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)getMySoldOrderList {
    __weak typeof(self) weakself = self;
    if (_fromSellWeixinPage) {
        NSString *dealType = [NSString stringWithFormat:@"%zd",_type];
        if (_type == 3) {
            dealType = @"";
        }
        [NetworkTool orderListOfSellWeixinWithType:dealType pageNo:@(_pageNo) pageSize:@(_pageSize) success:^(id result){
            [weakself loadSuccessWithData:result];
        } failure:^{
            [weakself loadFailure];
        }];
    } else {
        [NetworkTool getMySoldOrderListWithType:@(_type) pageNo:@(_pageNo) pageSize:@(_pageSize) success:^(id result) {
            [weakself loadSuccessWithData:result];
        } failure:^{
            [weakself loadFailure];
        }];
    }
}

#pragma mark -
#pragma mark - 操作订单
- (void)operateOrderWithNo:(NSString *)orderNo serviceType:(BOOL)type {
    [NetworkTool refuseOrAcceptServiceWithType:@(type) orderNo:orderNo success:^{
        [SVProgressHUD showSuccessWithStatus:@"订单处理成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshTableView object:nil];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"订单处理失败"];
    }];
}

- (void)deleteOrder:(NSString *)orderNo {
    [NetworkTool deleteOrder:orderNo operator:@"S" success:^{
        [SVProgressHUD showSuccessWithStatus:@"删除订单成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshTableView object:nil];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"删除订单失败"];
    }];
}

- (void)agreeWithRefundWithOrderNo:(NSString *)orderNo {
    [NetworkTool sellerAgreeWithRefundWithOrderNo:orderNo Success:^{
        [SVProgressHUD showSuccessWithStatus:@"订单处理成功"];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"订单处理失败"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderModel *model = self.modelArray[indexPath.row];
    NSString *orderNo = model.orderNo;
    __weak typeof(self) weakself = self;
    
    if ((model.orderType == 3 || model.orderType == 1) && model.orderStatus != 3) {
        // 未处理
        if ([orderNo hasPrefix:@"NM"]) {
            UndoSoldOrderForTrendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UndoSoldOrderForTrendsViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.sendedProductBlock = ^(NSString *orderNo, BOOL type) {
                [weakself operateOrderWithNo:orderNo serviceType:type];
            };
            cell.agreeWithRefundBlock = ^(NSString *orderNo) {
                [weakself agreeWithRefundWithOrderNo:orderNo];
            };
            cell.orderModel = model;
            return cell;
        } else if ([orderNo hasPrefix:@"WX"]) {
            UndoSoldOrderForWeiXinViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UndoSoldOrderForWeiXinViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.operateOrderBlock = ^(NSString *orderNo, BOOL type) {
                [weakself operateOrderWithNo:orderNo serviceType:type];
            };
            cell.agreeWithRefundBlock = ^(NSString *orderNo) {
                [weakself agreeWithRefundWithOrderNo:orderNo];
            };
            cell.orderModel = model;
            return cell;
        } else if ([orderNo hasPrefix:@"RP"] || [orderNo hasPrefix:@"RE"]) {
            UndoSoldOrderForRewardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UndoSoldOrderForRewardViewCell" forIndexPath:indexPath];
            cell.orderModel = model;
            return cell;
        } else {
            UndoSoldOrderForMeetingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UndoSoldOrderForMeetingViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.operateOrderBlock = ^(NSString *orderNo, BOOL type) {
                [weakself operateOrderWithNo:orderNo serviceType:type];
            };
            cell.agreeWithRefundBlock = ^(NSString *orderNo) {
                [weakself agreeWithRefundWithOrderNo:orderNo];
            };
            cell.orderModel = model;
            return cell;
        }
    } else {
        // 已处理
        if ([orderNo hasPrefix:@"RP"] || [orderNo hasPrefix:@"RE"]) {
            DoneSoldOrderForRewardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoneSoldOrderForRewardViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.deleteOrderBlock = ^(NSString *orderNo) {
                [weakself deleteOrder:orderNo];
            };
            cell.orderModel = model;
            return cell;
        } else if ([orderNo hasPrefix:@"WX"]) {
            DoneSoldOrderForWeiXinViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoneSoldOrderForWeiXinViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.deleteOrderBlock = ^(NSString *orderNo) {
                [weakself deleteOrder:orderNo];
            };
            cell.orderModel = model;
            return cell;
        } else {
            DoneSoldOrderForMeetingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoneSoldOrderForMeetingViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.deleteOrderBlock = ^(NSString *orderNo) {
                [weakself deleteOrder:orderNo];
            };
            cell.orderModel = model;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderModel *model = self.modelArray[indexPath.row];
    NSString *orderNo = model.orderNo;
    if (model.orderType == 3) {
        // 未处理
        if ([orderNo hasPrefix:@"WX"]) {
            return 200;
        } else if ([orderNo hasPrefix:@"RP"] || [orderNo hasPrefix:@"RE"]) {
            return 174;
        } else {
            return 223;
        }
    } else {
        // 已处理
        if ([orderNo hasPrefix:@"RP"] || [orderNo hasPrefix:@"RE"]) {
            return 174;
        } else if ([orderNo hasPrefix:@"WX"]) {
            return 200;
        } else {
            return 223;
        }
    }
}

@end