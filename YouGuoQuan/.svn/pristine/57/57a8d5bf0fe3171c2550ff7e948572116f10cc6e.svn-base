//
//  SearchViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/3/29.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"

#import "HotSearchViewCell.h"
#import "SearchHistoryViewCell.h"

#import <Masonry.h>
#import "UISearchBar+LeftPlaceholder.h"

#define PYSearchHistoriesPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYRexentSearchs.plist"]

@interface SearchViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SearchResultViewController *searchResultVC;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *hotSearchArray;
@property (nonatomic, strong) NSMutableArray *historySearchArray;
@end

@implementation SearchViewController

- (NSArray *)hotSearchArray {
    if (!_hotSearchArray) {
        _hotSearchArray = [NSArray array];
    }
    return _hotSearchArray;
}

- (NSMutableArray *)historySearchArray {
    if (!_historySearchArray) {
        NSArray *histories = [NSKeyedUnarchiver unarchiveObjectWithFile:PYSearchHistoriesPath];
        if (!histories) {
            _historySearchArray = [NSMutableArray array];
        } else {
            NSUInteger length = histories.count;
            if (length > 6) {
                length = 6;
            }
            NSRange range = {0, length};
            _historySearchArray = [NSMutableArray arrayWithArray:[histories subarrayWithRange:range]];
        }
        
    }
    return _historySearchArray;
}

- (SearchResultViewController *)searchResultVC {
    if (!_searchResultVC) {
        UIStoryboard *homeSB = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        _searchResultVC = [homeSB instantiateViewControllerWithIdentifier:@"SearchResult"];
    }
    return _searchResultVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 8, 32)];
    searchBar.placeholder = @"热搜：Miumiu";
    searchBar.backgroundColor = [HelperUtil colorWithHexString:@"#F8F8F8"];
    searchBar.delegate = self;
    [searchBar changeLeftPlaceholder:searchBar.placeholder];
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
    
    [self setupRightBarItem:@"取消" Sel:(@selector(cancelDidClick))];
    
    [self getHotSeacheWords];
}

- (void)setupRightBarItem:(NSString *)title Sel:(SEL)sel {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:sel];//@selector(cancelDidClick)
    [self.navigationItem.rightBarButtonItem setTintColor:NavTabBarColor];
}

/** 点击清空历史按钮 */
- (void)emptyButtonDidClick {
    // 移除所有历史搜索
    [self.historySearchArray removeAllObjects];
    // 移除数据缓存
    [NSKeyedArchiver archiveRootObject:self.historySearchArray toFile:PYSearchHistoriesPath];
    
    [self.tableView reloadData];
}

/** 点击取消 */
- (void)cancelDidClick {
    // dismiss ViewController
    [self dismissViewControllerAnimated:NO completion:nil];
}

/**
 *  搜索按钮点击
 */
- (void)searchItemClicked {
    [self searchBarSearchButtonClicked:self.searchBar];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchResultVC.view.hidden = YES;
    self.tableView.hidden = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 回收键盘
    [searchBar resignFirstResponder];
    // 先移除再刷新
    NSMutableArray *histories = self.historySearchArray;
    [histories removeObject:searchBar.text];
    [histories insertObject:searchBar.text atIndex:0];
    
    NSUInteger length = histories.count;
    if (length > 6) {
        length = 6;
    }
    NSRange range = {0, length};
    self.historySearchArray = [NSMutableArray arrayWithArray:[histories subarrayWithRange:range]];
    
    // 刷新数据
    [self.tableView reloadData];
    
    // 保存搜索信息
    [NSKeyedArchiver archiveRootObject:self.historySearchArray toFile:PYSearchHistoriesPath];
    
    // 处理搜索结果
    self.tableView.hidden = YES;
    
    [self.view addSubview:self.searchResultVC.view];
    [self addChildViewController:self.searchResultVC];
    self.searchResultVC.view.hidden = NO;
    self.searchResultVC.searchText = searchBar.text;
    
    /**
     *  由于修改了rightitem
     */
    [self setupRightBarItem:@"取消" Sel:(@selector(cancelDidClick))];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 1) {
        [self setupRightBarItem:@"搜索" Sel:(@selector(searchItemClicked))];
    } else if (searchBar.text.length == 0) {
        [self setupRightBarItem:@"取消" Sel:(@selector(cancelDidClick))];
    }
}

#pragma mark -
#pragma mark - 获取热搜关键词
- (void)getHotSeacheWords {
    __weak typeof(self) weakself = self;
    [NetworkTool getHotSearchWords:@(1) pageSize:@(6) success:^(NSArray *hotWords) {
        weakself.hotSearchArray = hotWords;
        [weakself.tableView reloadData];
    } failure:nil];
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
        return self.hotSearchArray.count ? 1 : 0;
    } else {
        return self.historySearchArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HotSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotSearchViewCell" forIndexPath:indexPath];
        
        // Configure the cell...
        __weak typeof(self) weakself = self;
        cell.hotSearchSelectedBlock = ^(NSString *search) {
            weakself.searchBar.text = search;
            [weakself searchBarSearchButtonClicked:weakself.searchBar];
        };
        cell.hotSearch = self.hotSearchArray;
        return cell;
    } else {
        SearchHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryViewCell" forIndexPath:indexPath];
        
        // Configure the cell...
        cell.searchContent = self.historySearchArray[indexPath.row];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSInteger count = self.hotSearchArray.count;
        NSInteger lines = (count % 3 == 0) ? (count / 3) : (count / 3 + 1);
        CGFloat rowH = lines * 30 + (lines + 1) * 12;
        return rowH;
    } else {
        return 56;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 23)];
    headerView.backgroundColor = TextFieldBorderColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, WIDTH - 20, 23)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [HelperUtil colorWithHexString:@"#858585"];
    label.text = section == 0 ? @"热门搜索" : @"最近搜索";
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.hotSearchArray.count ? 23 : 0;
    } else {
        return self.historySearchArray.count ? 23 : 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 58)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIButton *emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emptyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [emptyButton setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    [emptyButton setTitleColor:NavTabBarColor forState:UIControlStateNormal];
    [emptyButton setImage:[UIImage imageNamed:@"清空-点击"] forState:UIControlStateNormal];
    [emptyButton addTarget:self action:@selector(emptyButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:emptyButton];
    
    [emptyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView.mas_centerX);
        make.centerY.equalTo(footerView.mas_centerY);
    }];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return self.historySearchArray.count ? 58 : 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.searchBar.text = self.historySearchArray[indexPath.row];
    [self searchBarSearchButtonClicked:self.searchBar];
}

@end
