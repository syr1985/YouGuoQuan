//
//  ParticipatenViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/29.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "ParticipatenViewCell.h"
#import "OthersContributerModel.h"
#import <UIImageView+WebCache.h>

@interface ParticipatenViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UIImageView *auditImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tyrantImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contributionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tyrantImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexImageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewLeadingConstraint;

@end

@implementation ParticipatenViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = _headerImageView.frame.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES;
}

- (void)setContributerModel:(OthersContributerModel *)contributerModel {
    _contributerModel = contributerModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:contributerModel.headImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _crownImageView.hidden = contributerModel.star != 6;
    _auditImageView.hidden = !(contributerModel.audit == 1 || contributerModel.audit == 3);
    _auditImageView.image = contributerModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    
    _tyrantImageView.hidden = contributerModel.star != 5;
    _tyrantImageViewWidthConstraint.constant = contributerModel.star == 5 ? 39 : 0;
    _sexImageViewLeadingConstraint.constant = contributerModel.star == 5 ? 4 : 0;
    
    _sexImageView.image = [UIImage imageNamed:contributerModel.sex];
    
    _vipImageView.image = contributerModel.isRecommend ? [UIImage imageNamed:@"VIP"] : nil;
    _vipImageViewWidthConstraint.constant = contributerModel.isRecommend ? 29 : 0;
    _vipImageViewLeadingConstraint.constant = contributerModel.isRecommend ? 4 : 0;
    
    _levelImageView.hidden = contributerModel.star == 0;
    if (contributerModel.star != 0) {
        _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级 %d",contributerModel.star]];
    }
    
    _nickNameLabel.text = contributerModel.nickName;
    _contributionLabel.text = [NSString stringWithFormat:@"贡献 %@ u币",contributerModel.totalMoney];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    
    self.rankingLabel.text = [NSString stringWithFormat:@"NO.%zd",index + 1];
    
    if (index == 0) {
        self.rankingLabel.textColor = [HelperUtil colorWithHexString:@"#FFDB53"];
    } else if (index == 1) {
        self.rankingLabel.textColor = [HelperUtil colorWithHexString:@"#98B5C2"];
    } else if (index == 2) {
        self.rankingLabel.textColor = NavTabBarColor;
    } else {
        self.rankingLabel.textColor = GaryFontColor;
    }
}

@end
