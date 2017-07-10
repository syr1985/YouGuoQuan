//
//  UserCenterViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/21.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "UserCenterViewController.h"

#import "OthersInfoViewController.h"
#import "ReportViewController.h"
#import "OthersFocusViewController.h"
#import "OthersFunsViewController.h"
#import "OthersFavoursViewController.h"
#import "LookPhotosViewController.h"
#import "ContributerListViewController.h"
#import "ShareViewController.h"

#import "TrendsDetailViewController.h"
#import "ProductDetailViewController.h"
#import "BuyWeiXinViewController.h"
#import "RewardViewController.h"
#import "ChatViewController.h"

#import "UserCenterHeaderViewCell.h"
#import "UserCenterTrendsViewCell.h"
#import "UserCenterVideoViewCell.h"
#import "UserCenterProductViewCell.h"
#import "UserCenterRedEnvelopeViewCell.h"

#import "UserBaseInfoModel.h"
#import "UserCenterModel.h"
#import "HomeFocusModel.h"
#import "EaseConversationModel.h"
#import "OthersContributerModel.h"

#import <MJRefresh.h>
#import "ShareTool.h"
#import "AlertViewTool.h"
#import "AuthorityTool.h"
#import "PayTool.h"

@interface UserCenterViewController ()
@property (nonatomic, strong) UserBaseInfoModel *userBaseInfoModel;
@property (nonatomic, assign, setter=setFocusButtonStatus:) BOOL isFocus;       // 自己是否关注Ta
@property (nonatomic, assign, setter=setChatButtonStatus:)  BOOL isPullBlack;   // Ta是否拉黑自己
@property (nonatomic, assign, setter=setSellButtonStatus:)  BOOL isSellWX;      // Ta是否出售微信
@property (nonatomic, assign, setter=setBuyWXButtonStatus:) int  hasBuyWX;      // 是否购买过Ta的微信
@property (nonatomic, assign) BOOL isReward; // 是否打赏过Ta
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *photoArray;
//@property (nonatomic, strong) NSMutableArray *contrArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic,   copy) NSString *wxPrice; // Ta发布的微信价格
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

static NSString * const tableViewCellID_trends   = @"UserCenterTrendsViewCell";
static NSString * const tableViewCellID_video    = @"UserCenterVideoViewCell";
static NSString * const tableViewCellID_product  = @"UserCenterProductViewCell";
static NSString * const tableViewCellID_envelope = @"UserCenterRedEnvelopeViewCell";

@implementation UserCenterViewController

#pragma mark - 懒加载
#pragma mark - 动态模型数组
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray new];
    }
    return _modelArray;
}
#pragma mark - 动态分组标题（日期）数组
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray new];
    }
    return _titleArray;
}
#pragma mark - 用户的照片墙数组
- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray new];
    }
    return _photoArray;
}
//#pragma mark - 用户的贡献榜数组（只需3条）
//- (NSMutableArray *)contrArray {
//    if (!_contrArray) {
//        _contrArray = [NSMutableArray new];
//    }
//    return _contrArray;
//}
#pragma mark - dateFormatter 防止重复创建（创建时速度慢性能较差）
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    }
    return _dateFormatter;
}

#pragma mark - 系统方法
#pragma mark - VC销毁
- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - VC已加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessReloadData:)
                                                 name:kNotification_LoginSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [self configNavigation];
    
    [self configTableView];
}
#pragma mark - VC即将显示
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if ([LoginData sharedLoginData].userId) {
        if (!self.modelArray.count) {
            [self loadNewData];
        }
    } else {
        [self dismissViewController];
    }
}
#pragma mark - VC接受到内存警告
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

#pragma mark - 登录成功后如果更新用户则重新加载数据
- (void)loginSuccessReloadData:(NSNotification *)noti {
    BOOL isChangeAccount = [noti.userInfo[@"ChangeAccount"] boolValue];
    if (isChangeAccount) {
        [self loadNewData];
    }
}
#pragma mark - 处理app进入后台后停止播放视频
- (void)didEnterBackground {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayingVideoNotification
                                                        object:nil
                                                      userInfo:@{@"feedsId":@""}];
}

