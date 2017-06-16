//
//  YGSelectPicCell.h
//  YouGuoQuan
//
//  Created by liushuai on 2016/12/21.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TZAssetModel;
@class YGSelectPicCell;

@protocol YGSelectPicCellDelegate <NSObject>

- (void) switchSelected : (BOOL) isSelected forCell : (YGSelectPicCell *) cell;
- (void) tapCell : (YGSelectPicCell *) cell;

@end

@interface YGSelectPicCell : UICollectionViewCell
- (void) refreshContent : (TZAssetModel *) model;

@property(nonatomic, weak) id<YGSelectPicCellDelegate> delegate;

+ (NSString *) reuseIdentifier;

@end
