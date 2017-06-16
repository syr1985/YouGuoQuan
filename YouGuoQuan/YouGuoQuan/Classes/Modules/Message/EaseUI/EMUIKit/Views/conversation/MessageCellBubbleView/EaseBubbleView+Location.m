/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */


#import "EaseBubbleView+Location.h"
#import <Masonry.h>

@implementation EaseBubbleView (Location)

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - private
- (void)_setupLocationBubbleMarginConstraints {
    __weak typeof(self) weakself = self;
    [self.locationImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.backgroundImageView.mas_top).with.offset(0);
        make.bottom.equalTo(weakself.backgroundImageView.mas_bottom).with.offset(0);
        make.left.equalTo(weakself.backgroundImageView.mas_left).with.offset(weakself.margin.left);
        make.right.equalTo(weakself.backgroundImageView.mas_right).with.offset(-weakself.margin.right);
    }];
}

//- (void)_setupLocationBubbleConstraints {
//    [self _setupLocationBubbleMarginConstraints];
//    
//    __weak typeof(self) weakself = self;
//    
//}

#pragma mark - public

- (void)setupLocationBubbleView {
    self.locationImageView = [[UIImageView alloc] init];
    self.locationImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.locationImageView.backgroundColor = [UIColor clearColor];
    self.locationImageView.clipsToBounds = YES;
    [self.backgroundImageView addSubview:self.locationImageView];
    
    self.textBackView = [[UIView alloc] init];
    self.textBackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textBackView.backgroundColor = [UIColor whiteColor];
    [self.locationImageView addSubview:self.textBackView];
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.locationLabel.numberOfLines = 2;
    self.locationLabel.font = [UIFont systemFontOfSize:14];
    self.locationLabel.textColor = FontColor;
    self.locationLabel.backgroundColor = [UIColor whiteColor];
    [self.textBackView addSubview:self.locationLabel];
    
    self.detailLocationLabel = [[UILabel alloc] init];
    self.detailLocationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailLocationLabel.numberOfLines = 2;
    self.detailLocationLabel.font = [UIFont systemFontOfSize:12];
    self.detailLocationLabel.textColor = GaryFontColor;
    self.detailLocationLabel.backgroundColor = [UIColor whiteColor];
    [self.textBackView addSubview:self.detailLocationLabel];
    
    __weak typeof(self) weakself = self;
    [self.textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.locationImageView.mas_bottom);
        make.left.equalTo(weakself.locationImageView.mas_left);
        make.right.equalTo(weakself.locationImageView.mas_right);
        //make.height.mas_equalTo(60);
    }];
    
    [self.detailLocationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.locationLabel.mas_left);
        make.right.equalTo(weakself.locationLabel.mas_right);
        make.bottom.equalTo(weakself.textBackView.mas_bottom).with.offset(-12);
        //make.height.mas_equalTo(30);
    }];
    
    [self.locationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.textBackView.mas_left).with.offset(12);
        make.right.equalTo(weakself.textBackView.mas_right).with.offset(-12);
        make.bottom.equalTo(weakself.detailLocationLabel.mas_top);
        make.top.equalTo(weakself.textBackView.mas_top).with.offset(12);
        //make.height.mas_equalTo(30);
    }];
    
    [self _setupLocationBubbleMarginConstraints];
}

- (void)updateLocationMargin:(UIEdgeInsets)margin {
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self _setupLocationBubbleMarginConstraints];
}

@end