#pragma mark -
#pragma mark - 返回按钮事件
- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - 配置导航栏
- (void)configNavigation {
    NSArray *titles = @[@"聊天", @"关注", @"打赏", @"微信私聊"];
    NSArray *images = @[@"聊天", @"+", @"打赏", @"微信"];
    NSArray *withs  = @[@50, @60, @50, @80];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSUInteger i = 0; i < titles.count; i++) {
        CGFloat btnW = [withs[i] floatValue];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 8, btnW, 28);
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        
        btn.adjustsImageWhenHighlighted = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        // add sel
        switch (i) {
            case 3:
                btn.hidden = ![LoginData sharedLoginData].ope;
                [btn setBackgroundImage:[UIImage imageNamed:@"禁用button"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(buyWeixin:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                btn.hidden = ![LoginData sharedLoginData].ope;
                [btn setBackgroundImage:[UIImage imageNamed:@"黄色Button"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(rewardUser) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                [btn setBackgroundImage:[UIImage imageNamed:@"黄色Button"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(concemUser) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 0:
                [btn setBackgroundImage:[UIImage imageNamed:@"禁用button"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(chatToUser) forControlEvents:UIControlEventTouchUpInside];
                break;
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    self.navigationItem.rightBarButtonItems = items;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回-黑"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(dismissViewController)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationController.navigationBar.tintColor = [UIColor darkTextColor];
}

#pragma mark -
#pragma mark - 配置TableView
- (void)configTableView {
    self.pageNo = 1;
    self.pageSize = 5;
    
    self.tableView.backgroundColor = BackgroundColor;
    
    UINib *nib_trends = [UINib nibWithNibName:tableViewCellID_trends bundle:nil];
    [self.tableView registerNib:nib_trends forCellReuseIdentifier:tableViewCellID_trends];
    
    UINib *nib_video  = [UINib nibWithNibName:tableViewCellID_video bundle:nil];
    [self.tableView registerNib:nib_video forCellReuseIdentifier:tableViewCellID_video];
    
    UINib *nib_product = [UINib nibWithNibName:tableViewCellID_product bundle:nil];
    [self.tableView registerNib:nib_product forCellReuseIdentifier:tableViewCellID_product];
    
    UINib *nib_envelope = [UINib nibWithNibName:tableViewCellID_envelope bundle:nil];
    [self.tableView registerNib:nib_envelope forCellReuseIdentifier:tableViewCellID_envelope];
    
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
    //[header beginRefreshing];
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

#pragma mark - 调接口
#pragma mark - 获取用户基本信息
- (void)getUserBaseInfo {
    [NetworkTool getOthersInfoWithUserId:_userId success:^(id result) {
        //NSLog(@"%@",result);
        self.isFocus     = [result[@"isFocus"] boolValue];
        self.isPullBlack = [result[@"isPullBlack"] boolValue];
        self.isSellWX    = [result[@"isSellWX"] boolValue];
        self.wxPrice     = result[@"wxPrice"];
        self.isReward    = [result[@"isReward"] boolValue];
        self.hasBuyWX    = [result[@"haveBuyHisWx"] intValue];
        self.userBaseInfoModel = [UserBaseInfoModel userBaseInfoModelWithDict:result[@"list"]];
        [self updateUserBaseInfo];
    }];
}

#pragma mark - 刷新用户信息
- (void)updateUserBaseInfo {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.tableView beginUpdates];
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [weakself.tableView endUpdates];
    });
}

#pragma mark - 下拉刷新加载用户发布的动态数据
- (void)loadNewData {
    _pageNo = 1;
    [self getUserBaseInfo];
    [self getPhotoWallImages];
    [self getUserTrendsList];
}
#pragma mark - 上拉继续加载用户发布的动态数据
- (void)loadMoreData {
    _pageNo++;
    [self getUserTrendsList];
}

#pragma mark - 获取用户照片墙信息
- (void)getPhotoWallImages {
    [NetworkTool getOtherPhotosWithUserID:_userId success:^(id result) {
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            [muArray addObject:dict[@"imageUrl"]];
        }
        self.photoArray = [muArray mutableCopy];
        [self updateUserBaseInfo];
    }];
}

#pragma mark - 加载用户发布的动态数据
- (void)getUserTrendsList {
    __weak typeof(self) weakself = self;
    [NetworkTool getOtherTrendsWithPageNo:@(_pageNo) pageSize:@(_pageSize) userID:_userId success:^(id result) {
        NSArray *dateArray = [result valueForKey:@"dateString"];
        NSSet *dateSet = [NSSet setWithArray:dateArray];
        
        NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]];
        NSArray *sortSetArray = [dateSet sortedArrayUsingDescriptors:sortDesc];
        
        if (weakself.pageNo == 1) {
            __block NSUInteger totalCount = 0;
            __block NSMutableArray *resultArray = [NSMutableArray array];
            __block NSMutableArray *titleArray = [NSMutableArray array];
            [sortSetArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [titleArray addObject:obj];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateString == %@",obj];
                NSArray *newArray = [result filteredArrayUsingPredicate:predicate];
                totalCount += newArray.count;
                NSMutableArray *muArray = [NSMutableArray array];
                for (NSDictionary *dict in newArray) {
                    UserCenterModel *model = [UserCenterModel userCenterModelWithDict:dict];
                    if (![LoginData sharedLoginData].ope) {
                        if (model.feedsType != 3) {
                            [muArray addObject:model];
                        }
                    } else {
                        [muArray addObject:model];
                    }
                }
                [resultArray addObject:muArray];
            }];
            weakself.titleArray = titleArray;
            weakself.modelArray = resultArray;
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
            weakself.tableView.mj_footer.hidden = resultArray.count == 0;
            if (totalCount < weakself.pageSize) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakself.tableView.mj_footer resetNoMoreData];
            }
        } else {
            __block NSUInteger totalCount = 0;
            __block NSMutableArray *resultArray = weakself.modelArray;
            __block NSMutableArray *titlesArray = weakself.titleArray;
            [sortSetArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([titlesArray containsObject:obj]) {
                    NSInteger index = [titlesArray indexOfObject:obj];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateString == %@",obj];
                    NSArray *newArray = [result filteredArrayUsingPredicate:predicate];
                    totalCount += newArray.count;
                    if (index >= 0 && index < resultArray.count) {
                        NSMutableArray *muArray = [NSMutableArray arrayWithArray:resultArray[index]];
                        for (NSDictionary *dict in newArray) {
                            UserCenterModel *model = [UserCenterModel userCenterModelWithDict:dict];
                            if (![LoginData sharedLoginData].ope) {
                                if (model.feedsType != 3) {
                                    [muArray addObject:model];
                                }
                            } else {
                                [muArray addObject:model];
                            }
                        }
                        [resultArray replaceObjectAtIndex:index withObject:muArray];
                    }
                } else {
                    [titlesArray addObject:obj];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateString == %@",obj];
                    NSArray *newArray = [result filteredArrayUsingPredicate:predicate];
                    totalCount += newArray.count;
                    NSMutableArray *muArray = [NSMutableArray array];
                    for (NSDictionary *dict in newArray) {
                        UserCenterModel *model = [UserCenterModel userCenterModelWithDict:dict];
                        if (![LoginData sharedLoginData].ope) {
                            if (model.feedsType != 3) {
                                [muArray addObject:model];
                            }
                        } else {
                            [muArray addObject:model];
                        }
                    }
                    [resultArray addObject:muArray];
                }
            }];
            weakself.titleArray = titlesArray;
            weakself.modelArray = resultArray;
            [weakself.tableView reloadData];
            if (totalCount < weakself.pageSize) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakself.tableView.mj_footer endRefreshing];
            }
        }
    } failure:^{
        if (weakself.pageNo == 1) {
            [weakself.tableView.mj_header endRefreshing];
        } else {
            [weakself.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 根据数据设置控件状态
#pragma mark - 设置关注按钮状态
- (void)setFocusButtonStatus:(BOOL)isFocus {
    _isFocus = isFocus;
    
    NSArray *items = self.navigationItem.rightBarButtonItems;
    UIBarButtonItem *item = items[1];
    UIButton *btn = item.customView;
    //btn.selected = isFocus;
    if (isFocus) {
        [btn setTitle:@"已关注" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"禁用button"] forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"关注" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"黄色Button"] forState:UIControlStateNormal];
    }
}
#pragma mark - 设置聊天按钮状态
- (void)setChatButtonStatus:(BOOL)isPullBlack {
    _isPullBlack = isPullBlack;
    
    NSArray *items = self.navigationItem.rightBarButtonItems;
    UIBarButtonItem *item = items[0];
    UIButton *btn = item.customView;
    //btn.selected = isPullBlack;
    btn.enabled  = !isPullBlack;
    if (isPullBlack) {
        [btn setBackgroundImage:[UIImage imageNamed:@"禁用button"] forState:UIControlStateNormal];
    } else {
        [btn setBackgroundImage:[UIImage imageNamed:@"黄色Button"] forState:UIControlStateNormal];
    }
}
#pragma mark - 根据Ta是否发布微信设置微信私聊按钮状态
- (void)setSellButtonStatus:(BOOL)isSellWX {
    _isSellWX = isSellWX;
 
    [self setButtonSelectStatus:isSellWX];
}
#pragma mark - 根据是否购买过微信设置微信私聊按钮状态
- (void)setBuyWXButtonStatus:(int)hasBuyWX {
    _hasBuyWX = hasBuyWX;
    // 0 添加中 1 已添加 2 可以购买 3 退款中 4 拒绝添加
    if (_isSellWX) {
        [self setButtonSelectStatus:(hasBuyWX == 2 || hasBuyWX == 4)];
    }
}
#pragma mark - 设置微信私聊按钮状态
- (void)setButtonSelectStatus:(BOOL)selected  {
    NSArray *items = self.navigationItem.rightBarButtonItems;
    UIBarButtonItem *item = items[3];
    UIButton *btn = item.customView;
    //btn.enabled = isSellWX;
    // 这边没用enable 是因为如果用enable，会出现当设置为NO时，点击这个按钮会触发旁边的返回按钮
    // 上面的问题可以用其他方法解决--设置leftBarItem时加一层view,解决触发区域问题
    btn.selected = selected;
    if (selected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"黄色Button"] forState:UIControlStateNormal];
    } else {
        [btn setBackgroundImage:[UIImage imageNamed:@"禁用button"] forState:UIControlStateNormal];
    }
}

