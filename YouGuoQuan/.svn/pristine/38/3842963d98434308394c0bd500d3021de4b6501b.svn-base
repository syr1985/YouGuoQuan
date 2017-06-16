//
//  VideoViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/10.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "VideoViewCell.h"
#import "DiscoveryVideoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Color.h"

@interface VideoViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIButton *videoTotalTimeButton;
@end

@implementation VideoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _coverImageView.layer.cornerRadius = 4;
    _coverImageView.layer.masksToBounds = YES;
}

- (void)setDiscoveryVideoModel:(DiscoveryVideoModel *)discoveryVideoModel {
    _discoveryVideoModel = discoveryVideoModel;
    
    _userNickNameLabel.text = discoveryVideoModel.nickName;
    _userLocationLabel.text = discoveryVideoModel.city;
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_coverImageView.frame.size];
    NSString *imageUrlStr = [NSString compressImageUrlWithUrlString:discoveryVideoModel.videoEvelope
                                                              width:_coverImageView.bounds.size.width
                                                             height:_coverImageView.bounds.size.height];
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                       placeholderImage:phImage];

    _sexImageView.image = [UIImage imageNamed:discoveryVideoModel.sex];
    
    NSString *duration = discoveryVideoModel.duration;
    if (![duration containsString:@":"]) {
        if (duration.length) {
            float time = [duration floatValue];
            NSUInteger mintues = time / 60;
            NSUInteger seconds = (NSUInteger)roundf(time) % 60;
            duration  = [NSString stringWithFormat:@"%lu:%02lu", (unsigned long)mintues, (unsigned long)seconds];
        } else {
            duration = @"00:00";
        }
    }
    [_videoTotalTimeButton setTitle:duration forState:UIControlStateNormal];
}

@end
