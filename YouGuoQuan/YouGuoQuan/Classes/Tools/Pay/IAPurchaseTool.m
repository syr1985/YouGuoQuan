//
//  IAPurchaseTool.m
//  YouGuoQuan
//
//  Created by YM on 2017/5/2.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "IAPurchaseTool.h"

#define Key_Receipt @"ReceiptDataString"
#define Key_OrderNo @"OrderNoForReceipt"

@interface IAPurchaseTool ()
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic,   copy) void (^paySuccessBlock)();
@property (nonatomic,   copy) void (^payFailureBlock)();
@end

@implementation IAPurchaseTool

static IAPurchaseTool *_instance;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleProductRequestNotification:)
                                                     name:APProductRequestNotification
                                                   object:[APProductManager sharedInstance]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handlePurchasesNotification:)
                                                     name:APPurchaseNotification
                                                   object:[APStoreObserver sharedInstance]];
    }
    return self;
}

- (void)purchaseWithProductID:(NSString *)productID orderNo:(NSString *)orderNo {
    _orderNo = orderNo;
    APProductManager *productManager = [APProductManager sharedInstance];
    [productManager fetchProductInformationForIds:@[productID]];
}

- (void)purchaseWithProductID:(NSString *)productID orderNo:(NSString *)orderNo success:(void (^)())success failure:(void (^)())failure {
    _orderNo = orderNo;
    _paySuccessBlock = [success copy];
    _payFailureBlock = [failure copy];
    APProductManager *productManager = [APProductManager sharedInstance];
    [productManager fetchProductInformationForIds:@[productID]];
}

- (void)handleProductRequestNotification: (NSNotification *)notification {
    APProductManager *productRequestNotification = (APProductManager*)notification.object;
    APProductRequestStatus result = (APProductRequestStatus)productRequestNotification.status;
    
    if (result == APProductRequestSuccess) {
//        NSLog(@"VALID: %@", productRequestNotification.availableProducts);
//        NSLog(@"INVALID: %@", productRequestNotification.invalidProductIds);
        
        NSArray *productArray = productRequestNotification.availableProducts;
        if (productArray.count) {
            SKProduct *product_1 = productArray.firstObject;
            
            APStoreObserver *storeObs = [APStoreObserver sharedInstance];
            [storeObs buy:product_1];
        }
    }
}

- (void)handlePurchasesNotification:(NSNotification *)notification {
    APStoreObserver *purchasesNotification = (APStoreObserver *)notification.object;
    APPurchaseStatus status = (APPurchaseStatus)purchasesNotification.status;
    
    switch ( status ) {
#pragma - Purchase
        case APPurchaseSucceeded: {
//            NSLog(@"Purchase-Success: %@", purchasesNotification.productsPurchased);
            // Verify receipts step.
            [self verifyReceipts];
            break;
        }
        case APPurchaseFailed: {
//            NSLog(@"Purchase-Failed %@", purchasesNotification.errorMessage);
            [SVProgressHUD showInfoWithStatus:purchasesNotification.errorMessage];
            [self saveReceipt];
            break;
        }
        case APPurchaseCancelled: {
//            NSLog(@"Purchase-Cancelled!");
            [SVProgressHUD showInfoWithStatus:purchasesNotification.errorMessage];
            break;
        }
#pragma - Restore
        case APRestoredSucceeded: {
//            NSLog(@"Restored-Success: %@", purchasesNotification.productsRestored);
            break;
        }
        case APRestoredFailed: {
//            NSLog(@"Restored-Failed %@", purchasesNotification.errorMessage);
            break;
        }
        case APRestoredCancelled: {
//            NSLog(@"Restored-Cancelled!");
            break;
        }
        default:
            break;
    }
}

