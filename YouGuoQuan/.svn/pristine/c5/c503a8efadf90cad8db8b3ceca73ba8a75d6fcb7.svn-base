//
//  UndoSoldOrderForWeixinViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "UndoSoldOrderForWeiXinViewCell.h"
#import <UIImageView+WebCache.h>
#import "MyOrderModel.h"

@interface UndoSoldOrderForWeiXinViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIView *agreeWithRefundView;
@property (weak, nonatomic) IBOutlet UIView *didHandleOrderView;
@end

@implementation UndoSoldOrderForWeiXinViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headerImageView.layer.cornerRadius = _headerImageView.bounds.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES; // 导致离屏渲染
    
    self.agreeWithRefundView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    self.agreeWithRefundView.layer.shadowOffset = CGSizeMake(0, 1);
    self.agreeWithRefundView.layer.shadowOpacity = 0.1;
    
    self.didHandleOrderView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    self.didHandleOrderView.layer.shadowOffset = CGSizeMake(0, 1);
    self.didHandleOrderView.layer.shadowOpacity = 0.1;
    
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
    _titleLabel.text = [NSString stringWithFormat:@"%@ 购买了您的微信", orderModel.buyUserNickName];
    
    _contentPriceLabel.text = [NSString stringWithFormat:@"%@ u币",orderModel.price];
    _accountLabel.text = [NSString stringWithFormat:@"微信：%@", orderModel.buyerDesc];
    
    _agreeWithRefundView.hidden = orderModel.orderType != 1;
    
    _didHandleOrderView.hidden = orderModel.payStatus == 1;
}

- (IBAction)refuseAddWeiXinAccount:(id)sender {
    if (_operateOrderBlock) {
        _operateOrderBlock(_orderModel.orderNo, NO);
    }
}

- (IBAction)addedWeiXinAccount:(id)sender {
    if (_operateOrderBlock) {
        _operateOrderBlock(_orderModel.orderNo, YES);
    }
}

- (IBAction)agreeWithRefundButtonClicked:(id)sender {
    if (_agreeWithRefundBlock) {
        _agreeWithRefundBlock(_orderModel.orderNo);
    }
}


@end
