//
//  WaitingForPayTrendsViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "OngoingForPayTrendsViewCell.h"
#import <UIImageView+WebCache.h>
#import "MyOrderModel.h"
#import "UIImage+Color.h"

@interface OngoingForPayTrendsViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *surePayBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation OngoingForPayTrendsViewCell

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = _headerImageView.bounds.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES; // 导致离屏渲染
    
    _bottomView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0, 1);
    _bottomView.layer.shadowOpacity = 0.1;
    
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
    
    // RP(红包照片)NM(普通商品)WX(购买微信)CF(众筹)RB(红包)RE(打赏)
    NSString *orderNo = orderModel.orderNo;
    if ([orderNo hasPrefix:@"WX"]) {
        _contentImageView.image = [UIImage imageNamed:@"购买订单-购买微信"];
        _contentTitleLabel.text = @"微信";
    } else {
        UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                         size:_contentImageView.frame.size];
        NSString *contentImageUrlStr = [NSString compressImageUrlWithUrlString:orderModel.imageUrl
                                                                         width:_contentImageView.bounds.size.width
                                                                        height:_contentImageView.bounds.size.height];
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:contentImageUrlStr]
                             placeholderImage:phImage];
        _contentTitleLabel.text = orderModel.goodsName;
    }
    _contentPriceLabel.text = [NSString stringWithFormat:@"%@ u币",orderModel.price];
    
    if (orderModel.orderType == 3) {
        [_surePayBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        [_surePayBtn removeTarget:self action:@selector(sureToPayment) forControlEvents:UIControlEventTouchUpInside];
        [_surePayBtn addTarget:self action:@selector(applyForRefund) forControlEvents:UIControlEventTouchUpInside];
        
        if ([orderNo hasPrefix:@"WX"]) {
            NSTimeInterval timeInterval = [orderModel.createTime longLongValue];
            timeInterval /= 1000;
            NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:createDate];
            //NSLog(@"%@-%@-%f",orderModel.createTime,createDate,interval);
            if (interval < 48 * 60 * 60) {
                _surePayBtn.enabled = NO;
                [_surePayBtn setBackgroundImage:[UIImage imageNamed:@"禁用button"] forState:UIControlStateNormal];
            } else {
                _surePayBtn.enabled = YES;
                [_surePayBtn setBackgroundImage:[UIImage imageNamed:@"黄色Button"] forState:UIControlStateNormal];
            }
        }
    } else if (orderModel.orderType == 4) {
        [_surePayBtn setTitle:@"确认付款" forState:UIControlStateNormal];
        [_surePayBtn removeTarget:self action:@selector(applyForRefund) forControlEvents:UIControlEventTouchUpInside];
        [_surePayBtn addTarget:self action:@selector(sureToPayment) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)sureToPayment {
    if (_surePayBlock) {
        _surePayBlock(_orderModel.orderNo);
    }
}

- (void)applyForRefund {
    if (_applyForRefundBlock) {
        _applyForRefundBlock(_orderModel.orderNo);
    }
}

@end
