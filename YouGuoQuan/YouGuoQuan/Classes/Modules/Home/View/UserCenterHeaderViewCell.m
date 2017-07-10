//
//  UserCenterHeaderViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/3/30.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "UserCenterHeaderViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MoreMenuHelp.h"
#import "UIImage+Color.h"
#import "CityLocation.h"
#import "UserBaseInfoModel.h"
#import "OthersContributerModel.h"
#import "PhotoBrowserHelp.h"

@interface UserCenterHeaderViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView  *headerBackgroundImageView;   // 头像背景
@property (weak, nonatomic) IBOutlet UIImageView  *headerImageView;             // 头像
@property (weak, nonatomic) IBOutlet UIImageView  *crownImageView;              // 皇冠
@property (weak, nonatomic) IBOutlet UIImageView  *recommandImageView;          // 右下角V
@property (weak, nonatomic) IBOutlet UIImageView  *goldenVipImageView;          // 壕

@property (weak, nonatomic) IBOutlet UIScrollView *contributionScrollView;      // 贡献人
@property (weak, nonatomic) IBOutlet UIButton     *contributionButton;          // 贡献数
@property (weak, nonatomic) IBOutlet UIButton     *distanceButton;              // 距离

@property (weak, nonatomic) IBOutlet UILabel      *nickNameLabel;               // 昵称
@property (weak, nonatomic) IBOutlet UIImageView  *sexImageView;                // 性别
@property (weak, nonatomic) IBOutlet UIImageView  *levelImageView;              // 等级
@property (weak, nonatomic) IBOutlet UIImageView  *vipImageView;

@property (weak, nonatomic) IBOutlet UILabel      *indentificationLabel;        // 尤果认证
@property (weak, nonatomic) IBOutlet UILabel      *positiveRateLabel;           // 好评率

@property (weak, nonatomic) IBOutlet UIButton     *concemButton;                // 关注
@property (weak, nonatomic) IBOutlet UIButton     *fansButton;                  // 粉丝
@property (weak, nonatomic) IBOutlet UIButton     *favourButton;                // 赞

@property (weak, nonatomic) IBOutlet UIScrollView *photoWallScrollView;         // 照片墙
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewLeadingConstraint;

@property (nonatomic, strong) NSArray *contributerArray;

@end

@implementation UserCenterHeaderViewCell

- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat cornerRadius = _headerImageView.frame.size.width * 0.5;
    _headerImageView.layer.cornerRadius = cornerRadius;
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerImageView.layer.borderWidth = 2;
    
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHeaderImageView)];
    [_headerImageView addGestureRecognizer:tapHeader];
    
    _contributionScrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContributerView)];
    [_contributionScrollView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pulledBlackList)
                                                 name:kNotification_PullBlackList
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(focusOperator:)
                                                 name:kNotification_FocusOperator
                                               object:nil];
}

- (void)pulledBlackList {
    if (_isMyFocus) {
        NSInteger fansCount = [_userBaseInfoModel.fansCount integerValue] - 1;
        NSString *newCount = [NSString stringWithFormat:@"%zd  粉丝",fansCount];
        [_fansButton setTitle:newCount forState:UIControlStateNormal];
        _userBaseInfoModel.fansCount = [NSString stringWithFormat:@"%zd",fansCount];
    }
}

- (void)focusOperator:(NSNotification *)noti {
    NSDictionary *infoDict = noti.userInfo;
    NSInteger fansCount = [_userBaseInfoModel.fansCount integerValue] - 1;
    if ([infoDict[@"isFocus"] boolValue]) {
        fansCount = [_userBaseInfoModel.fansCount integerValue] + 1;
    }
    NSString *newCount = [NSString stringWithFormat:@"%zd  粉丝",fansCount];
    [_fansButton setTitle:newCount forState:UIControlStateNormal];
    _userBaseInfoModel.fansCount = [NSString stringWithFormat:@"%zd",fansCount];
}

/**
 *  更多按钮点击
 */
- (IBAction)moreButtonClicked {
    [MoreMenuHelp showMoreMenu:^(NSUInteger index) {
        if (_actionSheetItemClicked) {
            _actionSheetItemClicked(index);
        }
    }];
}

