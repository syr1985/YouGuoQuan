//
//  PhotoWallModel.h
//  YouGuoQuan
//
//  Created by YM on 2017/3/30.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoWallModel : NSObject
@property (nonatomic,   copy) NSString *imageId;
@property (nonatomic,   copy) NSString *imageDesc;
@property (nonatomic,   copy) NSString *imageTitle;
@property (nonatomic,   copy) NSString *imageUrl;
@property (nonatomic,   copy) NSString *imageUserId;
@property (nonatomic,   copy) NSString *createTime;
@property (nonatomic,   copy) NSString *updateTime;
@property (nonatomic, assign) BOOL isDelete;

+ (instancetype)photoWallModelWithDict:(NSDictionary *)dict;
- (instancetype)initPhotoWallModelWithDict:(NSDictionary *)dict;
@end
