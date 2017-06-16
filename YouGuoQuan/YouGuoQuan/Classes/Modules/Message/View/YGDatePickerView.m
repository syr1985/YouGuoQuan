//
//  YGDatePickerView.m
//  YouGuoQuan
//
//  Created by liushuai on 2017/1/10.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "YGDatePickerView.h"
#import "Masonry.h"

@interface YGDatePickerView()

@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIView *darkView;
@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *okButton;
@end


@implementation YGDatePickerView

- (instancetype) init {
    self = [super init];
    if (self) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(keyWindow);
        }];
        
        self.darkView = [[UIView alloc] init];
        self.darkView.alpha  = 0;
        self.darkView.userInteractionEnabled = NO;
        self.darkView.backgroundColor = [UIColor colorWithRed:46 / 255.0 green:49 / 255.0 blue:50 / 255.0 alpha:0.5];
        [self addSubview:self.darkView ];
        [self.darkView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapBack)];
        [self.darkView  addGestureRecognizer:tap];
        
        
        [self addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(200);
        }];
        
        [self.bottomView addSubview:self.datePicker];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bottomView);
            make.right.mas_equalTo(self.bottomView);
            make.bottom.mas_equalTo(self.bottomView);
            make.height.mas_equalTo(170);
        }];
        [self.bottomView addSubview:self.okButton];
        [self.bottomView addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bottomView).with.offset(8);
            make.left.mas_equalTo(self.bottomView).with.offset(15);
        }];
        
        [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bottomView).with.offset(8);
            make.right.mas_equalTo(self.bottomView).with.offset(-15);
        }];
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, 200);
        self.hidden = YES;
    }
    return self;
}


- (void)dealloc {
    [self removeFromSuperview];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIDatePicker *) datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.minimumDate = [NSDate date];
        _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:14 * 24 * 3600];
    }
    return _datePicker;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:NavTabBarColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(actionCancelPickDate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *) okButton {
    if (!_okButton) {
        _okButton = [[UIButton alloc] init];
        _okButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:NavTabBarColor forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(actionConfirmPickDate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}

- (void) show {
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
        self.darkView.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.bottomView.transform = CGAffineTransformIdentity;
        self.darkView.alpha = 0.5;
        [self.darkView  setUserInteractionEnabled:YES];
    }];
    
}

- (void) actionTapBack {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, 200);
    } completion:^(BOOL finished) {
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, 200);
        [self.darkView  setUserInteractionEnabled:NO];
        self.hidden = YES;
    }];
}

- (void) actionCancelPickDate {
    [self actionTapBack];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelPickDate:)]) {
        [self.delegate didCancelPickDate:self];
    }
}

- (void) actionConfirmPickDate {
    [self actionTapBack];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPickDate:pickerView:)]) {
        [self.delegate didPickDate:self.datePicker.date pickerView:self];
    }
}

@end
