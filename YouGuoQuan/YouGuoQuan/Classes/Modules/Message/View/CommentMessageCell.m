//
//  CommentMessageCell.m
//  YouGuoQuan
//
//  Created by liushuai on 16/12/10.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "CommentMessageCell.h"
#import "CommentMessageModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+LXExtension.h"

@interface CommentMessageCell() 
@property (nonatomic, weak) IBOutlet UIImageView *headImgView;
@property (nonatomic, weak) IBOutlet UIImageView *vipImgView;
@property (nonatomic, weak) IBOutlet UIImageView *crownImgView;
@property (nonatomic, weak) IBOutlet UIImageView *trendsImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation CommentMessageCell

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
        _tapHeaderImageViewBlock(_commentMessageModel.userId);
    }
}

- (void)setCommentMessageModel:(CommentMessageModel *)commentMessageModel {
    _commentMessageModel = commentMessageModel;
    
    NSString *imageUrlStr = [NSString compressImageUrlWithUrlString:commentMessageModel.headImg
                                                              width:_headImgView.bounds.size.width
                                                             height:_headImgView.bounds.size.height];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _vipImgView.hidden = (commentMessageModel.audit != 1 && commentMessageModel.audit != 3);
    _vipImgView.image = commentMessageModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    
    _crownImgView.hidden = commentMessageModel.star != 6;
    if (commentMessageModel.imageUrl.length) {
        NSString *trendsImageUrlStr = [NSString compressImageUrlWithUrlString:commentMessageModel.imageUrl
                                                                        width:_trendsImageView.bounds.size.width
                                                                       height:_trendsImageView.bounds.size.height];
        [_trendsImageView sd_setImageWithURL:[NSURL URLWithString:trendsImageUrlStr]];
    }
    _nameLabel.text = commentMessageModel.nickName;
    _contentLabel.text = commentMessageModel.content;
    
    NSTimeInterval timeInterval = [commentMessageModel.createtime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    LXDateItem *item = [[NSDate date] lx_timeIntervalSinceDate:createDate];
    if (item.day == 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%@前",item.description];
    } else {
        _timeLabel.text = [self.dateFormatter stringFromDate:createDate];
    }
}

@end
