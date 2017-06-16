//
//  CameraButton.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/23.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "CameraButton.h"

@implementation CameraButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

//- (CGRect)contentRectForBounds:(CGRect)bounds {
//    return CGRectMake(0, 0, bounds.size.width - self.currentImage.size.width, self.currentImage.size.height + 20);
//}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat h = contentRect.size.height;
    CGFloat width = self.bounds.size.width - self.currentImage.size.width;
    return CGRectMake(0, h, width, 20);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height;
    return CGRectMake((w - h) * 0.5, 0, h, h);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width * 0.5;
    center.y = self.imageView.frame.size.height * 0.5 - self.titleLabel.bounds.size.height * 0.5;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = self.titleLabel.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height - self.titleLabel.bounds.size.height * 0.5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
