//
//  SystemMessageModel.m
//  YouGuoQuan
//
//  Created by YM on 2017/3/4.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "SystemMessageModel.h"
#import <MJExtension.h>
#import "NSString+StringSize.h"

@implementation SystemMessageModel

+ (instancetype)systemMessageModelWithDict:(NSDictionary *)dict {
    [SystemMessageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"msgId" : @"id"};
    }];
    return [[SystemMessageModel alloc] initSystemMessageModelWithDict:dict];
}

- (instancetype)initSystemMessageModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [SystemMessageModel mj_objectWithKeyValues:dict];
        
        NSString *contentStr = self.content;
        if ([self.content containsString:@";"]) {
            NSArray *strArray = [self.content componentsSeparatedByString:@";"];
            contentStr = strArray[0];
        }
        
        CGFloat contentH = [NSString heightWithString:contentStr
                                              maxSize:CGSizeMake(WIDTH - 24, 0)
                                              strFont:[UIFont systemFontOfSize:14]];
        self.cellHeight = contentH + 50;
    }
    return self;
}

@end
