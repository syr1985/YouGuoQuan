//
//  NearbyPersonViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/10.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "NearbyPersonViewCell.h"
#import "UserBaseInfoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NearbyPersonViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UIImageView *auditImageView;
@property (weak, nonatomic) IBOutlet UIImageView *goldenVipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *funsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goldenVipImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexImageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewWidthConstraint;


@end

@implementation NearbyPersonViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = _headerImageView.frame.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES;
}

- (void)setNearbyUserModel:(UserBaseInfoModel *)nearbyUserModel {
    _nearbyUserModel = nearbyUserModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:nearbyUserModel.headImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _crownImageView.hidden = nearbyUserModel.star != 6;
    _auditImageView.hidden = (nearbyUserModel.audit != 1 && nearbyUserModel.audit != 3);
    _auditImageView.image = nearbyUserModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    
    _goldenVipImageView.hidden = nearbyUserModel.star != 5;
    _goldenVipImageView.image = nearbyUserModel.star == 5 ? [UIImage imageNamed:@"壕"] : nil;
    _goldenVipImageViewWidthConstraint.constant = nearbyUserModel.star != 5 ? 0 : 39;
    _sexImageViewLeadingConstraint.constant = nearbyUserModel.star != 5 ? 0 : 4;
    
    _sexImageView.image = [UIImage imageNamed:nearbyUserModel.sex];
    
    _vipImageView.image = nearbyUserModel.isRecommend ? [UIImage imageNamed:@"VIP"] : nil;
    _vipImageViewWidthConstraint.constant = nearbyUserModel.isRecommend ? 29 : 0;
    _vipImageViewLeadingConstraint.constant = nearbyUserModel.isRecommend ? 4 : 0;
    
    _levelImageView.hidden = nearbyUserModel.star == 0;
    if (nearbyUserModel.star != 0) {
        _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级 %d",nearbyUserModel.star]];
    }
    
    _nickNameLabel.text = nearbyUserModel.nickName;
    _funsCountLabel.text = [NSString stringWithFormat:@"%@粉丝",nearbyUserModel.fansCount];
    
    CLLocationDegrees latitude = nearbyUserModel.latitude;
    CLLocationDegrees longitude = nearbyUserModel.longitude;
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:_myCoordinate.latitude longitude:_myCoordinate.longitude];
    CLLocationDistance distance = [myLocation distanceFromLocation:userLocation];
    if (distance < 1000) {
        _distanceLabel.text = [NSString stringWithFormat:@"%.0f米以内",distance];
    } else {
        if (distance > 1000000) {
            _distanceLabel.text = @"1000公里以外";
        } else {
            _distanceLabel.text = [NSString stringWithFormat:@"%.0f公里以内",distance / 1000];
        }
    }
}

@end
