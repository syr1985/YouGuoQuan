//
//  MyInviteViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/5.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "MyInviteViewController.h"
#import <MJRefresh.h>
#import <Masonry.h>
#import "MyInviteModel.h"
#import "MyInviteViewCell.h"

@interface MyInviteViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic,   copy) NSString *incomeMoney;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;

@end

@implementation MyInviteViewController

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray new];
    }
    return _modelArray;
}

- (void)setIncomeMoney:(NSString *)incomeMoney {
    _incomeMoney = incomeMoney;
    
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"绿色bg"]];
    [headerView addSubview:backgroundImageView];
    
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top);
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"累计总收入（u币）";
    titleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).with.offset(35);
        make.left.equalTo(headerView.mas_left).with.offset(30);
    }];
    
    NSMutableString *muString = [NSMutableString stringWithString:incomeMoney];
    if (incomeMoney.length > 3) {
        for (NSInteger i = incomeMoney.length - 3; i > 0; i -= 3) {
            [muString insertString:@"," atIndex:i];
        }
    }
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = [muString copy];
    moneyLabel.font = [UIFont systemFontOfSize:48 weight:UIFontWeightLight];
    moneyLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:moneyLabel];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15);
        make.left.equalTo(headerView.mas_left).with.offset(30);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"我的推广";
    
    [self configTableView];
}

#pragma mark -
#pragma mark - 配置TableView
- (void)configTableView {
    self.pageNo = 1;
    self.pageSize = 10;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.rowHeight = 78;
    self.tableView.backgroundColor = BackgroundColor;
    
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

- (void)loadNewData {
    _pageNo = 1;
    [self getMyPromotionIncomeInfo];
}

- (void)loadMoreData {
    _pageNo++;
    [self getMyPromotionIncomeInfo];
}

- (void)getMyPromotionIncomeInfo {
    [NetworkTool getMyPromotionIncomeInfoSuccess:^(id result) {
        //NSLog(@"%@",result);
        self.incomeMoney = [result[@"incomeMoney"] stringValue];
        NSArray *dataArray = result[@"list"];
        NSMutableArray *muArray = [NSMutableArray new];
        for (NSDictionary *dict in dataArray) {
            MyInviteModel *model = [MyInviteModel myInviteModelWithDict:dict];
            [muArray addObject:model];
        }
        self.tableView.mj_footer.hidden = muArray.count < self.pageSize;
        if (self.pageNo == 1) {
            [self.tableView.mj_header endRefreshing];
            self.modelArray = muArray;
            [self.tableView reloadData];
        } else {
            [self.tableView.mj_footer endRefreshing];
            [self.modelArray addObjectsFromArray:muArray];
            [self.tableView reloadData];
        }
        self.noResultView.hidden = self.modelArray.count;
    } failure:^{
        if (self.pageNo == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyInviteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInviteViewCell" forIndexPath:indexPath];

    // Configure the cell...
    cell.myInviteModel = self.modelArray[indexPath.row];

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
