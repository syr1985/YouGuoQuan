//
//  XHRealTimeBlur.m
//  XHRealTimeBlurExample
//
//  Created by 曾 宪华 on 14-9-7.
//  Copyright (c) 2014年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import "XHRealTimeBlur.h"

@interface XHGradientView : UIView

@end

@implementation XHGradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
        gradientLayer.colors = @[
                                 (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                                 (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
                                 ];
    }
    return self;
}

@end

@interface XHRealTimeBlur ()

@property (nonatomic, strong) XHGradientView *gradientBackgroundView;
@property (nonatomic, strong) UIToolbar *blurBackgroundView;
@property (nonatomic, strong) UIView *blackTranslucentBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;

@end

@implementation XHRealTimeBlur

- (void)showBlurViewAtView:(UIView *)currentView {
    [self showAnimationAtContainerView:currentView];
}

- (void)showBlurViewAtViewController:(UIViewController *)currentViewContrller {
    [self showAnimationAtContainerView:currentViewContrller.view];
}

- (void)disMiss {
    [self hiddenAnimation];
}

#pragma mark - Private

- (void)showAnimationAtContainerView:(UIView *)containerView {
    if (self.showed) {
        [self disMiss];
        return;
    } else {
        if (self.willShowBlurViewcomplted) {
            self.willShowBlurViewcomplted();
        }
    }
    self.alpha = 0.0;
    [containerView insertSubview:self atIndex:0];
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:self.showDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.alpha = 1.0;
    } completion:^(BOOL finished) {
        weakself.showed = YES;
        if (weakself.didShowBlurViewcompleted) {
            weakself.didShowBlurViewcompleted(finished);
        }
    }];
}

- (void)hiddenAnimation {
    //__weak typeof(self) weakself = self;
    [self hiddenAnimationCompletion:^(BOOL finished) {
        
    }];
}

- (void)hiddenAnimationCompletion:(void (^)(BOOL finished))completion {
    if (self.willDismissBlurViewCompleted) {
        self.willDismissBlurViewCompleted();
    }
    
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:self.disMissDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
        if (weakself.didDismissBlurViewCompleted) {
            weakself.didDismissBlurViewCompleted(finished);
        }
        weakself.showed = NO;
        [weakself removeFromSuperview];
    }];
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self hiddenAnimationCompletion:^(BOOL finished) {
        
    }];
}

#pragma mark - Propertys

- (void)setHasTapGestureEnable:(BOOL)hasTapGestureEnable {
    _hasTapGestureEnable = hasTapGestureEnable;
    [self setupTapGesture];
}

- (XHGradientView *)gradientBackgroundView {
    if (!_gradientBackgroundView) {
        _gradientBackgroundView = [[XHGradientView alloc] initWithFrame:self.bounds];
    }
    return _gradientBackgroundView;
}

- (UIToolbar *)blurBackgroundView {
    if (!_blurBackgroundView) {
        _blurBackgroundView = [[UIToolbar alloc] initWithFrame:self.bounds];
        [_blurBackgroundView setBarStyle:UIBarStyleBlackTranslucent];
    }
    return _blurBackgroundView;
}

- (UIView *)blackTranslucentBackgroundView {
    if (!_blackTranslucentBackgroundView) {
        _blackTranslucentBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _blackTranslucentBackgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    }
    return _blackTranslucentBackgroundView;
}

