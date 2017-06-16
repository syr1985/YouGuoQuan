//
//  CrowdfundingDetailViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/29.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "CrowdfundingDetailViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Color.h"

@interface CrowdfundingDetailViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@end

@implementation CrowdfundingDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_bannerImageView.frame.size];
    [_bannerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                        placeholderImage:phImage];
}

@end
