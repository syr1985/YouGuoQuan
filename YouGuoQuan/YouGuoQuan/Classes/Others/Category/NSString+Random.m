//
//  NSString+Encrypt.m
//  EastNetworkPro
//
//  Created by njfanya on 15-6-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSString+Random.h"
#import <CommonCrypto/CommonDigest.h>

#include <sys/param.h>
#include <sys/mount.h>

#define random_count 5

@implementation NSString (Random)

+ (NSString*)randomString {
    //数字: 48-57
    //小写字母: 97-122
    //大写字母: 65-90
    char chars[] = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLOMNOPQRSTUVWXYZ";
    char codes[random_count];
    
    for (int i = 0; i < random_count; i++) {
        codes[i]= chars[arc4random()%62];
    }
    
    NSString *text = [[NSString alloc] initWithBytes:codes
                                              length:random_count
                                            encoding:NSUTF8StringEncoding];
    return text;
}

+ (NSString *)freeDiskSpaceInBytes {
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return [NSString stringWithFormat:@"手机剩余存储空间为：%qi MB" ,freespace/1024/1024];
}

+ (NSString*)getDateTimeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString*)randomStringWithLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    for (int i = 0; i < len; i++) {
        [randomString appendFormat:@"%C",[letters characterAtIndex:arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end
