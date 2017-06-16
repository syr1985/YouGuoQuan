//
//  PraiseMessageCell.m
//  YouGuoQuan
//
//  Created by liushuai on 16/12/10.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PraiseMessageCell.h"
#import "FavourMessageModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+LXExtension.h"

@interface PraiseMessageCell()
@property(nonatomic, weak) IBOutlet UIImageView *headImgView;
@property(nonatomic, weak) IBOutlet UIImageView *vipImgView;
@property(nonatomic, weak) IBOutlet UIImageView *crownImgView;
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property(nonatomic, weak) IBOutlet UILabel *praiseLabel;
@property(nonatomic, weak) IBOutlet UILabel *timeLabel;
@property(nonatomic, weak) IBOutlet UIImageView *picImgView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation PraiseMessageCell

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
        _tapHeaderImageViewBlock(_favourMessageModel.userId);
    }
}

- (void)setFavourMessageModel:(FavourMessageModel *)favourMessageModel {
    _favourMessageModel = favourMessageModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:favourMessageModel.headImg
                                                                  width:_headImgView.bounds.size.width
                                                                 height:_headImgView.bounds.size.height];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                    placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _vipImgView.hidden = favourMessageModel.audit != 1 && favourMessageModel.audit != 3;
    _vipImgView.image = favourMessageModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    _crownImgView.hidden = favourMessageModel.star != 6;
    
    if (favourMessageModel.imageUrl.length) {
        NSString *imageUrlStr = [NSString compressImageUrlWithUrlString:favourMessageModel.imageUrl
                                                                  width:_picImgView.bounds.size.width
                                                                 height:_picImgView.bounds.size.height];
        [_picImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
    }
    _nameLabel.text = favourMessageModel.nickName;
    
    switch (favourMessageModel.type) {
        case 1:
            _praiseLabel.text = @"赞了你的动态";
            break;
        case 2:
            _praiseLabel.text = @"赞了你的视频";
            break;
        case 4:
            _praiseLabel.text = @"赞了你的红包照片";
            break;
    }
    
    NSTimeInterval timeInterval = [favourMessageModel.createtime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    LXDateItem *item = [[NSDate date] lx_timeIntervalSinceDate:createDate];
    if (item.day == 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%@前",item.description];
    } else {
        _timeLabel.text = [self.dateFormatter stringFromDate:createDate];
    }
}

@end
