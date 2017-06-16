//
//  SystemMessageModel.h
//  YouGuoQuan
//
//  Created by YM on 2017/3/4.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMessageModel : NSObject
@property (nonatomic,   copy) NSString *msgId;
@property (nonatomic,   copy) NSString *content;
@property (nonatomic,   copy) NSString *relationId;
@property (nonatomic,   copy) NSString *userId;
@property (nonatomic,   copy) NSString *createTime;
@property (nonatomic,   copy) NSString *updateTime;
@property (nonatomic, assign) int  type;
@property (nonatomic, assign) BOOL isDelete;

@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)systemMessageModelWithDict:(NSDictionary *)dict;
- (instancetype)initSystemMessageModelWithDict:(NSDictionary *)dict;
@end
