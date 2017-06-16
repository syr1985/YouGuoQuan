//
//  CrowdfundingViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/10.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "CrowdfundingViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DiscoveryCrowdfundingModel.h"
#import "NSDate+LXExtension.h"
#import "NSString+AttributedText.h"
#import "UIImage+Color.h"

@interface CrowdfundingViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation CrowdfundingViewCell

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
//        _dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        _dateFormatter.dateFormat = @"yyyy/MM/dd";
    }
    return _dateFormatter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDiscoveryCrowdfundingModel:(DiscoveryCrowdfundingModel *)discoveryCrowdfundingModel {
    _discoveryCrowdfundingModel = discoveryCrowdfundingModel;
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_crownImageView.frame.size];
    [_crownImageView sd_setImageWithURL:[NSURL URLWithString:discoveryCrowdfundingModel.coverImgUrl]
                       placeholderImage:phImage];
    
    NSDate *cfEndDate = [self.dateFormatter dateFromString:discoveryCrowdfundingModel.cfTimeEnd];
    if ([cfEndDate compare:[NSDate date]] != NSOrderedDescending) {
        _lastTimeLabel.text = @"众筹已结束";
        return;
    }
    
    NSTimeInterval interval = [cfEndDate timeIntervalSinceDate:[NSDate date]];
    int secondsPerDay = 24 * 3600;
    int day = interval / secondsPerDay;
    
    NSString *lastDayString = [NSString stringWithFormat:@"众筹还有%d天",day];
    NSRange range = [lastDayString rangeOfString:[NSString stringWithFormat:@"%d",day]];
    _lastTimeLabel.attributedText = [NSString attributedStringWithString:lastDayString
                                                                   color:[UIColor redColor]
                                                                   range:range];
}

@end