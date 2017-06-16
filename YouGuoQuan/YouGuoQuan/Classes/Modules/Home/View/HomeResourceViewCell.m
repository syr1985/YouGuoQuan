//
//  HomeResourceViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/10.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "HomeResourceViewCell.h"
#import "HomeResourceModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeResourceViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView; //相册封面
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageNumberButton;

@end

@implementation HomeResourceViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setHomeResourceModel:(HomeResourceModel *)homeResourceModel {
    _homeResourceModel = homeResourceModel;

    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:homeResourceModel.headImg
                                                                   width:_coverImageView.bounds.size.width
                                                                  height:_coverImageView.bounds.size.height];
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                       placeholderImage:[UIImage imageNamed:@"背景封面默认图"]];
    
    _sexImageView.image = [UIImage imageNamed:homeResourceModel.sex];
    
    _userNameLabel.text = homeResourceModel.nickName;
    _cityNameLabel.text = homeResourceModel.city;
    [_imageNumberButton setTitle:[homeResourceModel.imageCount stringValue] forState:UIControlStateNormal];
}


@end
