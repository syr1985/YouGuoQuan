//
//  RechargeRecordViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/4/20.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "RechargeRecordViewController.h"
#import "PopScreenMenuViewController.h"
#import <MJRefresh.h>
#import "MyConsumeModel.h"
#import "RechargeRecordViewCell.h"

@interface RechargeRecordViewController () <UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) NSInteger currentScreenIndex;
@property (nonatomic,   copy) NSString *type;
@end

@implementation RechargeRecordViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray new];
    }
    return _modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _type = [self.titleString isEqualToString:@"收入明细"] ? @"1" : @"2";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(popScreenMenu:)];
    rightItem.tintColor = NavTabBarColor;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self configTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)popScreenMenu:(UIBarButtonItem *)item {
    __weak typeof(self) weakself = self;
    BOOL income = [self.titleString isEqualToString:@"收入明细"];
    UIStoryboard *discoverySB = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
    PopScreenMenuViewController *functionListVC = [discoverySB instantiateViewControllerWithIdentifier:@"PopScreenMenuVC"];
    functionListVC.type = income ? ScreenMenuType_Income : ScreenMenuType_Recharge;
    functionListVC.modalPresentationStyle = UIModalPresentationPopover;
    functionListVC.preferredContentSize = CGSizeMake(100, income ? 36 * 4 : 36 * 3);
    functionListVC.screenMenuItemSelectedBlock = ^(NSInteger index) {
        weakself.currentScreenIndex = index;
        [weakself.tableView.mj_header beginRefreshing];
    };
    
    UIPopoverPresentationController *popover = functionListVC.popoverPresentationController;
    popover.delegate = self;
    popover.barButtonItem = item;
    popover.backgroundColor = [UIColor whiteColor];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    [self presentViewController:functionListVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark - 配置TableView
- (void)configTableView {
    self.pageNo = 1;
    self.pageSize = 10;
    
    self.tableView.rowHeight = 66;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
    // 设置footer
    self.tableView.mj_footer = footer;
}

#pragma mark -
#pragma mark - 调接口

- (void)loadNewData {
    _pageNo = 1;
    [self getMyExpendRecordList];
}

- (void)loadMoreData {
    _pageNo++;
    [self getMyExpendRecordList];
}

- (void)getMyExpendRecordList {
    NSString *detailType = @"";
    if (_currentScreenIndex == 1) {
        detailType = @"11";
    } else if (_currentScreenIndex == 2) {
        detailType = @"12";
    } else if (_currentScreenIndex == 3) {
        detailType = @"13";
    }
    
    __weak typeof(self) weakself = self;
    [NetworkTool getIncomeOrExpenditureInfoWithType:_type detailType:detailType pageNo:@(_pageNo) pageSize:@(_pageSize) Success:^(id result){
        //NSLog(@"%@",result);
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            MyConsumeModel *model = [MyConsumeModel myConsumeModelWithDict:dict];
            [muArray addObject:model];
        }
        weakself.tableView.mj_footer.hidden = muArray.count < weakself.pageSize;
        if (weakself.pageNo == 1) {
            [weakself.tableView.mj_header endRefreshing];
            weakself.modelArray = muArray;
            [weakself.tableView reloadData];
        } else {
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.modelArray addObjectsFromArray:muArray];
            [weakself.tableView reloadData];
        }
    } failure:^{
        if (weakself.pageNo == 1) {
            [weakself.tableView.mj_header endRefreshing];
        } else {
            [weakself.tableView.mj_footer endRefreshing];
        }
        [SVProgressHUD showErrorWithStatus:@"获取明细失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RechargeRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RechargeRecordViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.income = [_type isEqualToString:@"1"];
    cell.myConsumeModel = self.modelArray[indexPath.row];
    
    return cell;
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
