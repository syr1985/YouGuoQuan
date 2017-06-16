//
//  LongPressCommentHelp.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/21.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "LongPressHelp.h"
#import <LCActionSheet.h>

@implementation LongPressHelp

+ (void)showLongPressMenuWithType:(MenuType)type returnBlock:(void (^)(NSUInteger index))returnBlock {
    LCActionSheet *actionSheet = nil;
    if (type == MenuType_LongPressSelfTrends) {
        actionSheet = [LCActionSheet sheetWithTitle:nil
                                  cancelButtonTitle:@"取消"
                                            clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                returnBlock(buttonIndex);
                                            }
                                  otherButtonTitles:@"复制评论",@"举报评论",@"删除评论", nil];
    } else if (type == MenuType_LongPressSelfComment) {
        actionSheet = [LCActionSheet sheetWithTitle:nil
                                  cancelButtonTitle:@"取消"
                                            clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                returnBlock(buttonIndex);
                                            }
                                  otherButtonTitles:@"删除评论", nil];
    } else if (type == MenuType_LongPressSelfTrendsAndSelfComment) {
        actionSheet = [LCActionSheet sheetWithTitle:nil
                                  cancelButtonTitle:@"取消"
                                            clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                returnBlock(buttonIndex);
                                            }
                                  otherButtonTitles:@"复制评论",@"删除评论", nil];
    } else {
        actionSheet = [LCActionSheet sheetWithTitle:nil
                                  cancelButtonTitle:@"取消"
                                            clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                returnBlock(buttonIndex);
                                            }
                                  otherButtonTitles:@"复制评论",@"举报评论", nil];
    }
    [actionSheet show];
}

+ (void)showMenuForLongPressImageWithReturnBlock:(void (^)(NSUInteger index))returnBlock {
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil
                                             cancelButtonTitle:@"取消"
                                                       clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                           returnBlock(buttonIndex);
                                                       }
                                             otherButtonTitles:@"删除图片", nil];
    actionSheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];//@2
    actionSheet.destructiveButtonColor = WarningTipsTextColor;
    [actionSheet show];
}

@end