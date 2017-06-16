//
//  CommentMessageModel.h
//  YouGuoQuan
//
//  Created by YM on 2017/2/24.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentMessageModel : NSObject
@property (nonatomic,   copy) NSString *relationId;
@property (nonatomic,   copy) NSString *userId;
@property (nonatomic,   copy) NSString *searcherId;
@property (nonatomic,   copy) NSString *nickName;
@property (nonatomic,   copy) NSString *headImg;
@property (nonatomic,   copy) NSString *imageUrl;
@property (nonatomic,   copy) NSString *content;
@property (nonatomic,   copy) NSString *aboutCommentId;
@property (nonatomic,   copy) NSString *createtime;
@property (nonatomic, assign) int  type;
@property (nonatomic, assign) int  audit;
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, assign) int  star;

@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)commentMessageModelWithDict:(NSDictionary *)dict;
- (instancetype)initCommentMessageModelWithDict:(NSDictionary *)dict;
@end
