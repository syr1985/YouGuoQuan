//
//  YGDatePickerView.h
//  YouGuoQuan
//
//  Created by liushuai on 2017/1/10.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGDatePickerView;

@protocol YGDatePickerViewDelegate <NSObject>
@optional
- (void)didPickDate:(NSDate *)date pickerView:(YGDatePickerView *)pickerView;
- (void)didCancelPickDate:(YGDatePickerView *)pickerView;

@end

@interface YGDatePickerView : UIView
@property(nonatomic, weak) id<YGDatePickerViewDelegate> delegate;
- (void)show;
@end
