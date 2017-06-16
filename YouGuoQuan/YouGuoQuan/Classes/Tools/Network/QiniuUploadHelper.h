//
//  QiniuUploadHelper.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/1.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiniuUploadHelper : NSObject

@property(copy, nonatomic) void(^singleSuccessBlock)(NSString *url);

@property(copy, nonatomic) void(^singleFailureBlock)();

@property(copy, nonatomic) void(^pornSuccessBlock)(NSDictionary *result);

@property(copy, nonatomic) void(^pornFailureBlock)();

+ (instancetype)sharedUploadHelper;
@end