- (UIView *)whiteBackgroundView {
    if (!_whiteBackgroundView) {
        _whiteBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _whiteBackgroundView.backgroundColor = [UIColor clearColor];
        _whiteBackgroundView.tintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
    return _whiteBackgroundView;
}

- (UIView *)whiteTranslucentBackgroundView {
    if (!_whiteBackgroundView) {
        _whiteBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _whiteBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
        _whiteBackgroundView.tintColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    return _whiteBackgroundView;
}

- (UIView *)backgroundView {
    switch (self.blurStyle) {
        case XHBlurStyleBlackGradient:
            return self.gradientBackgroundView;
            break;
        case XHBlurStyleTranslucent:
            return self.blurBackgroundView;
        case XHBlurStyleBlackTranslucent:
            return self.blackTranslucentBackgroundView;
            break;
        case XHBlurStyleWhite:
            return self.whiteBackgroundView;
            break;
        case XHBlurStyleWhiteTranslucent:
            return self.whiteTranslucentBackgroundView;
            break;
        default:
            break;
    }
}

#pragma mark - Life Cycle

- (void)setup {
    self.showDuration = self.disMissDuration = 0.3;
    self.blurStyle = XHBlurStyleTranslucent;
    self.backgroundColor = [UIColor clearColor];
    
    _hasTapGestureEnable = NO;
}

- (void)setupTapGesture {
    if (self.hasTapGestureEnable) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        UIView *backgroundView = [self backgroundView];
        backgroundView.userInteractionEnabled = NO;
        [self addSubview:backgroundView];
    }
}

@end

#pragma mark - UIView XHRealTimeBlur分类的实现

@implementation UIView (XHRealTimeBlur)

#pragma mark - Show Block

- (WillShowBlurViewBlcok)willShowBlurViewcomplted {
    return objc_getAssociatedObject(self, &XHRealTimeWillShowBlurViewBlcokBlcokKey);
}

- (void)setWillShowBlurViewcomplted:(WillShowBlurViewBlcok)willShowBlurViewcomplted {
    objc_setAssociatedObject(self, &XHRealTimeWillShowBlurViewBlcokBlcokKey, willShowBlurViewcomplted, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DidShowBlurViewBlcok)didShowBlurViewcompleted {
    return objc_getAssociatedObject(self, &XHRealTimeDidShowBlurViewBlcokBlcokKey);
}

- (void)setDidShowBlurViewcompleted:(DidShowBlurViewBlcok)didShowBlurViewcompleted {
    objc_setAssociatedObject(self, &XHRealTimeDidShowBlurViewBlcokBlcokKey, didShowBlurViewcompleted, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - dismiss block

- (WillDismissBlurViewBlcok)willDismissBlurViewCompleted {
    return objc_getAssociatedObject(self, &XHRealTimeWillDismissBlurViewBlcokKey);
}

- (void)setWillDismissBlurViewCompleted:(WillDismissBlurViewBlcok)willDismissBlurViewCompleted {
    objc_setAssociatedObject(self, &XHRealTimeWillDismissBlurViewBlcokKey, willDismissBlurViewCompleted, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DidDismissBlurViewBlcok)didDismissBlurViewCompleted {
    return objc_getAssociatedObject(self, &XHRealTimeDidDismissBlurViewBlcokKey);
}

- (void)setDidDismissBlurViewCompleted:(DidDismissBlurViewBlcok)didDismissBlurViewCompleted {
    objc_setAssociatedObject(self, &XHRealTimeDidDismissBlurViewBlcokKey, didDismissBlurViewCompleted, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - RealTimeBlur HUD


- (XHRealTimeBlur *)realTimeBlur {
    return objc_getAssociatedObject(self, &XHRealTimeBlurKey);
}

- (void)setRealTimeBlur:(XHRealTimeBlur *)realTimeBlur {
    objc_setAssociatedObject(self, &XHRealTimeBlurKey, realTimeBlur, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 分类 公开方法

- (void)showRealTimeBlurWithBlurStyle:(XHBlurStyle)blurStyle {
    [self showRealTimeBlurWithBlurStyle:blurStyle hasTapGestureEnable:NO];
}

- (void)showRealTimeBlurWithBlurStyle:(XHBlurStyle)blurStyle hasTapGestureEnable:(BOOL)hasTapGestureEnable {
    XHRealTimeBlur *realTimeBlur = [self realTimeBlur];
    if (!realTimeBlur) {
        realTimeBlur = [[XHRealTimeBlur alloc] initWithFrame:self.bounds];
        realTimeBlur.blurStyle = blurStyle;
        [self setRealTimeBlur:realTimeBlur];
    }
    realTimeBlur.hasTapGestureEnable = hasTapGestureEnable;
    
    realTimeBlur.willShowBlurViewcomplted = self.willShowBlurViewcomplted;
    realTimeBlur.didShowBlurViewcompleted = self.didShowBlurViewcompleted;
    
    realTimeBlur.willDismissBlurViewCompleted = self.willDismissBlurViewCompleted;
    realTimeBlur.didDismissBlurViewCompleted = self.didDismissBlurViewCompleted;
    
    [realTimeBlur showBlurViewAtView:self];
}

- (void)disMissRealTimeBlur {
    [[self realTimeBlur] disMiss];
}

@end