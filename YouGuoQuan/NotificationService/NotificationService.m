//
//  NotificationService.m
//  NotificationService
//
//  Created by YM on 2017/4/24.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    //self.contentHandler(self.bestAttemptContent);
    
    NSDictionary *apsDic = [request.content.userInfo objectForKey:@"aps"];
    NSString *attachUrl = [apsDic objectForKey:@"image"];
    //NSString *attachUrl = [apsDic objectForKey:@"image"];
    NSLog(@"%@",attachUrl);
    
    NSString *category = [apsDic objectForKey:@"category"];
    self.bestAttemptContent.categoryIdentifier = category;
    
    NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:attachUrl] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *file = [caches stringByAppendingPathComponent:response.suggestedFilename];
        
        // 将临时文件剪切或者复制Caches文件夹
        NSFileManager *mgr = [NSFileManager defaultManager];
        // AtPath : 剪切前的文件路径
        // ToPath : 剪切后的文件路径
        [mgr moveItemAtPath:location.path toPath:file error:nil];
        
        if (file && ![file  isEqualToString: @""]) {
            UNNotificationAttachment *attch = [UNNotificationAttachment attachmentWithIdentifier:@"photo" URL:[NSURL URLWithString:[@"file://" stringByAppendingString:file]] options:nil error:nil];
            if (attch) {
                self.bestAttemptContent.attachments = @[attch];
            }
        }
        self.contentHandler(self.bestAttemptContent);
    }];
    [downloadTask resume];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