#pragma mark - 页面跳转
#pragma mark - 导航按钮方法
#pragma mark - 跳购买微信界面
- (void)buyWeixin:(UIButton *)btn {
    if (!_isSellWX) {
        [SVProgressHUD showInfoWithStatus:@"Ta未发布微信号"];
        return;
    }
    
    if (_hasBuyWX == 0 || _hasBuyWX == 3) {
        [SVProgressHUD showInfoWithStatus:@"Ta正在添加微信中，请耐心等待"];
        return;
    }
    
    if (_hasBuyWX == 1) {
        [SVProgressHUD showInfoWithStatus:@"Ta已成功添加您的微信，无需再次添加"];
        return;
    }
    
    __weak typeof(self) weakself = self;
    UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
    BuyWeiXinViewController *buyWXVC = [otherSB instantiateViewControllerWithIdentifier:@"BuyWeiXin"];
    buyWXVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    buyWXVC.price = _wxPrice;
    buyWXVC.salerID = _userBaseInfoModel.userId;
    buyWXVC.payWeiXinSucess = ^{
        weakself.hasBuyWX = 0;
    };
    [self presentViewController:buyWXVC animated:YES completion:nil];
}
#pragma mark - 跳打赏界面
- (void)rewardUser {
    UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
    RewardViewController *rewardVC = [otherSB instantiateViewControllerWithIdentifier:@"Reward"];
    rewardVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    rewardVC.userID  = _userId;
    rewardVC.rType   = @"ds";
    rewardVC.payForReward = ^(NSNumber *amount, NSString *payType, NSString *orderNo) {
        NSString *message = [NSString stringWithFormat:@"本次消费您需支付%@ u币，确定支付？",amount];
        [AlertViewTool showAlertViewWithTitle:nil Message:message cancelTitle:@"取消" sureTitle:@"零钱支付" sureBlock:^{
            [self payByWalletWithOrderNo:orderNo payMethod:payType];
        } cancelBlock:^{
            
        }];
    };
    [self presentViewController:rewardVC animated:YES completion:nil];
}

