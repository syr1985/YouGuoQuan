//
//  UndoSoldOrderForTrendsViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/19.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "UndoSoldOrderForTrendsViewCell.h"
#import <UIImageView+WebCache.h>
#import "MyOrderModel.h"
#import "UIImage+Color.h"

@interface UndoSoldOrderForTrendsViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIView  *agreeWithRefundView;
@property (weak, nonatomic) IBOutlet UIView  *didhandleOrderView;

@end

@implementation UndoSoldOrderForTrendsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headerImageView.layer.cornerRadius = _headerImageView.bounds.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES;
    
    
    self.agreeWithRefundView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    self.agreeWithRefundView.layer.shadowOffset = CGSizeMake(0, 1);
    self.agreeWithRefundView.layer.shadowOpacity = 0.1;
    
    self.didhandleOrderView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    self.didhandleOrderView.layer.shadowOffset = CGSizeMake(0, 1);
    self.didhandleOrderView.layer.shadowOpacity = 0.1;
    
    self.contentView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
    self.contentView.layer.shadowOpacity = 0.1;
}

- (void)setOrderModel:(MyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:orderModel.buyUserHeadImg
                                                                  width:self.headerImageView.bounds.size.width
                                                                 height:self.headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    _titleLabel.text = orderModel.saleNickName;
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_contentImageView.frame.size];
    NSString *contentImageUrlStr = [NSString compressImageUrlWithUrlString:orderModel.imageUrl
                                                                     width:_contentImageView.bounds.size.width
                                                                    height:_contentImageView.bounds.size.height];
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:contentImageUrlStr]
                         placeholderImage:phImage];
    _contentTitleLabel.text = orderModel.goodsName;
    _contentPriceLabel.text = [NSString stringWithFormat:@"%@ u币",orderModel.price];
    
    _phoneLabel.text = [NSString stringWithFormat:@"电话：%@", orderModel.buyerPhone];
    _emailLabel.text = [NSString stringWithFormat:@"邮箱：%@", orderModel.buyerEmail];
    
    _agreeWithRefundView.hidden = orderModel.orderType != 1;
    
    _didhandleOrderView.hidden = orderModel.payStatus == 1;
}

- (IBAction)sendButtonClicked:(id)sender {
    if (_sendedProductBlock) {
        _sendedProductBlock(_orderModel.orderNo, YES);
    }
}

- (IBAction)agreeWithRefundButtonClicked:(id)sender {
    if (_agreeWithRefundBlock) {
        _agreeWithRefundBlock(_orderModel.orderNo);
    }
}


@end