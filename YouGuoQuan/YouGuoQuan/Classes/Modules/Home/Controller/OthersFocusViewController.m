//
//  OthersFocusViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/2.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "OthersFocusViewController.h"
#import "UserCenterViewController.h"
#import "OthersFocusViewCell.h"
#import "OthersFocusModel.h"
#import <MJRefresh.h>

@interface OthersFocusViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@end

static NSString * const tableViewCellID_OthersFocus = @"OthersFocusViewCell";

@implementation OthersFocusViewController

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleString = [_userId isEqualToString:[LoginData sharedLoginData].userId] ? @"我的关注" : @"Ta的关注";
    
    self.pageNo = 1;
    self.pageSize = 15;
    self.tableView.rowHeight = 56;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    
    UINib *nib = [UINib nibWithNibName:tableViewCellID_OthersFocus bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:tableViewCellID_OthersFocus];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadNewData)];
    // 设置文字
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置header
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                             refreshingAction:@selector(loadMoreData)];
    // 设置文字
    [footer setTitle:@"上拉刷新数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    //[footer setTitle:@"到底了" forState:MJRefreshStateNoMoreData];
    footer.automaticallyRefresh = NO;
    footer.hidden = YES;
    // 设置footer
    self.tableView.mj_footer = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%s",__func__);
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window) {// 是否是正在使用的视图
            // Add code to preserve data stored in the views that might be
            // needed later.
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.tableView = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

#pragma mark -
#pragma mark - 加载数据
- (void)loadNewData {
    _pageNo = 1;
    [self loadDataFromServer];
}

- (void)loadMoreData {
    _pageNo++;
    [self loadDataFromServer];
}

- (void)loadDataSuccess:(NSArray *)dataArray {
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OthersFocusModel *model = [OthersFocusModel othersFocusModelWithDict:dict];
        [muArray addObject:model];
    }
    self.tableView.mj_footer.hidden = muArray.count < self.pageSize;
    if (_pageNo == 1) {
        [_tableView.mj_header endRefreshing];
        _modelArray = muArray;
        [_tableView reloadData];
    } else {
        [_tableView.mj_footer endRefreshing];
        [_modelArray addObjectsFromArray:muArray];
        [_tableView reloadData];
    }
    _noResultView.hidden = _modelArray.count;
}

- (void)loadDataFailure {
    if (_pageNo == 1) {
        [_tableView.mj_header endRefreshing];
    } else {
        [_tableView.mj_footer endRefreshing];
    }
}

- (void)loadDataFromServer {
    __weak typeof(self) weakself = self;
    if ([_userId isEqualToString:[LoginData sharedLoginData].userId]) {
        //1：关注列表，2：粉丝列表，3：黑名单列表
        [NetworkTool getMyFunsFocusBlackListWithType:@(1) pageNo:@(_pageNo) pageSize:@(_pageSize) success:^(id result) {
            [weakself loadDataSuccess:result];
        } failure:^{
            [weakself loadDataFailure];
        }];
    } else {
        [NetworkTool getOthersFocusListWithPageNo:@(_pageNo) pageSize:@(_pageSize) userID:_userId success:^(id result){
            [weakself loadDataSuccess:result];
        } failure:^{
            [weakself loadDataFailure];
        }];
    }
}

#pragma mark -
#pragma mark - 页面跳转
- (void)popToOtherCenter:(NSString *)userId {
    NSString *loginId = [LoginData sharedLoginData].userId;
    if ([userId isEqualToString:loginId]) {
        self.tabBarController.selectedIndex = 3;
    } else {
        UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
        UserCenterViewController *userCenterVC = [otherSB instantiateViewControllerWithIdentifier:@"UserCenter"];
        userCenterVC.userId = userId;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OthersFocusViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_OthersFocus forIndexPath:indexPath];
    
    // Configure the cell...
    __weak typeof(self) weakself = self;
    cell.tapHeaderImageViewBlock = ^(NSString *userId) {
        [weakself popToOtherCenter:userId];
    };
    
    cell.othersFocusModel = self.modelArray[indexPath.row];
    
    cell.isMyFocus = [_userId isEqualToString:[LoginData sharedLoginData].userId];
    
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