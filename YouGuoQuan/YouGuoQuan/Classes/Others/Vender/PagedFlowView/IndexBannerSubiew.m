//
//  IndexBannerSubiew.m
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.

#import "IndexBannerSubiew.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomeBannerModel.h"
#import "UIImage+Color.h"

@interface IndexBannerSubiew ()
@property (strong, nonatomic) UIButton *recommandButton;
@end

@implementation IndexBannerSubiew

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        [self addSubview:self.mainImageView];
        [self addSubview:self.coverView];
        [self addSubview:self.recommandButton];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame normal:(BOOL)isNormal {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainImageView];
        [self addSubview:self.coverView];
        if (!isNormal) {
            self.layer.cornerRadius = 3;
            self.layer.masksToBounds = YES;
            [self addSubview:self.recommandButton];
        }
    }
    return self;
}

- (UIImageView *)mainImageView {
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _mainImageView.userInteractionEnabled = YES;
    }
    return _mainImageView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}

- (UIButton *)recommandButton {
    if (!_recommandButton) {
        _recommandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recommandButton.frame = CGRectMake(0, 0, 35, 45);
        _recommandButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_recommandButton setTitle:@"推荐" forState:UIControlStateNormal];
        [_recommandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recommandButton setBackgroundImage:[UIImage imageNamed:@"推荐背景"] forState:UIControlStateNormal];
    }
    return _recommandButton;
}

- (void)setHomeBannerModel:(HomeBannerModel *)homeBannerModel {
    _homeBannerModel = homeBannerModel;
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_mainImageView.frame.size];
    NSString *imageUrlStr = [NSString compressImageUrlWithUrlString:homeBannerModel.imageUrl
                                                              width:self.bounds.size.width
                                                             height:self.bounds.size.height];
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                      placeholderImage:phImage];
    
    _recommandButton.hidden = !homeBannerModel.isRecommend;
}

@end
