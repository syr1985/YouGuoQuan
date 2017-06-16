//
//  FollowMessageCell.m
//  YouGuoQuan
//
//  Created by liushuai on 16/12/10.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "FollowMessageCell.h"
#import "OthersFocusModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+LXExtension.h"
#import "AlertViewTool.h"

@interface FollowMessageCell()
@property(nonatomic, weak) IBOutlet UIImageView *headImgView;
@property(nonatomic, weak) IBOutlet UIImageView *vipImgView;
@property(nonatomic, weak) IBOutlet UIImageView *crownImgView;
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property(nonatomic, weak) IBOutlet UILabel *timeLabel;
@property(nonatomic, weak) IBOutlet UIButton *followBtn;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation FollowMessageCell

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
//        _dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日";
    }
    return _dateFormatter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImgView.layer.cornerRadius = _headImgView.bounds.size.height * 0.5;
    _headImgView.layer.masksToBounds = YES;
    
    _headImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapHeaderImageView)];
    [_headImgView addGestureRecognizer:tap];
}

- (void)tapHeaderImageView {
    if (_tapHeaderImageViewBlock) {
        _tapHeaderImageViewBlock(_otherFocusModel.userId);
    }
}

- (IBAction)followBtnClicked:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    if (sender.isSelected) {
        [AlertViewTool showAlertViewWithTitle:nil Message:@"是否取消关注？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
            // 取消关注
            [NetworkTool doOperationWithType:@"1" userId:weakself.otherFocusModel.userId operationType:@"0" success:^{
                [SVProgressHUD showSuccessWithStatus:@"已取消关注Ta"];
                sender.selected = NO;
                weakself.otherFocusModel.isMyFans = NO;
            }];
        } cancelBlock:nil];
    } else {
        // 关注
        [NetworkTool doOperationWithType:@"1" userId:weakself.otherFocusModel.userId operationType:@"1" success:^{
            [SVProgressHUD showSuccessWithStatus:@"已关注Ta"];
            sender.selected = YES;
            weakself.otherFocusModel.isMyFans = YES;
        }];
    }
}

- (void)setOtherFocusModel:(OthersFocusModel *)otherFocusModel {
    _otherFocusModel = otherFocusModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:otherFocusModel.headImg
                                                                  width:_headImgView.bounds.size.width
                                                                 height:_headImgView.bounds.size.height];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                    placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _vipImgView.hidden = otherFocusModel.audit != 1 && otherFocusModel.audit != 3;
    _vipImgView.image = otherFocusModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    _crownImgView.hidden = otherFocusModel.star != 6;
    _nameLabel.text = otherFocusModel.nickName;
    _followBtn.selected = otherFocusModel.isMyFans;
    
    NSTimeInterval timeInterval = [otherFocusModel.createTime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    LXDateItem *item = [[NSDate date] lx_timeIntervalSinceDate:createDate];
    if (item.day == 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%@前",item.description];
    } else {
        _timeLabel.text = [self.dateFormatter stringFromDate:createDate];
    }
}

@end
