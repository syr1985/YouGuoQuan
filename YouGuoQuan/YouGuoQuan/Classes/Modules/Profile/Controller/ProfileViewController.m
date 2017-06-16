//
//  ProfileCenterViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/3.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "ProfileViewController.h"

#import "PersonCenterViewController.h"
#import "OthersFocusViewController.h"
#import "OthersFunsViewController.h"
#import "OthersFavoursViewController.h"
#import "LookPhotosViewController.h"
#import "TrendsDetailViewController.h"
#import "ProductDetailViewController.h"
#import "ShareViewController.h"

#import "PersonCenterViewCell.h"
#import "UserCenterTrendsViewCell.h"
#import "UserCenterVideoViewCell.h"
#import "UserCenterProductViewCell.h"
#import "UserCenterRedEnvelopeViewCell.h"

#import "UserBaseInfoModel.h"
#import "UserCenterModel.h"
#import "HomeFocusModel.h"
#import "PhotoWallModel.h"

#import "AlertViewTool.h"
#import "TakePhotoHelp.h"
#import <MJRefresh.h>
#import "ShareTool.h"
#import "AuthorityTool.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UserBaseInfoModel *userBaseInfoModel;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@end

static NSString * const tableViewCellID_center   = @"PersonCenterViewCell";
static NSString * const tableViewCellID_trends   = @"UserCenterTrendsViewCell";
static NSString * const tableViewCellID_video    = @"UserCenterVideoViewCell";
static NSString * const tableViewCellID_product  = @"UserCenterProductViewCell";
static NSString * const tableViewCellID_envelope = @"UserCenterRedEnvelopeViewCell";

static NSString * const KVO_KeyPath_HeadImg  = @"userBaseInfoModel.headImg";
static NSString * const KVO_KeyPath_NickName = @"userBaseInfoModel.nickName";
static NSString * const KVO_KeyPath_Sex      = @"userBaseInfoModel.sex";

NSString * const kNotification_Logout = @"LogoutNotitfication";

@implementation ProfileViewController

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray new];
    }
    return _modelArray;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray new];
    }
    return _titleArray;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray new];
        [_photoArray addObject:@"发布-添加"];
    }
    return _photoArray;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    }
    return _dateFormatter;
}

#pragma mark -
#pragma mark - 系统方法
- (void)dealloc {
    NSLog(@"%s",__func__);
    [self removeObserver:self forKeyPath:KVO_KeyPath_HeadImg];
    [self removeObserver:self forKeyPath:KVO_KeyPath_NickName];
    [self removeObserver:self forKeyPath:KVO_KeyPath_Sex];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessReloadData:)
                                                 name:kNotification_LoginSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pusblishSuccessReloadData)
                                                 name:kNotification_PublishSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deletePhotoWallImage:)
                                                 name:kNotification_DeletePhotoWallImage
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(buyVipSuccess)
                                                 name:kNotification_BuyVipSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteTrendsSuccess:)
                                                 name:kNotification_DeleteTrendsSuccess
                                               object:nil];
    
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if ([LoginData sharedLoginData].userId) {
        if (!_userBaseInfoModel) {
            [self loadNewData];
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Logout object:nil];
        self.tabBarController.selectedIndex = 0;
    }
}

- (void)loginSuccessReloadData:(NSNotification *)noti {
    BOOL isChangeAccount = [noti.userInfo[@"ChangeAccount"] boolValue];
    if (isChangeAccount) {
        [self loadNewData];
    }
}

- (void)pusblishSuccessReloadData {
    [self.tableView.mj_header beginRefreshing];
}

- (void)didEnterBackground {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayingVideoNotification
                                                        object:nil
                                                      userInfo:@{@"feedsId":@""}];
}

- (void)deletePhotoWallImage:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSInteger index = [userInfo[@"imageIndex"] integerValue];
    [self deletePhotoWallImageWithIndex:index];
}

- (void)buyVipSuccess {
    if (_userBaseInfoModel) {
        _userBaseInfoModel.isRecommend = YES;
        [self updateUserBaseInfo];
    }
}

