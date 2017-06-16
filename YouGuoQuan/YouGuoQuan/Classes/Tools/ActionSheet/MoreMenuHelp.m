//
//  MoreMenuHelp.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/7.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "MoreMenuHelp.h"
#import <LCActionSheet.h>

@implementation MoreMenuHelp

+ (void)showMoreMenu:(void (^)(NSUInteger index))returnBlock {
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil
                                             cancelButtonTitle:@"取消"
                                                       clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                           returnBlock(buttonIndex);
                                                       }
                                             otherButtonTitles:@"拉黑该用户",@"举报该用户", nil];
    [actionSheet show];
}

+ (void)showMoreMenuForTrends:(void (^)(NSUInteger index))returnBlock {
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil
                                             cancelButtonTitle:@"取消"
                                                       clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                           returnBlock(buttonIndex);
                                                       }
                                             otherButtonTitles:@"举报该动态", nil];
    [actionSheet show];
}

+ (void)showMoreMenuWithCancel:(void (^)(NSUInteger index))returnBlock {
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil
                                             cancelButtonTitle:@"取消"
                                                       clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                           returnBlock(buttonIndex);
                                                       }
                                             otherButtonTitles:@"举报用户",@"加入黑名单", nil];
    [actionSheet show];
}

+ (void)showMoreMenuForMineTrendsWithResult:(void (^)(NSUInteger index))returnBlock {
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil
                                             cancelButtonTitle:@"取消"
                                                       clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                           returnBlock(buttonIndex);
                                                       }
                                             otherButtonTitles:@"删除动态", nil];//@"置顶动态",
    actionSheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];//@2
    actionSheet.destructiveButtonColor = WarningTipsTextColor;
    [actionSheet show];
}

+ (void)showScreenMenuWithResult:(void (^)(NSUInteger))returnBlock {
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil
                                             cancelButtonTitle:@"取消"
                                                       clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                           returnBlock(buttonIndex);
                                                       }
                                             otherButtonTitles:@"查看全部", @"只看男神", @"只看女神", nil];
    [actionSheet show];
}

@end
