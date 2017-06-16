//
//  NSString+Encrypt.m
//  EastNetworkPro
//
//  Created by njfanya on 15-6-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Encrypt)

- (NSString *)MD5 {
    const char* cStr = [self UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0;  i < CC_MD5_DIGEST_LENGTH; ++i) {
        [result appendFormat:@"%02x",digest[i]];//这是32位大写，如果要32位小写把X改成x
    }
    
    return result;
}


- (NSString *)URLEncoding {
//    NSCharacterSet *URLFullCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"\"#%/:<>?@[\\]^`{|}=;"] invertedSet];
//    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:URLFullCharacterSet];
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    return encodeUrl;
}

//- (NSString *)URLEncoding {
//    //    NSCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
//    //    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                                                    (CFStringRef)self,
//                                                                                                    NULL,
//                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
//                                                                                                    kCFStringEncodingUTF8));
//    NSString *urlEncoded = [encodedString stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
//    
//    //urlEncoded = [urlEncoded stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
//    
//    return urlEncoded;
//}

- (NSString *)MD5_New {
    const char* cStr = [self UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0;  i < CC_MD5_DIGEST_LENGTH; ++i) {
        [result appendFormat:@"%x",((digest[i] & 0xF0) >> 4)];
        [result appendFormat:@"%x",(digest[i] & 0x0F)];
    }
    
    return result;
}

@end
