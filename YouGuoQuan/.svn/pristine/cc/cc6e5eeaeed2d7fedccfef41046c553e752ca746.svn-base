//
//  DoneSoldOrderForMeetingViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "DoneSoldOrderForMeetingViewCell.h"
#import <UIImageView+WebCache.h>
#import "MyOrderModel.h"
#import "UIImage+Color.h"

@interface DoneSoldOrderForMeetingViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation DoneSoldOrderForMeetingViewCell

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
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:orderModel.buyUserHeadImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    if ([orderModel.orderNo hasPrefix:@"NM"]) {
        _titleLabel.text = [NSString stringWithFormat:@"%@ 购买了您的 %@", orderModel.buyUserNickName, orderModel.goodsName];
        
        UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                         size:_contentImageView.frame.size];
        
        NSString *contentImageUrlStr = [NSString compressImageUrlWithUrlString:orderModel.imageUrl
                                                                         width:_contentImageView.bounds.size.width
                                                                        height:_contentImageView.bounds.size.height];
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:contentImageUrlStr]
                             placeholderImage:phImage];
        _contentTitleLabel.text = orderModel.goodsName;
        _contentPriceLabel.text = [NSString stringWithFormat:@"%@ u币",orderModel.price];
        
        _dateLabel.text = [NSString stringWithFormat:@"电话：%@", orderModel.buyerPhone];
        _addressLabel.text = [NSString stringWithFormat:@"邮箱：%@", orderModel.buyerEmail];
    } else {
        _titleLabel.text = [NSString stringWithFormat:@"%@ 对您发起了约见请求", orderModel.buyUserNickName];
        
        _contentImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"购买订单-约见-%@",orderModel.goodsName]];
        _contentTitleLabel.text = [NSString stringWithFormat:@"约见-%@",orderModel.goodsName];
        _contentPriceLabel.text = [NSString stringWithFormat:@"%@ u币",orderModel.price];
        
        _dateLabel.text = [NSString stringWithFormat:@"日期：%@", orderModel.dateTimeInfo];
        _addressLabel.text = [NSString stringWithFormat:@"地址：%@", orderModel.dateAddress];
    }
}

- (IBAction)deleteOrderButtonClicked:(id)sender {
    if (_deleteOrderBlock) {
        _deleteOrderBlock(_orderModel.orderNo);
    }
}

@end
