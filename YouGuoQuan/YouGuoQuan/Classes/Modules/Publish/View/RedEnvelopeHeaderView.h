//
//  RedEnvelopeHeaderView.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/28.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedEnvelopeHeaderView : UICollectionReusableView

@property (nonatomic, copy) void (^setTitle)(NSString *title);

@end