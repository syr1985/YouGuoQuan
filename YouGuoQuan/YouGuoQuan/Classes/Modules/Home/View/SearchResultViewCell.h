//
//  SearchResultViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/21.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchReaultModel;
@interface SearchResultViewCell : UITableViewCell
@property (nonatomic,   copy) void (^loginBlock)();
@property (nonatomic, strong) SearchReaultModel *searchResultModel;

@end
