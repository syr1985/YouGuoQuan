//
//  ProductDetailModel.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/20.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductDetailModel : NSObject
@property (nonatomic,   copy) NSString *goodsId;
@property (nonatomic,   copy) NSString *goodsName;
@property (nonatomic,   copy) NSString *imageUrl;
@property (nonatomic,   copy) NSString *goodsLink;
@property (nonatomic,   copy) NSString *goodsInstro;
@property (nonatomic,   copy) NSString *userId;
@property (nonatomic,   copy) NSString *updateTime;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, assign) BOOL isReal;
@property (nonatomic, assign) int goodsType;

// Cell的高（自己根据数据计算的，不在返回字段里）
@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)productDetailModelWithDict:(NSDictionary *)dict;
- (instancetype)initProductDetailModelWithDict:(NSDictionary *)dict;
@end
