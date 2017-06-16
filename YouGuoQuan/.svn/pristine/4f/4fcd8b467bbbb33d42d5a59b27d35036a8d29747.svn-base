//
//  ContributerListViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/2/22.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "ContributerListViewController.h"
#import "UserCenterViewController.h"
#import "ParticipatenViewCell.h"
#import "OthersContributerModel.h"
#import <MJRefresh.h>

@interface ContributerListViewController ()
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@end

static NSString * const tableViewCellID_Ranking = @"ParticipatenViewCell";

@implementation ContributerListViewController

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray new];
    }
    return _modelArray;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)configViewController {
    self.pageNo = 1;
    self.pageSize = 10;
    
    self.title = @"贡献榜";
    self.view.backgroundColor = BackgroundColor;
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    self.tableView.rowHeight = 56;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UINib *nib = [UINib nibWithNibName:tableViewCellID_Ranking bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:tableViewCellID_Ranking];
    
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
    //[footer setTitle:@"到底了" forState:MJRefreshStateNoMoreData];
    footer.automaticallyRefresh = NO;
    footer.hidden = YES;
    // 设置footer
    self.tableView.mj_footer = footer;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回-黑"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(popViewController)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTintColor:[UIColor darkTextColor]];
}

- (void)popViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark -
#pragma mark - 从服务器加载数据
- (void)loadDataFromServer {
    __weak typeof(self) weakself = self;
    [NetworkTool getOtherContributerWithPageNo:@(_pageNo) pageSize:@(_pageSize) userID:_userId success:^(id result) {
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            OthersContributerModel *model = [OthersContributerModel othersContributerModelWithDict:dict];
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
    ParticipatenViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_Ranking forIndexPath:indexPath];
    
    // Configure the cell...
    cell.contributerModel = self.modelArray[indexPath.row];
    cell.index = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OthersContributerModel *contributerModel = self.modelArray[indexPath.row];
    NSString *otherId = contributerModel.userId;
    NSString *loginId = [LoginData sharedLoginData].userId;
    if ([otherId isEqualToString:loginId]) {
        self.tabBarController.selectedIndex = 3;
    } else {
        UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
        UserCenterViewController *userCenterVC = [otherSB instantiateViewControllerWithIdentifier:@"UserCenter"];
        userCenterVC.userId = otherId;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}


@end
