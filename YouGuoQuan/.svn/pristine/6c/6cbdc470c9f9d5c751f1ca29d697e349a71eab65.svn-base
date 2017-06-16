//
//  RechargeRecordViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/4/20.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "RechargeRecordViewCell.h"
#import "MyConsumeModel.h"

@interface RechargeRecordViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *recordContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordDateLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation RechargeRecordViewCell

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
        //_dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMyConsumeModel:(MyConsumeModel *)myConsumeModel {
    _myConsumeModel = myConsumeModel;
    
    NSString *orderNo = myConsumeModel.orderNo;
    NSString *content = @"";
    if (_income) {
        if ([orderNo hasPrefix:@"NM"]) {
            content = [NSString stringWithFormat:@"%@ 购买了您的 %@",myConsumeModel.buyerNickName, myConsumeModel.goodsName];
        } else if ([orderNo hasPrefix:@"RP"]) {
            content = [NSString stringWithFormat:@"%@ 看了您的红包照片",myConsumeModel.buyerNickName];
        } else if ([orderNo hasPrefix:@"RE"]) {
            content = [NSString stringWithFormat:@"%@ 打赏了您",myConsumeModel.buyerNickName];
        } else if ([orderNo hasPrefix:@"DT"]) {
            content = [NSString stringWithFormat:@"%@ 约见了您 %@",myConsumeModel.buyerNickName, myConsumeModel.goodsName];
        } else if ([orderNo hasPrefix:@"WX"]) {
            content = [NSString stringWithFormat:@"%@ 购买了您的微信",myConsumeModel.buyerNickName];
        } else if ([orderNo hasPrefix:@"WD"]) {
            content = @"提现";
        } else if ([orderNo hasPrefix:@"PR"]) {
            content = [NSString stringWithFormat:@"您邀请的好友 %@ 推广收入",myConsumeModel.buyerNickName];
        }
    } else {
        if ([orderNo hasPrefix:@"NM"]) {
            content = [NSString stringWithFormat:@"购买了 %@ 的 %@",myConsumeModel.sellerNickName, myConsumeModel.goodsName];
        } else if ([orderNo hasPrefix:@"RP"]) {
            content = [NSString stringWithFormat:@"看了 %@ 的红包照片",myConsumeModel.sellerNickName];
        } else if ([orderNo hasPrefix:@"RE"]) {
            content = [NSString stringWithFormat:@"打赏了 %@",myConsumeModel.sellerNickName];
        } else if ([orderNo hasPrefix:@"DT"]) {
            content = [NSString stringWithFormat:@"%@ 的约见-%@",myConsumeModel.sellerNickName, myConsumeModel.goodsName];
        } else if ([orderNo hasPrefix:@"WX"]) {
            content = [NSString stringWithFormat:@"购买了 %@ 的微信",myConsumeModel.sellerNickName];
        } else if ([orderNo hasPrefix:@"CF"]) {
            content = [NSString stringWithFormat:@"众筹 %@",myConsumeModel.goodsName];
        } else if ([orderNo hasPrefix:@"FW"]) {
            content = @"充值";
        } else {
            content = @"购买尤果会员";
        }
    }
    self.recordContentLabel.text = content;
    
    NSTimeInterval timeInterval = [myConsumeModel.createTime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    self.recordDateLabel.text = [self.dateFormatter stringFromDate:createDate];
    
    if (_income) {
        NSString *sign = [orderNo hasPrefix:@"WD"] ? @"-" : @"+";
        self.recordPriceLabel.text = [NSString stringWithFormat:@"%@%@ u币",sign,myConsumeModel.goodsPrice];
        self.recordPriceLabel.textColor = [orderNo hasPrefix:@"WD"] ? FontColor : GreenColor;
    } else {
        NSString *sign = [orderNo hasPrefix:@"FW"] ? @"+" : @"-";
        self.recordPriceLabel.text = [NSString stringWithFormat:@"%@%@ u币",sign,myConsumeModel.goodsPrice];
        self.recordPriceLabel.textColor = [orderNo hasPrefix:@"FW"] ? GreenColor : FontColor;
    }
}

@end