/**
 *  分享按钮点击
 */
- (IBAction)shareButtonClicked {
    if (_shareButtonClickedBlock) {
        _shareButtonClickedBlock();
    }
}

/**
 *  点击头像查看个人信息
 */
- (void)tapUserHeaderImageView {
    if (_tapHeaderImageViewBlock) {
        _tapHeaderImageViewBlock(nil);
    }
}

/**
 *  他人关注
 */
- (IBAction)lookOthersConcems {
    if (_concemButtonClickedBlock) {
        _concemButtonClickedBlock();
    }
}

/**
 *  他人粉丝
 */
- (IBAction)lookOthersFuns {
    if (_funsButtonClickedBlock) {
        _funsButtonClickedBlock();
    }
}

/**
 *  他赞过的
 */
- (IBAction)lookOthersFavours {
    if (_favourButtonClickedBlock) {
        _favourButtonClickedBlock();
    }
}

- (void)tapContributerView {
    if (_contributerViewTapedBlock) {
        _contributerViewTapedBlock();
    }
}

- (void)setUserBaseInfoModel:(UserBaseInfoModel *)userBaseInfoModel {
    _userBaseInfoModel = userBaseInfoModel;
    
    [_headerBackgroundImageView sd_setImageWithURL:[NSURL URLWithString:userBaseInfoModel.coverImgUrl]
                                  placeholderImage:[UIImage imageNamed:@"背景封面默认图"]];
    
    NSString *headImageUrlStr = [NSString stringWithFormat:@"%@?imageslim",userBaseInfoModel.headImg];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _crownImageView.hidden = !(userBaseInfoModel.star == 6);
    _recommandImageView.hidden = (userBaseInfoModel.audit != 1 && userBaseInfoModel.audit != 3);
    _recommandImageView.image  = userBaseInfoModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    _goldenVipImageView.hidden = !(userBaseInfoModel.star == 5);
    
    _vipImageViewWidthConstraint.constant = userBaseInfoModel.isRecommend ? 29 : 0;
    _vipImageViewLeadingConstraint.constant = userBaseInfoModel.isRecommend ? 4 : 0;
    _vipImageView.image = userBaseInfoModel.isRecommend ? [UIImage imageNamed:@"VIP"] : nil;
    
    _nickNameLabel.text = userBaseInfoModel.nickName;
    _sexImageView.image = [UIImage imageNamed:userBaseInfoModel.sex];

    _levelImageView.hidden = userBaseInfoModel.star == 0;
    if (userBaseInfoModel.star != 0) {
        _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级 %d", userBaseInfoModel.star]];
    }
    
    if ((userBaseInfoModel.audit == 3 || userBaseInfoModel.audit == 1)) {
        NSString *auditResult = [NSString stringWithFormat:@"尤果认证：%@",userBaseInfoModel.auditResult];
        NSString *rateOfPrise = [NSString stringWithFormat:@"好评率：%@%%",userBaseInfoModel.rateOfPraise];
        _indentificationLabel.text = auditResult;
        _positiveRateLabel.text = rateOfPrise;
        _stackViewTopConstraint.constant = 8;
    } else {
        _indentificationLabel.text = @"";
        _positiveRateLabel.text = @"";
        _stackViewTopConstraint.constant = 0;
    }
    
    NSString *focusCountStr = [NSString stringWithFormat:@"%@  关注",userBaseInfoModel.focusCount];
    long long focusCount = [userBaseInfoModel.focusCount longLongValue];
    if (focusCount > 99999) {
        focusCountStr = [NSString stringWithFormat:@"%zd万  关注", focusCount / 10000];
    }
    NSString *fansCountStr = [NSString stringWithFormat:@"%@  粉丝",userBaseInfoModel.fansCount];
    long long fansCount = [userBaseInfoModel.fansCount longLongValue];
    if (fansCount > 99999) {
        fansCountStr = [NSString stringWithFormat:@"%zd万  粉丝", fansCount / 10000];
    }
    NSString *zanCountStr = [NSString stringWithFormat:@"%@  赞",userBaseInfoModel.zanCount];
    long long zanCount = [userBaseInfoModel.zanCount longLongValue];
    if (zanCount > 99999) {
        zanCountStr = [NSString stringWithFormat:@"%zd万  赞", zanCount / 10000];
    }
    [_concemButton setTitle:focusCountStr forState:UIControlStateNormal];
    [_fansButton setTitle:fansCountStr forState:UIControlStateNormal];
    [_favourButton setTitle:zanCountStr forState:UIControlStateNormal];
    
    CLLocationCoordinate2D myCoordinate = [[CityLocation sharedInstance] getLocationCoordinate];
    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:myCoordinate.latitude longitude:myCoordinate.longitude];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:userBaseInfoModel.latitude longitude:userBaseInfoModel.longitude];
    CLLocationDistance distance = [myLocation distanceFromLocation:location];
    [_distanceButton setTitle:[NSString stringWithFormat:@"%.2fkm",distance / 1000] forState:UIControlStateNormal];
    
    [self getContributerList];
}

