//
//  MessageViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/24.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "MessageViewCell.h"

@interface MessageViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation MessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setInfoDict:(NSDictionary *)infoDict {
    _infoDict = infoDict;
    
    _iconImageView.image = [UIImage imageNamed:infoDict[@"icon"]];
    _titleLabel.text = infoDict[@"title"];
    NSInteger unreadCount = [infoDict[@"count"] integerValue];
    _countLabel.hidden = unreadCount == 0;
    if (unreadCount > 99) {
        _countLabel.text = @"99+";
    } else {
        _countLabel.text = [NSString stringWithFormat:@"%zd",unreadCount];
    }
}

- (IBAction)pushButtonClicked:(id)sender {
    //    if (_pushToDetailBlock) {
    //        _pushToDetailBlock();
    //    }
}

@end
