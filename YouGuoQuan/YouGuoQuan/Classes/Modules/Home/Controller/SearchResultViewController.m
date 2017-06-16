//
//  SearchResultViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/21.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "SearchResultViewController.h"
#import "UserCenterViewController.h"
#import "SearchResultViewCell.h"
#import "SearchReaultModel.h"
#import <MJRefresh.h>

@interface SearchResultViewController () <UITableViewDelegate>
@property (weak,     nonatomic) IBOutlet UIView *noResultView;
@property (nonatomic,   strong) NSMutableArray *searchResultArray;
@property (nonatomic,   assign) int pageNo;
@property (nonatomic,   assign) int pageSize;
@end

static NSString * const tableViewCellID_SearchResult = @"SearchResultViewCell";

@implementation SearchResultViewController

- (NSMutableArray *)searchResultArray {
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray new];
    }
    return _searchResultArray;
}

#pragma mark -
#pragma mark - 系统方法
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BackgroundColor;
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回-黑"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(popViewController)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.pageNo = 1;
    self.pageSize = 10;
    
    self.tableView.rowHeight = 56;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadNewData)];
    // 设置文字
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
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
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadNewData {
    _pageNo = 1;
    [self loadDataFromServer];
}

- (void)loadMoreData {
    _pageNo++;
    [self loadDataFromServer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSearchText:(NSString *)searchText {
    _searchText = searchText;
    
    [self loadDataFromServer];
}

- (void)loadDataFromServer {
    __weak typeof(self) weakself = self;
    [NetworkTool searchWithContent:_searchText pageNO:@(_pageNo) pageSize:@(_pageSize) success:^(NSArray *searchResult) {
        [weakself loadDataSuccess:searchResult];
    } failure:^{
        [weakself loadDataFailure];
    }];
}

- (void)loadDataSuccess:(NSArray *)dataArray {
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SearchReaultModel *searchResultModel = [SearchReaultModel searchReaultModelWithDict:dict];
        [muArray addObject:searchResultModel];
    }
    self.tableView.mj_footer.hidden = muArray.count < self.pageSize;
    if (_pageNo == 1) {
        [self.tableView.mj_header endRefreshing];
        self.searchResultArray = muArray;
        [self.tableView reloadData];
    } else {
        [self.tableView.mj_footer endRefreshing];
        [self.searchResultArray addObjectsFromArray:muArray];
        [self.tableView reloadData];
    }
    _noResultView.hidden = self.searchResultArray.count;
}

- (void)loadDataFailure {
    if (_pageNo == 1) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_SearchResult
                                                                 forIndexPath:indexPath];
    // Configure the cell...
    __weak typeof(self) weakself = self;
    cell.loginBlock = ^{
        UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *loginVC = [loginSB instantiateViewControllerWithIdentifier:@"LoginVC"];
        [weakself.navigationController presentViewController:loginVC animated:YES completion:nil];
        return;
    };
    cell.searchResultModel = self.searchResultArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchReaultModel *searchModel = self.searchResultArray[indexPath.row];
    NSString *otherId = searchModel.userId;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end