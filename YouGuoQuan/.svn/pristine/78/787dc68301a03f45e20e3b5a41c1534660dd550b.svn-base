//
//  HotSearchViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/3/29.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "HotSearchViewCell.h"

@implementation HotSearchViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHotSearch:(NSArray *)hotSearch {
    _hotSearch = hotSearch;
    
    self.backgroundColor = BackgroundColor;
    
    NSUInteger row = ceil(hotSearch.count / 3.0);
    NSUInteger col = 3;
    CGFloat marginX = 20;
    CGFloat marginY = 12;
    CGFloat btnW = (WIDTH - marginX * (col + 1)) / col;
    CGFloat btnH = 30;
    
    for (NSUInteger i = 0; i < row; i++) {
        CGFloat btnY = btnH * i + marginY * (i + 1);
        for (NSUInteger j = 0; j <  col; j++) {
            CGFloat btnX = btnW * j + marginX * (j + 1);
            NSUInteger index = i * col + j;
            if (index < hotSearch.count) {
                NSString *city = hotSearch[index];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                btn.layer.cornerRadius = 4;
                btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
                [btn setTitle:city forState:UIControlStateNormal];
                [btn setTitleColor:FontColor forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
        }
    }
}

- (void)buttonClicked:(UIButton *)button {
    if (self.hotSearchSelectedBlock) {
        self.hotSearchSelectedBlock(button.titleLabel.text);
    }
}

@end
