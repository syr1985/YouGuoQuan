//
//  RecordWaveView.m
//  YouGuoQuan
//
//  Created by liushuai on 2017/1/8.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "RecordWaveView.h"

@interface RecordWaveView()

@property(nonatomic, strong) NSMutableArray *waveArray;

@end

@implementation RecordWaveView

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.waveArray = [@[@(0), @(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,2.5);
    CGContextSetRGBStrokeColor(context, 1, 216.0 / 255, 152.0 / 255, 1);
    
    CGFloat myWidth = (rect.size.width - 2.5) / self.waveArray.count;
    for (NSInteger i = 0; i < self.waveArray.count; i ++) {
        NSInteger j = i;
        if (self.reverse) {
            j = self.waveArray.count - i - 1;
        }
        
        CGContextMoveToPoint(context, myWidth * i + 1.25, rect.size.height * (0.5 - [self.waveArray[j] doubleValue] / 2));
        //下一点
        CGContextAddLineToPoint(context,myWidth * i + 1.25, rect.size.height * (0.5 + [self.waveArray[j] doubleValue] / 2));
        //绘制完成
        CGContextStrokePath(context);
    }
}

- (void) addWave : (double) wave {
    for (NSUInteger i = self.waveArray.count - 1; i > 0; i--) {
        self.waveArray[i] = self.waveArray[i-1];
    }
    self.waveArray[0] = @(wave);
    [self setNeedsDisplay];
    
}

@end
