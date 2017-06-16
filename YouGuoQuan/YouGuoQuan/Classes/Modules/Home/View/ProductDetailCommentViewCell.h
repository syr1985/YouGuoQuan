//
//  ProductDetailCommentViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/17.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductEvaluateModel;
@interface ProductDetailCommentViewCell : UITableViewCell
@property (nonatomic,   copy) void (^commentListBlock)();
@property (nonatomic, strong) ProductEvaluateModel *detailEvaluateModel;
@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) NSNumber *commentCount;
@end
