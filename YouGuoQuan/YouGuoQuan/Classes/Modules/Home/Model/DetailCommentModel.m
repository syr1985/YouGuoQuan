//
//  DetailCommentModel.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/21.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "DetailCommentModel.h"
#import <MJExtension.h>
#import "NSString+StringSize.h"

@implementation DetailCommentModel

+ (instancetype)detailCommentModelWithDict:(NSDictionary *)dict {
    [DetailCommentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"commentId" : @"id"};
    }];
    return [[DetailCommentModel alloc] initDetailCommentModelWithDict:dict];
}

- (instancetype)initDetailCommentModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [DetailCommentModel mj_objectWithKeyValues:dict];
        
        CGFloat contentH = [NSString heightWithString:self.commentContent
                                              maxSize:CGSizeMake(WIDTH - 76, 0)
                                              strFont:[UIFont systemFontOfSize:14]];
        if (contentH < 1) {
            contentH += 16;
        }
        
        self.cellHeight = contentH + 48;
    }
    return self;
}

- (int)star {
    if (_star > 6) {
        return 6;
    }
    return _star;
}

@end
