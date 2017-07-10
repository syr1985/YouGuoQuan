//
//  XYTabBar.m
//  XianYu
//
//  Created by ZpyZp on 15/10/23.
//  Copyright © 2015年 berchina. All rights reserved.
//

#import "XYTabBar.h"
#import "UIView+SCFrame.h"

@interface XYTabBar()
@property (nonatomic,strong) UIButton *plusBtn;
@end

@implementation XYTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"发布功能"] forState:UIControlStateNormal];
        plusBtn.adjustsImageWhenHighlighted = NO;
        //plusBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        plusBtn.titleEdgeInsets = UIEdgeInsetsMake(80, 0, 0, 0);
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

- (void)plusClick {
    //通知代理
    if (self.publishButtonClickedBlock) {
        self.publishButtonClickedBlock();
    }
}

- (void)layoutSubviews {
    //不能删，一定要调用，等布局完我们再覆盖行为
    [super layoutSubviews];
    //覆盖排布
    
    //1.设置自定义按钮的位置
    self.plusBtn.centerX = self.frameWidth * 0.5;
    self.plusBtn.originY = -20;
    
    //2.设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.frameWidth / 5;
    CGFloat tabbarButtonIndex = 0;
    
    for (UIView *child in self.subviews) {
        Class class =  NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            //设置宽度
            child.frameWidth = tabbarButtonW;
            //设置x
            child.originX = tabbarButtonIndex * tabbarButtonW;
            
            //增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
}

@end
