//
//  MyInviteViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/6/14.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "MyInviteViewCell.h"
#import "MyInviteModel.h"
#import <UIImageView+WebCache.h>

@interface MyInviteViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *auditImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *registerAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *registerDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeMoneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelImageViewWidthConstraint;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation MyInviteViewCell

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm分";
    }
    return _dateFormatter;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = _headerImageView.bounds.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES;
}

- (void)setMyInviteModel:(MyInviteModel *)myInviteModel {
    _myInviteModel = myInviteModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:myInviteModel.headImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    _nickNameLabel.text = myInviteModel.nickName;
    
    _auditImageView.hidden = myInviteModel.audit != 1 && myInviteModel.audit != 3;
    _auditImageView.image = myInviteModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    
    _levelImageView.hidden = myInviteModel.star == 0;
    _levelImageViewWidthConstraint.constant = myInviteModel.star == 0 ? 0 : 29;
    if (myInviteModel.star != 0) {
        _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级 %d",myInviteModel.star]];
    }
    
    _registerAccountLabel.text = [NSString stringWithFormat:@"注册账号：%@",myInviteModel.mobile];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:myInviteModel.createTime.doubleValue / 1000];
    _registerDateTimeLabel.text = [NSString stringWithFormat:@"注册时间：%@",[self.dateFormatter stringFromDate:date]];
    
    _incomeMoneyLabel.text = [NSString stringWithFormat:@"+%@",myInviteModel.totalMoney];
}

@end
