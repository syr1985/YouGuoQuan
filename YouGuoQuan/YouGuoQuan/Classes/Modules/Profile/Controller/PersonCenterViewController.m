//
//  PersonCenterViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/3.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "PersonDataViewController.h"
#import "PayForNobilityViewController.h"
#import "OfficiallyCertifiedViewController.h"

#import "UserBaseInfoModel.h"
#import <UIImageView+WebCache.h>

@interface PersonCenterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UIImageView *recommandImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel     *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *certifiedImageView;
@property (weak, nonatomic) IBOutlet UILabel     *certifiedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goldenVipImageView;

@end

static NSString * const KVO_KeyPath_HeadImg  = @"userBaseInfoModel.headImg";
static NSString * const KVO_KeyPath_NickName = @"userBaseInfoModel.nickName";
static NSString * const KVO_KeyPath_Sex      = @"userBaseInfoModel.sex";
static NSString * const KVO_KeyPath_Audit    = @"userBaseInfoModel.audit";
static NSString * const KVO_KeyPath_Nobility = @"userBaseInfoModel.isRecommend";

@implementation PersonCenterViewController

#pragma mark -
#pragma mark - 系统方法
- (void)dealloc {
    NSLog(@"%s",__func__);
    [self removeObserver:self forKeyPath:KVO_KeyPath_HeadImg];
    [self removeObserver:self forKeyPath:KVO_KeyPath_NickName];
    [self removeObserver:self forKeyPath:KVO_KeyPath_Sex];
    [self removeObserver:self forKeyPath:KVO_KeyPath_Audit];
    [self removeObserver:self forKeyPath:KVO_KeyPath_Nobility];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleString = @"个人中心";
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width * 0.5;
    self.headerImageView.layer.masksToBounds = YES;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:_userBaseInfoModel.headImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                            placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    self.nicknameLabel.text = _userBaseInfoModel.nickName;
    self.sexImageView.image = [UIImage imageNamed:_userBaseInfoModel.sex];
 
    self.levelImageView.hidden = _userBaseInfoModel.star == 0;
    if (_userBaseInfoModel.star != 0) {
        self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级 %d",_userBaseInfoModel.star]];
    }
    
    self.crownImageView.hidden = (_userBaseInfoModel.star != 6);
    self.recommandImageView.hidden = (_userBaseInfoModel.audit != 1 && _userBaseInfoModel.audit != 3);
    self.recommandImageView.image  = _userBaseInfoModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    self.goldenVipImageView.hidden = (_userBaseInfoModel.star != 5);
    
    if (_userBaseInfoModel.audit == 2 || _userBaseInfoModel.audit == 4) {
        self.certifiedImageView.image = [UIImage imageNamed:@"官方认证-正在审核"];
        self.certifiedLabel.text = @"正在审核";
        self.certifiedLabel.textColor = NavColor;
    }
    
    [self addObserver:self forKeyPath:KVO_KeyPath_HeadImg   options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:KVO_KeyPath_NickName  options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:KVO_KeyPath_Sex       options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:KVO_KeyPath_Audit     options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:KVO_KeyPath_Nobility  options:NSKeyValueObservingOptionNew context:NULL];
}

/**
 *  KVO
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:KVO_KeyPath_HeadImg]) {
        
        NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:_userBaseInfoModel.headImg
                                                                      width:_headerImageView.bounds.size.width
                                                                     height:_headerImageView.bounds.size.height];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                                placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    } else if ([keyPath isEqualToString:KVO_KeyPath_NickName]) {
        self.nicknameLabel.text = _userBaseInfoModel.nickName;
    } else if ([keyPath isEqualToString:KVO_KeyPath_Sex]) {
        self.sexImageView.image = [UIImage imageNamed:_userBaseInfoModel.sex];
    } else if ([keyPath isEqualToString:KVO_KeyPath_Audit]) {
        self.certifiedImageView.image = [UIImage imageNamed:@"官方认证-正在审核"];
        self.certifiedLabel.text = @"正在审核";
        self.certifiedLabel.textColor = NavColor;
    } else if ([keyPath isEqualToString:KVO_KeyPath_Nobility]) {
        self.crownImageView.hidden = (_userBaseInfoModel.star != 6);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark -
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 113;
    } else {
        return 217;
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    if ([identifier isEqualToString:@"OfficiallyCertifiedSegue"]) {
        if (_userBaseInfoModel.audit == 2 || _userBaseInfoModel.audit == 4) {
            [SVProgressHUD showInfoWithStatus:@"您已提交认证信息，正在审核中"];
        } else if (_userBaseInfoModel.audit == 1 || _userBaseInfoModel.audit == 3) {
            [SVProgressHUD showInfoWithStatus:@"您已是认证用户"];
        }
        return _userBaseInfoModel.audit == 0;
    } else {
        return YES;
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destVC = [segue destinationViewController];
    if ([destVC isKindOfClass:[PersonDataViewController class]]) {
        PersonDataViewController *personDataVC = (PersonDataViewController *)destVC;
        personDataVC.userBaseInfoModel = _userBaseInfoModel;
    } else if ([destVC isKindOfClass:[PayForNobilityViewController class]]) {
        __weak typeof(self) weakself = self;
        PayForNobilityViewController *buyNobilityVC = segue.destinationViewController;
        buyNobilityVC.modifyRecommandBlock = ^{
            weakself.userBaseInfoModel.isRecommend = YES;
        };
    } else if ([destVC isKindOfClass:[OfficiallyCertifiedViewController class]]) {
        OfficiallyCertifiedViewController *offciallyCerifiedVC = (OfficiallyCertifiedViewController *)destVC;
        offciallyCerifiedVC.userBaseInfoModel = _userBaseInfoModel;
    }
}

@end