- (void)payByWalletWithOrderNo:(NSString *)orderNo payMethod:(NSString *)payType {
    [NetworkTool payForRewardWithOrderNo:orderNo success:^{
        [SVProgressHUD showSuccessWithStatus:@"打赏成功"];
        self.isReward = YES;
    } failure:^(NSError *error, NSString *msg){
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        } else if ([msg isEqualToString:@"金额不足"]) {
            [PayTool payFailureTranslateToRechargeVC:self rechargeSuccess:^{
                [self payByWalletWithOrderNo:orderNo payMethod:payType];
            } rechargeFailure:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"打赏失败"];
        }
    }];
}

#pragma mark - 关注与取消关注操作
- (void)concemUser {
    __weak typeof(self) weakself = self;
    if (weakself.isFocus) {
        [AlertViewTool showAlertViewWithTitle:nil Message:@"是否取消关注？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
            // 取消关注
            [NetworkTool doOperationWithType:@"1" userId:weakself.userBaseInfoModel.userId operationType:@"0" success:^{
                [SVProgressHUD showSuccessWithStatus:@"已取消关注Ta"];
                weakself.isFocus = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_FocusOperator
                                                                    object:nil
                                                                  userInfo:@{@"isFocus":@(NO)}];
            }];
        } cancelBlock:nil];
    } else {
        // 关注
        [NetworkTool doOperationWithType:@"1" userId:weakself.userBaseInfoModel.userId operationType:@"1" success:^{
            [SVProgressHUD showSuccessWithStatus:@"已关注Ta"];
            weakself.isFocus = YES;
            weakself.isPullBlack = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_FocusOperator
                                                                object:nil
                                                              userInfo:@{@"isFocus":@(YES)}];
        }];
    }
}
#pragma mark - 跳聊天界面
- (void)chatToUser {
    if (_userBaseInfoModel) {
        if ([LoginData sharedLoginData].audit == 1 ||
            [LoginData sharedLoginData].audit == 3 ||
            [LoginData sharedLoginData].isRecommend ||
            [LoginData sharedLoginData].star > 1 ||
            _isReward) {
            [self pushToChatViewController];
        } else {
            [AuthorityTool chatPermissionDeniedFromViewController:self returnBlock:^{
                [self rewardUser];
            }];
        }
    } else {
        __weak typeof(self) weakself = self;
        [NetworkTool getOthersInfoWithUserId:_userId success:^(id result) {
            weakself.isFocus     = [result[@"isFocus"] boolValue];
            weakself.isPullBlack = [result[@"isPullBlack"] boolValue];
            weakself.isSellWX    = [result[@"isSellWX"] boolValue];
            weakself.wxPrice     = result[@"wxPrice"];
            weakself.isReward    = [result[@"isReward"] boolValue];
            weakself.userBaseInfoModel = [UserBaseInfoModel userBaseInfoModelWithDict:result[@"list"]];
            [weakself chatToUser];
        }];
    }
}