#pragma mark 本地验证购买凭据
- (void)verifyReceipts {
    [SVProgressHUD dismiss];
    //验证凭据，获取到苹果返回的交易凭据
    //appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    //从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    //凭据存在
    if (receiptData) {
        NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        [NetworkTool verifyReceiptWithReceipt:encodeStr orderNo:_orderNo success:^{
            [SVProgressHUD showSuccessWithStatus:@"购买验证成功"];
            if (_paySuccessBlock) {
                _paySuccessBlock();
            }
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"购买验证失败"];
            if (_payFailureBlock) {
                _payFailureBlock();
            }
        }];
    }
    /*
    //发送网络POST请求，对购买凭据进行验证
    NSURL *url = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    //      NSURL *url = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
    //国内访问苹果服务器比较慢，timeoutInterval需要长一点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    request.HTTPMethod = @"POST";
    
    //在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
    //传输的是BASE64编码的字符串
    
    //BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
    //BASE64是可以编码和解码的
     
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = payloadData;

    //    提交验证请求，并获得官方的验证JSON结果
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                //比对字典中以下信息基本上可以保证数据安全
                //bundle_id&application_version&product_id&transaction_id
                //[SVProgressHUD showSuccessWithStatus:@"购买成功"];
//                NSString *enviroment = dict[@"environment"];
//                NSNumber *envi = [enviroment isEqualToString:@"Sandbox"] ? @(0) : @(1);
//                NSDictionary *receipt = dict[@"receipt"];
//                NSString *receiptString = [self dictionaryToJson:receipt];
                //NSLog(@"receiptString = %@",receiptString);
                
            }
            NSLog(@"%@", dict);
        } else {
            [SVProgressHUD showErrorWithStatus:@"购买失败"];
        }
    }];
    [task resume];
    */
}

//持久化存储用户购买凭证(这里最好还要存储当前日期，用户id等信息，用于区分不同的凭证)
- (void)saveReceipt {
    NSString *fileName = [self getUUIDString];
    NSString *savedPath = [NSString stringWithFormat:@"%@%@.plist", AppStoreInfoLocalFilePath, fileName];

    //验证凭据，获取到苹果返回的交易凭据
    //appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    //从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    //凭据存在
    if (receiptData) {
        NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSDictionary *dic = @{Key_Receipt : receiptString,
                              Key_OrderNo : _orderNo};
        [dic writeToFile:savedPath atomically:YES];
    }
}

- (void)sendFailedIapFiles {
    //搜索该目录下的所有文件和目录
    NSError *error = nil;
    NSArray *cacheFileNameArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:AppStoreInfoLocalFilePath error:&error];
    if (!error) {
        for (NSString *name in cacheFileNameArray) {
            //如果有plist后缀的文件，说明就是存储的购买凭证
            if ([name hasSuffix:@".plist"]) {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", AppStoreInfoLocalFilePath, name];
                [self sendAppStoreRequestBuyPlist:filePath];
            }
        }
    }
}

//验证receipt失败,App启动后再次验证
- (void)sendAppStoreRequestBuyPlist:(NSString *)plistPath {
    //NSString *path = [NSString stringWithFormat:@"%@%@", AppStoreInfoLocalFilePath, plistPath];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    //这里的参数请根据自己公司后台服务器接口定制，但是必须发送的是持久化保存购买凭证
    NSString *receipt = dic[Key_Receipt];
    NSString *orderNo = dic[Key_OrderNo];
    [NetworkTool verifyReceiptWithReceipt:receipt orderNo:orderNo success:^{
        [self removeIapFailedPath:plistPath];
    } failure:nil];
}

- (void)removeIapFailedPath:(NSString *)plistPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *path = [NSString stringWithFormat:@"%@/%@", AppStoreInfoLocalFilePath, plistPath];
//    if ([fileManager fileExistsAtPath:AppStoreInfoLocalFilePath]) {
//        [fileManager removeItemAtPath:AppStoreInfoLocalFilePath error:nil];
//    }
    
    if ([fileManager fileExistsAtPath:plistPath]) {
        [fileManager removeItemAtPath:plistPath error:nil];
    }
}

- (NSString *)getUUIDString {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end
