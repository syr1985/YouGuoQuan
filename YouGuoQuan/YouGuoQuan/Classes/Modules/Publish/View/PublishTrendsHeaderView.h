//
//  PublishTrendsHeaderView.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/28.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishTrendsHeaderView : UICollectionReusableView

@property (nonatomic, copy) void (^setContent)(NSString *title);

@end