#pragma mark - 获取用户贡献榜信息
- (void)getContributerList {
    [NetworkTool getOtherContributerWithPageNo:@1 pageSize:@3 userID:_userBaseInfoModel.userId success:^(id result) {
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            OthersContributerModel *model = [OthersContributerModel othersContributerModelWithDict:dict];
            [muArray addObject:model];
        }
        self.contributerArray = [muArray mutableCopy];
        //[self updateUserBaseInfo];
    } failure:nil];
}


- (void)setPhotoArray:(NSArray *)photoArray {
    _photoArray = photoArray;
    
    if (photoArray.count) {
        _scrollViewTopConstaint.constant = 19;
        _scrollViewHeightConstraint.constant = 90;
        
        NSUInteger photoCount = photoArray.count;
        CGFloat imageViewH = _photoWallScrollView.frame.size.height;
        UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                         size:CGSizeMake(imageViewH, imageViewH)];
        for (NSUInteger i = 0; i < photoCount; i++) {
            CGFloat imageViewX = (imageViewH + 8) * i + 8;
            NSString *imageUrl = photoArray[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            imageView.layer.cornerRadius = 4;
            imageView.layer.masksToBounds = YES;
            imageView.frame = CGRectMake(imageViewX, 0, imageViewH, imageViewH);
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(popupPhotoBrowser:)];
            [imageView addGestureRecognizer:tap];
            
            NSString *imageUrlStr = [NSString cropImageUrlWithUrlString:imageUrl
                                                                  width:imageViewH
                                                                 height:imageViewH];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                         placeholderImage:phImage];
            [_photoWallScrollView addSubview:imageView];
        }
        _photoWallScrollView.contentSize = CGSizeMake((imageViewH + 8) * photoCount + 8, imageViewH);
    } else {
        _scrollViewTopConstaint.constant = 0;
        _scrollViewHeightConstraint.constant = 0;
    }
}

- (void)setContributerArray:(NSArray *)contributerArray {
    _contributerArray = contributerArray;
    
    _contributionButton.hidden = contributerArray.count == 0;
    if (contributerArray.count) {
        OthersContributerModel *firstModel = contributerArray[0];
        [_contributionButton setTitle:firstModel.totalMoney forState:UIControlStateNormal];
        
        NSInteger count = contributerArray.count;
        CGFloat viewH = _contributionScrollView.frame.size.height;
        for (NSInteger index = 0; index < count; index++) {
            OthersContributerModel *model = contributerArray[count - 1 - index];
            CGFloat viewX = (count - 1 - index) * viewH * 0.5;
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = viewH * 0.5;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth = 2;
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            imageView.frame = CGRectMake(viewX, 0, viewH, viewH);
            NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:model.headImg
                                                                          width:viewH
                                                                         height:viewH];
            [imageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                         placeholderImage:[UIImage imageNamed:@"my_head_default"]];
            [_contributionScrollView addSubview:imageView];
        }
    }
}

/**
 *  打开图片浏览器
 */
- (void)popupPhotoBrowser:(UITapGestureRecognizer *)sender {
     UIImageView *tapView = (UIImageView *)sender.view;
    if (_photoArray.count > 0) {
        [PhotoBrowserHelp openPhotoBrowserWithImages:_photoArray sourceImageView:tapView];
    }
}

@end