- (void)deleteTrendsSuccess:(NSNotification *)noti {
    NSString *trendsId = noti.userInfo[@"trendsId"];
    __weak typeof(self) weakself = self;
    [self.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *subArray = (NSArray *)obj;
        for (NSInteger row = 0; row < subArray.count; row++) {
            UserCenterModel *model = subArray[row];
            if ([model.trendsId isEqualToString:trendsId]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row
                                                            inSection:idx + 1];
                [weakself updateLocalData:indexPath];
                *stop = YES;
                break;
            }
        }
    }];
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
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    id oldValue = change[@"old"];
    NSString *newValue = change[@"new"];
    
    if ([oldValue isEqual:[NSNull null]] || ![oldValue isEqualToString:newValue]) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark -
#pragma mark - 配置TableView
- (void)configTableView {
    self.pageNo = 1;
    self.pageSize = 5;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
    
    [self addObserver:self forKeyPath:KVO_KeyPath_HeadImg options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:KVO_KeyPath_NickName options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:KVO_KeyPath_Sex options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

#pragma mark -
#pragma mark - 调接口
- (void)getUserBaseInfo {
    /**
     *  TA的基本信息
     */
    NSString *userId = [LoginData sharedLoginData].userId;
    __weak typeof(self) weakself = self;
    [NetworkTool getOthersInfoWithUserId:userId success:^(id result) {
        //NSLog(@"%@",result);
        weakself.userBaseInfoModel = [UserBaseInfoModel userBaseInfoModelWithDict:result[@"list"]];
        [LoginData sharedLoginData].audit = weakself.userBaseInfoModel.audit;
        [LoginData sharedLoginData].phone = weakself.userBaseInfoModel.mobile;
        
        [weakself updateUserBaseInfo];
    }];
}

- (void)getPhotoWallImage {
    /**
     *  TA的照片墙
     */
    NSString *userId = [LoginData sharedLoginData].userId;
    __weak typeof(self) weakself = self;
    [NetworkTool getOtherPhotosWithUserID:userId success:^(id result) {
        NSRange range = {1, weakself.photoArray.count - 1};
        [weakself.photoArray removeObjectsInRange:range];
        
        for (NSDictionary *dict in result) {
            PhotoWallModel *model = [PhotoWallModel photoWallModelWithDict:dict];
            [weakself.photoArray addObject:model];
        }
        [weakself updateUserBaseInfo];
    }];
}

- (void)loadNewData {
    _pageNo = 1;
    [self getUserBaseInfo];
    [self getPhotoWallImage];
    [self getUserTrendsList];
}

- (void)loadMoreData {
    _pageNo++;
    [self getUserTrendsList];
}
/**
 *  TA发的动态
 */
- (void)getUserTrendsList {
    __weak typeof(self) weakself = self;
    [NetworkTool getOtherTrendsWithPageNo:@(_pageNo) pageSize:@(_pageSize) userID:[LoginData sharedLoginData].userId success:^(id result) {
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
                    [muArray addObject:model];
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
                            [muArray addObject:model];
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
                        [muArray addObject:model];
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

#pragma mark -
#pragma mark - 弹出分享页
- (IBAction)showShareView {
    UIStoryboard *homeSB = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    ShareViewController *shareVC = [homeSB instantiateViewControllerWithIdentifier:@"ShareVC"];
    shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    shareVC.tapShareItem = ^(NSInteger index) {
        [ShareTool shareToPlatformType:index viewController:self];
    };
    [self.tabBarController presentViewController:shareVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark - 跳转到详情页
- (void)popToDetailViewController:(UserCenterModel *)model {
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
    homeFocusModel.timeLineId          = @"";
    homeFocusModel.sex                 = _userBaseInfoModel.sex;
    homeFocusModel.headImg             = _userBaseInfoModel.headImg;
    homeFocusModel.nickName            = _userBaseInfoModel.nickName;
    homeFocusModel.star                = _userBaseInfoModel.star;
    homeFocusModel.isBuy               = NO;
    homeFocusModel.isRecommend         = _userBaseInfoModel.isRecommend;
    homeFocusModel.isDelete            = NO;
    homeFocusModel.praise              = NO;
    homeFocusModel.cellHeight          = model.cellHeight + 48;
    
    if (model.feedsType == 3) {
        UIStoryboard *focusSB = [UIStoryboard storyboardWithName:@"Focus" bundle:nil];
        ProductDetailViewController *productDetailVC = [focusSB instantiateViewControllerWithIdentifier:@"ProductDetailVC"];
        productDetailVC.hidesBottomBarWhenPushed = YES;
        productDetailVC.homeFocusModel = homeFocusModel;
        [self presentViewController:productDetailVC animated:YES completion:nil];
    } else {
        UIStoryboard *focusSB = [UIStoryboard storyboardWithName:@"Focus" bundle:nil];
        TrendsDetailViewController *trendsDetailVC = [focusSB instantiateViewControllerWithIdentifier:@"TrendsDetailVC"];
        trendsDetailVC.hidesBottomBarWhenPushed = YES;
        trendsDetailVC.homeFocusModel = homeFocusModel;
        [self.navigationController pushViewController:trendsDetailVC animated:YES];
    }
}

#pragma mark -
#pragma mark - 置顶动态、删除动态
- (void)handleMyTrendsWithIndex:(NSUInteger)index trendsID:(NSString *)trendsId goodsType:(int)type modelIndex:(NSIndexPath *)indexPath {
    __weak typeof(self) weakself = self;
    if (index == 1) {
        [NetworkTool deleteTrendsWithTrendsID:trendsId success:^{
            [SVProgressHUD showSuccessWithStatus:@"已删除动态"];
            [weakself updateLocalData:indexPath];
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"删除动态失败"];
        }];
    }
}

#pragma mark -
#pragma mark - 更新本地数据
- (void)updateLocalData:(NSIndexPath *)indexPath {
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:self.modelArray[indexPath.section - 1]];
    [dataArray removeObjectAtIndex:indexPath.row];
    if (dataArray.count) {
        [self.modelArray replaceObjectAtIndex:indexPath.section - 1 withObject:dataArray];
    } else {
        [self.modelArray removeObjectAtIndex:indexPath.section - 1];
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - 上传图片、更新数据
- (void)uploadImageWith:(BOOL)isCover images:(NSArray<UIImage *> *)photos {
    __weak typeof(self) weakself = self;
    if (isCover) {
        // 上传背景图片
        UIImage *image = photos[0];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [NetworkTool uploadImage:imageData progress:^(NSString *key, float percent) {
           // [SVProgressHUD showProgress:percent];
        } success:^(NSString *url) {
            //[SVProgressHUD dismiss];
            // 调接口
            [NetworkTool modifyPersonInfoWithType:@"coverImgUrl" value:url success:^{
                [SVProgressHUD showSuccessWithStatus:@"修改背景封面成功"];
                // 刷新
                weakself.userBaseInfoModel.coverImgUrl = url;
                [weakself updateUserBaseInfo];
                [weakself.tableView reloadData];
            } failure:^{
                [SVProgressHUD showErrorWithStatus:@"修改背景封面失败"];
            }];
        } failure:^{
            //[SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }];
    } else {
        // 上传照片墙图片
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSUInteger i = 0 ; i < photos.count; i++) {
            UIImage *image = photos[i];
            NSData *imageData = UIImageJPEGRepresentation(image,0.8);
            [muArray addObject:imageData];
        }
        [NetworkTool uploadImages:muArray progress:^(CGFloat percent) {
            [SVProgressHUD showProgress:percent];
        } success:^(NSArray *urlArray) {
            [SVProgressHUD dismiss];
            // 调接口
            NSMutableString *urlString = [NSMutableString string];
            for (NSString *url in urlArray) {
                [urlString appendString:url];
                [urlString appendString:@";"];
            }
            
            NSUInteger maxRange = NSMaxRange([urlString rangeOfComposedCharacterSequenceAtIndex:urlString.length - 2]);
            NSString *imageUrl = [urlString substringToIndex:maxRange];
            [NetworkTool addPhotosToPhotosWallWithImageUrl:imageUrl success:^{
                [SVProgressHUD showSuccessWithStatus:@"添加照片成功"];
                [weakself getPhotoWallImage];
            } failure:^{
                [SVProgressHUD showErrorWithStatus:@"添加照片失败"];
            }];
        } failure:^{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }];
    }
}

- (void)updateUserBaseInfo {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.tableView beginUpdates];
        [weakself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationNone];
        [weakself.tableView endUpdates];
    });
}

#pragma mark -
#pragma mark - 删除照片墙图片
- (void)deletePhotoWallImageWithIndex:(NSInteger)index {
    PhotoWallModel *model = self.photoArray[index];
    //NSLog(@"%zd,%@",index,model.imageId);

    __weak typeof(self) weakself = self;
    [NetworkTool deleteImageFromPhotoWallWithImageId:model.imageId success:^{
        [SVProgressHUD showSuccessWithStatus:@"删除图片成功"];
        [weakself.photoArray removeObjectAtIndex:index];
        [weakself updateUserBaseInfo];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"删除图片失败"];
    }];
}

#pragma mark -
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [self.modelArray[section - 1] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakself = self;
    if (indexPath.section == 0) {
        PersonCenterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_center forIndexPath:indexPath];
        
        cell.tapHeaderImageViewBlock = ^{
            UIStoryboard *profileSB = [UIStoryboard storyboardWithName:@"Center" bundle:nil];
            if ([LoginData sharedLoginData].ope) {
                PersonCenterViewController *personCenterVC = [profileSB instantiateInitialViewController];
                personCenterVC.userBaseInfoModel = weakself.userBaseInfoModel;
                personCenterVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:personCenterVC animated:YES];
            } else {
                PersonCenterViewController *personCenterVC = [profileSB instantiateViewControllerWithIdentifier:@"PersonCenterVC"];
                personCenterVC.userBaseInfoModel = weakself.userBaseInfoModel;
                personCenterVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:personCenterVC animated:YES];
            }
        };
        
        cell.tapBackgroundImageViewBlock = ^{
            [[TakePhotoHelp sharedInstance] showActionSheetWithTitle:@"更换背景封面" viewController:weakself returnBlock:^(BOOL isCover, NSArray<UIImage *> *photos) {
                if (photos.count) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ModifyImage
//                                                                        object:nil
//                                                                      userInfo:@{@"photos"  : photos,
//                                                                                 @"isCover" : @(isCover)}];
                    [weakself uploadImageWith:isCover images:photos];
                }
            }];
        };
        
        cell.concemButtonClickedBlock = ^{
            UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
            OthersFocusViewController *othersFocusVC = [otherSB instantiateViewControllerWithIdentifier:@"OthersFocus"];
            othersFocusVC.userId = [LoginData sharedLoginData].userId;
            othersFocusVC.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:othersFocusVC animated:YES];
        };
        
        cell.funsButtonClickedBlock = ^{
            UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
            OthersFunsViewController *othersFunsVC = [otherSB instantiateViewControllerWithIdentifier:@"OthersFuns"];
            othersFunsVC.userId = [LoginData sharedLoginData].userId;
            othersFunsVC.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:othersFunsVC animated:YES];
        };
        
        cell.favourButtonClickedBlock = ^{
            UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
            OthersFavoursViewController *othersFavoursVC = [otherSB instantiateViewControllerWithIdentifier:@"OthersFavours"];
            othersFavoursVC.userId = [LoginData sharedLoginData].userId;
            othersFavoursVC.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:othersFavoursVC animated:YES];
        };
        
        cell.selectPhotoBlock = ^{
            [[TakePhotoHelp sharedInstance] showActionSheetWithTitle:@"添加照片" viewController:weakself returnBlock:^(BOOL isCover, NSArray<UIImage *> *photos) {
                if (photos.count != 0) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ModifyImage
//                                                                        object:nil
//                                                                      userInfo:@{@"photos"  : photos,
//                                                                                 @"isCover" : @(isCover)}];
                    [weakself uploadImageWith:isCover images:photos];
                }
            }];
        };
        
        cell.sellWeixinBlock = ^{
            UIStoryboard *publishSB = [UIStoryboard storyboardWithName:@"Publish" bundle:nil];
            UINavigationController *sellWeixinVC = [publishSB instantiateViewControllerWithIdentifier:@"PublishWeixin"];
            [weakself presentViewController:sellWeixinVC animated:YES completion:nil];
        };
        
        cell.publishRedpackstBlock = ^{
            UIStoryboard *publishSB = [UIStoryboard storyboardWithName:@"Publish" bundle:nil];
            UINavigationController *publishRedVC = [publishSB instantiateViewControllerWithIdentifier:@"PublishRedEnvelope"];
            [weakself presentViewController:publishRedVC animated:YES completion:nil];
        };
        
        cell.deleteImageBlock = ^(NSInteger index) {
            [weakself deletePhotoWallImageWithIndex:index];
        };
        
        cell.publishDeniedBlock = ^{
            [AuthorityTool publishPermissionDeniedFromViewController:self];
        };
        
        cell.photoArray = self.photoArray;
        
        if (_userBaseInfoModel) {
            cell.userBaseInfoModel = _userBaseInfoModel;
        }
        
        return cell;
    } else {
        UserCenterModel *model = self.modelArray[indexPath.section - 1][indexPath.row];
        if (model.feedsType == 1) {
            UserCenterTrendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_trends forIndexPath:indexPath];
            cell.commentBlock = ^(UserCenterModel *userCenterModel) {
                [weakself popToDetailViewController:userCenterModel];
            };
            cell.actionSheetItemClicked = ^(NSUInteger index, NSString *trendsId, int goodsType, NSIndexPath *indexPath) {
                [weakself handleMyTrendsWithIndex:index trendsID:trendsId goodsType:goodsType modelIndex:indexPath];
            };
            cell.userCenterModel = model;
            cell.indexPath = indexPath;
            return cell;
        } else if (model.feedsType == 2) {
            UserCenterVideoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_video forIndexPath:indexPath];
            cell.commentBlock = ^(UserCenterModel *userCenterModel) {
                [weakself popToDetailViewController:userCenterModel];
            };
            cell.actionSheetItemClicked = ^(NSUInteger index, NSString *trendsId, int goodsType, NSIndexPath *indexPath) {
                [weakself handleMyTrendsWithIndex:index trendsID:trendsId goodsType:goodsType modelIndex:indexPath];
            };
            cell.userCenterModel = model;
            cell.indexPath = indexPath;
            return cell;
        } else if (model.feedsType == 3) {
            UserCenterProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_product forIndexPath:indexPath];
            cell.actionSheetItemClicked = ^(NSUInteger index, NSString *trendsId, int goodsType, NSIndexPath *indexPath) {
                [weakself handleMyTrendsWithIndex:index trendsID:trendsId goodsType:goodsType modelIndex:indexPath];
            };
            cell.buyButtonClickedBlock = ^(UserCenterModel *userCenterModel) {
                [weakself popToDetailViewController:userCenterModel];
            };
            cell.userCenterModel = model;
            cell.indexPath = indexPath;
            return cell;
        } else {
            UserCenterRedEnvelopeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_envelope forIndexPath:indexPath];
            cell.commentBlock = ^(UserCenterModel *userCenterModel) {
                [weakself popToDetailViewController:userCenterModel];
            };
            cell.actionSheetItemClicked = ^(NSInteger index, NSString *trendsId, int goodsType, NSIndexPath *indexPath) {
                [weakself handleMyTrendsWithIndex:index trendsID:trendsId goodsType:goodsType modelIndex:indexPath];
            };
            cell.userCenterModel = model;
            cell.indexPath = indexPath;
            return cell;
        }
    }
}

