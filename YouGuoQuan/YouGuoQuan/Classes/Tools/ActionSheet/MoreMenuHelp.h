//
//  MoreMenuHelp.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/7.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreMenuHelp : NSObject

+ (void)showMoreMenu:(void (^)(NSUInteger index))returnBlock;

+ (void)showMoreMenuForTrends:(void (^)(NSUInteger index))returnBlock;

+ (void)showMoreMenuWithCancel:(void (^)(NSUInteger index))returnBlock;

+ (void)showMoreMenuForMineTrendsWithResult:(void (^)(NSUInteger index))returnBlock;

+ (void)showScreenMenuWithResult:(void (^)(NSUInteger index))returnBlock;

@end
