//
//  CrowdfundingInfoViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/30.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "CrowdfundingInfoViewCell.h"
#import "HomeFocusModel.h"
#import "DiscoveryCrowdfundingModel.h"
#import <UIImageView+WebCache.h>
#import "UIImage+Color.h"

@interface CrowdfundingInfoViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cfImageView;
@property (weak, nonatomic) IBOutlet UILabel *cfTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cfDescLabel;

@end

@implementation CrowdfundingInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHomeFocusModel:(HomeFocusModel *)homeFocusModel {
    _homeFocusModel = homeFocusModel;
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_cfImageView.frame.size];
    [_cfImageView sd_setImageWithURL:[NSURL URLWithString:homeFocusModel.imageUrl]
                    placeholderImage:phImage];
    _cfTitleLabel.text = homeFocusModel.goodsName;
    _cfDescLabel.text = homeFocusModel.instro;
}

- (void)setCrowdfundingModel:(DiscoveryCrowdfundingModel *)crowdfundingModel {
    _crowdfundingModel = crowdfundingModel;
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_cfImageView.frame.size];
    [_cfImageView sd_setImageWithURL:[NSURL URLWithString:crowdfundingModel.coverImgUrl]
                    placeholderImage:phImage];
    _cfTitleLabel.text = crowdfundingModel.cTitle;
    _cfDescLabel.text = crowdfundingModel.descs;
}

@end