#pragma mark -
#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([LoginData sharedLoginData].ope) {
            if (_userBaseInfoModel) {
                if (_userBaseInfoModel.audit == 1 || _userBaseInfoModel.audit == 3) {
                    return WIDTH * 46 / 75 + 257 + 56;
                } else {
                    return WIDTH * 46 / 75 + 257 + 32;
                }
            }
            return WIDTH * 46 / 75 + 257 + 56;
        } else {
            return WIDTH * 46 / 75 + 257 + 30;
        }
    } else {
        UserCenterModel *model = self.modelArray[indexPath.section - 1][indexPath.row];
        return model.cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section != 0) {
        if ([cell isKindOfClass:[UserCenterVideoViewCell class]]) {
            UserCenterVideoViewCell *videoCell = (UserCenterVideoViewCell *)cell;
            [videoCell releaseWMPlayer];
        }
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12)];
    footerView.backgroundColor = BackgroundColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[UserCenterVideoViewCell class]]) {
        UserCenterVideoViewCell *videoCell = (UserCenterVideoViewCell *)cell;
        [videoCell stopWMPlayer];
    }
    // 跳详情页
    if (indexPath.section != 0) {
        UserCenterModel *userCenterModel = self.modelArray[indexPath.section - 1][indexPath.row];
        [self popToDetailViewController:userCenterModel];
    }
}

@end