#pragma mark - cell按钮方法
#pragma mark - 跳官方认证界面
- (void)pushToOfficiallyCertifiedViewController {
    UIStoryboard *centerSB = [UIStoryboard storyboardWithName:@"Center" bundle:nil];
    UIViewController *ocVC = [centerSB instantiateViewControllerWithIdentifier:@"OfficiallyCertifiedVC"];
    ocVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ocVC animated:YES];
}
#pragma mark - 跳聊天界面
- (void)pushToChatViewController {
    NSDictionary *infoDict = @{@"userId"   : _userBaseInfoModel.userId,
                               @"nickName" : _userBaseInfoModel.nickName,
                               @"headImg"  : _userBaseInfoModel.headImg,
                               @"star"     : @(_userBaseInfoModel.star),
                               @"sex"      : _userBaseInfoModel.sex,
                               @"vip"      : @(_userBaseInfoModel.audit),
                               @"nobility" : @(_userBaseInfoModel.star == 6),
                               @"isReward" : @(_isReward)};
    
    NSString *conversionId = [NSString stringWithFormat:@"nt%@",_userBaseInfoModel.mobile];
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversionId
                                                                                        userInfo:infoDict];
    chatController.titleString = _userBaseInfoModel.nickName;
    [self.navigationController pushViewController:chatController animated:YES];
}
#pragma mark - 跳详情页
- (void)popToDetailViewController:(UserCenterModel *)model {
    if (model.feedsType == 3) {
        UIStoryboard *focusSB = [UIStoryboard storyboardWithName:@"Focus" bundle:nil];
        ProductDetailViewController *productDetailVC = [focusSB instantiateViewControllerWithIdentifier:@"ProductDetailVC"];
        productDetailVC.hidesBottomBarWhenPushed = YES;
        productDetailVC.homeFocusModel = [self UserFocusModelToHomeCenterModel:model];
        [self presentViewController:productDetailVC animated:YES completion:nil];
    } else {
        UIStoryboard *focusSB = [UIStoryboard storyboardWithName:@"Focus" bundle:nil];
        TrendsDetailViewController *trendsDetailVC = [focusSB instantiateViewControllerWithIdentifier:@"TrendsDetailVC"];
        trendsDetailVC.hidesBottomBarWhenPushed = YES;
        trendsDetailVC.homeFocusModel = [self UserFocusModelToHomeCenterModel:model];
        [self.navigationController pushViewController:trendsDetailVC animated:YES];
    }
}
#pragma mark - 跳购买红包页
- (void)popToBuyPacketViewController:(NSInteger)price goodsID:(NSString *)goodsId feedsID:(NSString *)feedsId {
    UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
    LookPhotosViewController *buyRedPacketVC = [otherSB instantiateViewControllerWithIdentifier:@"BuyRedEnvelope"];
    buyRedPacketVC.headImg  = _userBaseInfoModel.headImg;
    buyRedPacketVC.nickName = _userBaseInfoModel.nickName;
    buyRedPacketVC.price    = price;
    buyRedPacketVC.goodsId  = goodsId;
    buyRedPacketVC.feedsId  = feedsId;
    buyRedPacketVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:buyRedPacketVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark - 数据模型转换
- (HomeFocusModel *)UserFocusModelToHomeCenterModel:(UserCenterModel *)model {
    HomeFocusModel *homeFocusModel = [[HomeFocusModel alloc] init];
    homeFocusModel.focusId             = model.trendsId;
    homeFocusModel.goodsId             = model.goodsId;
    homeFocusModel.userId              = model.userId;
    homeFocusModel.imageUrl            = model.imageUrl;
    homeFocusModel.buyCount            = model.buyCount;
    homeFocusModel.commentCount        = model.commentCount;
    homeFocusModel.recommendCount      = model.recommendCount;
    homeFocusModel.buyCommentGoodCount = model.buyCommentGoodCount;
    homeFocusModel.instro              = model.instro;
    homeFocusModel.createTime          = model.createTime;
    homeFocusModel.updateTime          = model.updateTime;
    homeFocusModel.playTimes           = model.playTimes;
    homeFocusModel.videoUrl            = model.videoUrl;
    homeFocusModel.videoEvelope        = model.videoEvelope;
    homeFocusModel.feedsType           = model.feedsType;
    homeFocusModel.price               = model.price;
    homeFocusModel.isBuy               = model.isBuy;
    homeFocusModel.isDelete            = model.isDelete;
    homeFocusModel.praise              = model.praise;
    homeFocusModel.goodsName           = model.goodsName;
    homeFocusModel.instro              = model.instro;
    homeFocusModel.timeLineId          = @"";
    homeFocusModel.sex                 = _userBaseInfoModel.sex;
    homeFocusModel.headImg             = _userBaseInfoModel.headImg;
    homeFocusModel.nickName            = _userBaseInfoModel.nickName;
    homeFocusModel.star                = _userBaseInfoModel.star;
    homeFocusModel.isRecommend         = _userBaseInfoModel.isRecommend;
    homeFocusModel.cellHeight          = model.cellHeight + 49;
    return homeFocusModel;
}

#pragma mark -
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? [self.modelArray[section - 1] count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        UserCenterModel *model = self.modelArray[indexPath.section - 1][indexPath.row];
        __weak typeof(self) weakself = self;
        if (model.feedsType == 1) {
            UserCenterTrendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_trends forIndexPath:indexPath];
            cell.commentBlock = ^(UserCenterModel *userCenterModel) {
                [weakself popToDetailViewController:userCenterModel];
            };
            cell.userCenterModel = model;
            return cell;
        } else if (model.feedsType == 2) {
            UserCenterVideoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_video forIndexPath:indexPath];
            cell.commentBlock = ^(UserCenterModel *userCenterModel) {
                [weakself popToDetailViewController:userCenterModel];
            };
            cell.userCenterModel = model;
            return cell;
        } else if (model.feedsType == 3) {
            UserCenterProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_product forIndexPath:indexPath];
            cell.buyButtonClickedBlock = ^(UserCenterModel *userCenterModel) {
                [weakself popToDetailViewController:userCenterModel];
                //[weakself popToBuyProductViewController:userCenterModel];
            };
            cell.userCenterModel = model;
            return cell;
        } else {
            UserCenterRedEnvelopeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_envelope forIndexPath:indexPath];
            cell.buyRedPacketBlock =  ^(NSInteger price, NSString *goodsId, NSString *feedsId) {
                [weakself popToBuyPacketViewController:price goodsID:goodsId feedsID:feedsId];
            };
            cell.commentBlock = ^(UserCenterModel *userCenterModel) {
                [weakself popToDetailViewController:userCenterModel];
            };
            cell.userCenterModel = model;
            return cell;
        }
    } else {
        UserCenterHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterHeaderViewCell" forIndexPath:indexPath];
        __weak typeof(self) weakself = self;
        cell.tapHeaderImageViewBlock = ^(id userData) {
            UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
            OthersInfoViewController *userInfoVC = [otherSB instantiateViewControllerWithIdentifier:@"UserInfo"];
            userInfoVC.userBaseInfoModel = weakself.userBaseInfoModel;
            [weakself.navigationController pushViewController:userInfoVC animated:YES];
        };
        
        cell.actionSheetItemClicked = ^(NSUInteger buttonIndex) {
            if (buttonIndex == 1) {
                // 拉黑警告
                [AlertViewTool showAlertViewWithTitle:nil Message:@"拉黑对方后，对方将无法与您聊天，您也无法查看对方动态，是否继续？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
                    // 拉黑操作
                    [NetworkTool doOperationWithType:@"3" userId:weakself.userBaseInfoModel.userId operationType:@"1" success:^{
                        [SVProgressHUD showSuccessWithStatus:@"已将对方拉黑"];
                        weakself.isPullBlack = YES;
                        weakself.isFocus = NO;
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_PullBlackList object:nil];
                    }];
                } cancelBlock:nil];
            } else if (buttonIndex == 2) {
                // 举报操作
                UIStoryboard *discoverySB = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
                ReportViewController *reportVC = [discoverySB instantiateViewControllerWithIdentifier:@"Report"];
                reportVC.aboutId = weakself.userBaseInfoModel.userId;
                reportVC.reportType = ReportType_Person;
                reportVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [weakself presentViewController:reportVC animated:YES completion:nil];
            }
        };
        
        cell.shareButtonClickedBlock = ^{
            UIStoryboard *homeSB = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            ShareViewController *shareVC = [homeSB instantiateViewControllerWithIdentifier:@"ShareVC"];
            shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            shareVC.tapShareItem = ^(NSInteger index) {
                [ShareTool shareToPlatformType:index viewController:self];
            };
            [self presentViewController:shareVC animated:YES completion:nil];
        };
        
        cell.concemButtonClickedBlock = ^{
            UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
            OthersFocusViewController *othersFocusVC = [otherSB instantiateViewControllerWithIdentifier:@"OthersFocus"];
            othersFocusVC.userId = weakself.userId;
            [weakself.navigationController pushViewController:othersFocusVC animated:YES];
        };
        
        cell.funsButtonClickedBlock = ^{
            UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
            OthersFunsViewController *othersFunsVC = [otherSB instantiateViewControllerWithIdentifier:@"OthersFuns"];
            othersFunsVC.userId = weakself.userId;
            [weakself.navigationController pushViewController:othersFunsVC animated:YES];
        };
        
        cell.favourButtonClickedBlock = ^{
            UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
            OthersFavoursViewController *othersFavoursVC = [otherSB instantiateViewControllerWithIdentifier:@"OthersFavours"];
            othersFavoursVC.userId = weakself.userId;
            [weakself.navigationController pushViewController:othersFavoursVC animated:YES];
        };
        
        cell.contributerViewTapedBlock = ^{
            ContributerListViewController *contributerListVC = [[ContributerListViewController alloc] init];
            contributerListVC.userId = weakself.userId;
            [weakself.navigationController pushViewController:contributerListVC animated:YES];
        };
        
        cell.isMyFocus = _isFocus;
        if (_userBaseInfoModel) {
            cell.userBaseInfoModel = _userBaseInfoModel;
        }
        
        cell.photoArray = self.photoArray;
        return cell;
    }
}

