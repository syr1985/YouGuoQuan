//
//  ProfileSettingViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/4.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "ProfileSettingViewController.h"
#import <LCActionSheet.h>
#import "AlertViewTool.h"
#import "EMClient.h"

@interface ProfileSettingViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *notiSwitch;

@end

@implementation ProfileSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleString = @"设置";
    
    self.cacheSizeLabel.text = [NSString stringWithFormat:@"%.1fMB",[self folderSizeAtPath]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)notiSettingChanged:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (!sender.isSelected) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 30;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 0;
    } else {
        return 12;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        __weak typeof(self) weakself = self;
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@""
                                                 cancelButtonTitle:@"取消"
                                                           clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                               if (buttonIndex != 0) {
                                                                   [SCUserDefault setObject:nil forKey:KEY_USER_ACCOUNT];
                                                                   [SCUserDefault synchronize];
                                                                   [LoginData sharedLoginData].userId = nil;
                                                                   [[EMClient sharedClient] logout:NO];
                                                                   [weakself.navigationController popViewControllerAnimated:YES];
                                                               }
                                                           }
                                                 otherButtonTitles:@"退出登录",nil];
        actionSheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
        actionSheet.destructiveButtonColor = [UIColor redColor];
        [actionSheet show];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            __weak typeof(self) weakself = self;
            [AlertViewTool showAlertViewWithTitle:nil Message:@"确定清除缓存内容吗？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
                [weakself clearFile];
            } cancelBlock:nil];
        }
    }
}

//1:遍历文件夹获得文件夹大小，返回多少 M
- (float)folderSizeAtPath {
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *manager = [ NSFileManager defaultManager];
    if (![manager fileExistsAtPath:cachPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:cachPath] objectEnumerator];
    
    NSString * fileName;
    long long folderSize = 0 ;
    while((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [cachPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}

//2:首先我们计算一下 单个文件的大小
- (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 清理缓存
- (void)clearFile {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory ,NSUserDomainMask, YES) firstObject];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *files = [manager subpathsAtPath:cachePath];
    
    for (NSString *p in files) {
        NSError *error = nil ;
        NSString *path = [cachePath stringByAppendingPathComponent:p];
        if ([manager fileExistsAtPath:path]) {
            [manager removeItemAtPath:path error:&error];
        }
    }
    self.cacheSizeLabel.text = [NSString stringWithFormat:@"%.1fMB",[self folderSizeAtPath]];
}

@end
