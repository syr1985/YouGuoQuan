//
//  FocusProductViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/6.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "FocusProductViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomeFocusModel.h"
#import "MoreMenuHelp.h"
#import "NSDate+LXExtension.h"
//#import "PhotoBrowserHelp.h"
#import "UIImage+Color.h"

@interface FocusProductViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UIImageView *auditImageView;

@property (weak, nonatomic) IBOutlet UIImageView *tyrantImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *publishTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewWidthContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tyrantImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexImageViewLeadingConstraint;
@end

@implementation FocusProductViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = 20;
    _headerImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderImageView)];
    [_headerImageView addGestureRecognizer:tapHeader];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popupPhotoBrowser:)];
    [_productImageView addGestureRecognizer:tap];
}

- (void)setHomeFocusModel:(HomeFocusModel *)homeFocusModel {
    _homeFocusModel = homeFocusModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:homeFocusModel.headImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                            placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _nickNameLabel.text = homeFocusModel.nickName;
    _crownImageView.hidden = (homeFocusModel.star != 6);
    _auditImageView.hidden = !(homeFocusModel.audit == 1 || homeFocusModel.audit == 3);
    _auditImageView.image = homeFocusModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    
    _tyrantImageView.image = homeFocusModel.star == 5 ? [UIImage imageNamed:@"壕"] : nil;
    _tyrantImageViewWidthConstraint.constant = homeFocusModel.star == 5 ? 39 : 0;
    _sexImageViewLeadingConstraint.constant = homeFocusModel.star == 5 ? 4 : 0;
    
    _sexImageView.image = [UIImage imageNamed:homeFocusModel.sex];
    
    _vipImageView.image = homeFocusModel.isRecommend ? [UIImage imageNamed:@"VIP"] : nil;
    _vipImageViewWidthContraint.constant = homeFocusModel.isRecommend ? 29 : 0;
    _vipImageViewLeadingConstraint.constant = homeFocusModel.isRecommend ? 4 : 0;
    
    _levelImageView.hidden = homeFocusModel.star == 0;
    if (homeFocusModel.star != 0) {
       _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级 %d",homeFocusModel.star]];
    }
    
    NSTimeInterval timeInterval = [homeFocusModel.createTime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    LXDateItem *item = [[NSDate date] lx_timeIntervalSinceDate:createDate];
    _publishTimeLabel.text = [NSString stringWithFormat:@"%@前",item.description];
    _publishTitleLabel.text = homeFocusModel.goodsName;
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_productImageView.frame.size];
    NSString *productImageUrlStr = [NSString cropImageUrlWithUrlString:homeFocusModel.imageUrl
                                                                 width:_productImageView.bounds.size.width
                                                                height:_productImageView.bounds.size.height];
    [_productImageView sd_setImageWithURL:[NSURL URLWithString:productImageUrlStr]
                             placeholderImage:phImage];
    
    _buyCountLabel.text = [NSString stringWithFormat:@"%@人购买", homeFocusModel.buyCount];
    //_praiseRateLabel.text = [NSString stringWithFormat:@"好评率：%@",homeFocusModel.buyCommentGoodCount];
    //_buyButton.enabled = ![homeFocusModel.userId isEqualToString:[LoginData sharedLoginData].userId];
}

/**
 *  更多按钮点击
 */
- (IBAction)moreButtonClicked {
    __weak typeof(self) weakself = self;
    if ([_homeFocusModel.userId isEqualToString:[LoginData sharedLoginData].userId]) {
        [MoreMenuHelp showMoreMenuForMineTrendsWithResult:^(NSUInteger index) {
            if (weakself.handleTrendsBlock) {
                weakself.handleTrendsBlock(index, weakself.homeFocusModel.focusId, weakself.row);
            }
        }];
    } else {
        [MoreMenuHelp showMoreMenu:^(NSUInteger index) {
            if (weakself.actionSheetItemClicked) {
                weakself.actionSheetItemClicked(index, weakself.homeFocusModel.userId, weakself.homeFocusModel.focusId);
            }
        }];
    }
}

/**
 *  购买商品
 */
- (IBAction)buyProduct:(id)sender {
    if (_buyButtonClickedBlock) {
        _buyButtonClickedBlock(_homeFocusModel);
    }
}

/**
 *  点击头像进TA人主页
 */
- (void)tapHeaderImageView {
    if (_tapHeaderView) {
        _tapHeaderView(_homeFocusModel.userId);
    }
}

/**
 *  打开图片浏览器
 */
- (void)popupPhotoBrowser:(UITapGestureRecognizer *)sender {
    if (_buyButtonClickedBlock) {
        _buyButtonClickedBlock(_homeFocusModel);
    }
//    if (_homeFocusModel.imageUrl && _homeFocusModel.imageUrl.length) {
//        NSArray *urlArray;
//        if ([_homeFocusModel.imageUrl containsString:@";"]) {
//            urlArray = [_homeFocusModel.imageUrl componentsSeparatedByString:@";"];
//        } else {
//            urlArray = @[_homeFocusModel.imageUrl];
//        }
//        [PhotoBrowserHelp openPhotoBrowserWithImages:urlArray currentIndex:0];
//    }
}

@end