#pragma mark -
#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        UserCenterModel *model = self.modelArray[indexPath.section - 1][indexPath.row];
        return model.cellHeight;
    } else {
        CGFloat headerH = WIDTH * 230 / 375 + 268;
        if (_userBaseInfoModel) {
            if (!_userBaseInfoModel.auditResult.length) {
                headerH -= 24;
            }
        }
        if (!self.photoArray.count) {
            headerH -= 109;
        }
        return headerH;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([cell isKindOfClass:[UserCenterVideoViewCell class]]) {
        UserCenterVideoViewCell *videoCell = (UserCenterVideoViewCell *)cell;
        [videoCell releaseWMPlayer];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 36)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 36, 0, 36, 36)];
    //    topImageView.image = [UIImage imageNamed:@"置顶"];
    //    topImageView.hidden = section != 0;
    //    [headerView addSubview:topImageView];
    
    self.dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *oldDate = [self.dateFormatter dateFromString:self.titleArray[section - 1]];
    self.dateFormatter.dateFormat = @"yyyy.MM.dd";
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 100, 21)];
    dateLabel.textColor = FontColor;
    dateLabel.font = [UIFont systemFontOfSize:17];
    dateLabel.text = [self.dateFormatter stringFromDate:oldDate];
    [headerView addSubview:dateLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section ? 36 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12)];
    footerView.backgroundColor = BackgroundColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[UserCenterVideoViewCell class]]) {
            UserCenterVideoViewCell *videoCell = (UserCenterVideoViewCell *)cell;
            [videoCell stopWMPlayer];
        }
        // 跳详情页
        UserCenterModel *userCenterModel = self.modelArray[indexPath.section - 1][indexPath.row];
        [self popToDetailViewController:userCenterModel];
    }
}

@end
