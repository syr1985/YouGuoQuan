//
//  WaitingForPayTrendsViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "WaitingForPayTrendsViewCell.h"
#import <UIImageView+WebCache.h>
#import "MyOrderModel.h"
#import "UIImage+Color.h"
#import "UIImage+LXExtension.h"

@interface WaitingForPayTrendsViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation WaitingForPayTrendsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = _headerImageView.bounds.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES; // 导致离屏渲染
    
    self.bottomView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0, 1);
    self.bottomView.layer.shadowOpacity = 0.1;
    
    self.contentView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
    self.contentView.layer.shadowOpacity = 0.1;
}

- (void)setOrderModel:(MyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:orderModel.headImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _titleLabel.text = orderModel.saleNickName;
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_contentImageView.frame.size];
    // RP(红包照片)NM(普通商品)WX(购买微信)CF(众筹)RB(红包)RE(打赏)
    NSString *orderNo = orderModel.orderNo;
    if ([orderNo hasPrefix:@"WX"]) {
        _contentImageView.image = [UIImage imageNamed:@"购买订单-购买微信"];
        _contentTitleLabel.text = @"微信";
    } else if ([orderNo hasPrefix:@"RP"]) {
        NSString *imageUrl = orderModel.imageUrl;
        if ([orderModel.imageUrl containsString:@";"]) {
            imageUrl = [imageUrl componentsSeparatedByString:@";"][0];
        }
        CGFloat imageViewW = _contentImageView.bounds.size.width;
        NSString *rpImageUrlStr = [NSString compressImageUrlWithUrlString:imageUrl
                                                                    width:imageViewW
                                                                   height:imageViewW];
        //        NSString *blurImageUrl = [NSString stringWithFormat:@"%@/imageMogr2/blur/25x20",rpImageUrlStr];
        //        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:rpImageUrlStr]
        //                             placeholderImage:phImage];
        __weak typeof(self) weakself = self;
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:rpImageUrlStr] placeholderImage:phImage options:SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                dispatch_queue_t blurImageDispatchQueue = dispatch_queue_create("cn.newtouch.YouGuoQuan.gcd.BlurImage", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(blurImageDispatchQueue, ^{
                    UIImage *blurImage = [image blurImageWithRadius:imageViewW * 0.5];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.contentImageView.image = blurImage;
                    });
                });
            }
        }];
        _contentTitleLabel.text = @"红包照片";
    } else if ([orderNo hasPrefix:@"RE"]) {
        _contentImageView.image = [UIImage imageNamed:@"我的订单-打赏"];
        _contentTitleLabel.text = @"打赏";
    } else {
        NSString *contentImageUrlStr = [NSString compressImageUrlWithUrlString:orderModel.imageUrl
                                                                         width:_contentImageView.bounds.size.width
                                                                        height:_contentImageView.bounds.size.height];
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:contentImageUrlStr]
                             placeholderImage:phImage];
        _contentTitleLabel.text = orderModel.goodsName;
    }
    _contentPriceLabel.text = [NSString stringWithFormat:@"%@ u币",orderModel.price];
}

/**
 *  继续支付
 */
- (IBAction)goonPayButtonClicked:(id)sender {
    if (_goonPayBolck) {
        _goonPayBolck(_orderModel.orderNo, _orderModel.price, _orderModel.goodsName, @"");
    }
}

/**
 *  取消订单
 */
- (IBAction)cancelOrderButtonClicked:(id)sender {
    if (_cancelOrderBlock) {
        _cancelOrderBlock(_orderModel.orderNo);
    }
}

@end
