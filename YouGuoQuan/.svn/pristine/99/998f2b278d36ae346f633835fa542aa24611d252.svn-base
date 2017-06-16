//
//  ActionSheetHelp.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/25.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "ActionSheetHelp.h"
#import <LCActionSheet.h>

@interface ActionSheetHelp () <LCActionSheetDelegate>

@end

@implementation ActionSheetHelp

static ActionSheetHelp *_instance;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)showActionSheetWithTitle:(NSString *)title  {
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:title
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"拍摄照片", @"从相册选取", nil];
    [actionSheet show];
}

#pragma mark - LCActionSheet Delegate

- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_actionSheetItemClicked) {
        _actionSheetItemClicked(actionSheet.title, buttonIndex);
    }
}

@end
