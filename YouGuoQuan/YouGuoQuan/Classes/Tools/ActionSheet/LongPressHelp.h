//
//  LongPressHelp.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/21.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MenuType) {
    MenuType_LongPressSelfComment,
    MenuType_LongPressOtherComment,
    MenuType_LongPressSelfTrends,
    MenuType_LongPressSelfTrendsAndSelfComment
};

@interface LongPressHelp : NSObject

+ (void)showLongPressMenuWithType:(MenuType)type returnBlock:(void (^)(NSUInteger index))returnBlock;

+ (void)showMenuForLongPressImageWithReturnBlock:(void (^)(NSUInteger index))returnBlock;

@end
