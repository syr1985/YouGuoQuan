//
//  TakePhotoHelp.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/26.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "TakePhotoHelp.h"
#import <LCActionSheet.h>
#import <TZImagePickerController.h>
#import <TZImageManager.h>
#import "AlertViewTool.h"

@interface TakePhotoHelp () <LCActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, assign) BOOL       isCover;
//@property (nonatomic, assign) BOOL       isUploadOrignalPhoto;
//@property (nonatomic,   copy) NSString   *photosSize;
@end

@implementation TakePhotoHelp

static TakePhotoHelp *_instance;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)showActionSheetWithTitle:(NSString *)title viewController:(UIViewController *)vc returnBlock:(void (^)(BOOL, NSArray<UIImage *> *))result  {
    _selectedPhotosReturnBlock = [result copy];
    
    __weak typeof(self) weakself = self;
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:title
                                             cancelButtonTitle:@"取消"
                                                       clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                           NSArray *titleArray = @[@"设置封面",@"更换背景封面",@"修改头像"];
                                                           weakself.isCover = [titleArray containsObject:actionSheet.title];
                                                           if (buttonIndex == 1) {
                                                               [self openCameraTakePhotoOnViewController:vc];
                                                           } else if (buttonIndex == 2) {
                                                               int maxCount = weakself.isCover ? 1 : 9;
                                                               CGRect cropRect = CGRectMake(0, 0, WIDTH, WIDTH * 46 / 75);
                                                               if ( [actionSheet.title isEqualToString:@"修改头像"]) {
                                                                   cropRect = CGRectMake(0, 0, WIDTH, WIDTH);
                                                               }
                                                               [weakself openPhotoAlbum:maxCount viewController:vc cropRect:cropRect];
                                                           }
                                                       }
                                             otherButtonTitles:@"拍摄照片", @"从相册选取", nil];
    
    [actionSheet show];
}

- (void)showActionSheetWithTitle:(NSString *)title photosCount:(NSInteger)count viewController:(UIViewController *)vc returnBlock:(void (^)(BOOL, NSArray<UIImage *> *))result {
    _selectedPhotosReturnBlock = [result copy];
    
    __weak typeof(self) weakself = self;
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:title
                                             cancelButtonTitle:@"取消"
                                                       clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                           NSArray *titleArray = @[@"设置封面",@"更换背景封面",@"修改头像"];
                                                           weakself.isCover = [titleArray containsObject:actionSheet.title];
                                                           if (buttonIndex == 1) {
                                                               [weakself openCameraTakePhotoOnViewController:vc];
                                                           } else if (buttonIndex == 2) {
                                                               CGFloat rectH = WIDTH * 46 / 75;
                                                               CGFloat rectW = WIDTH;
                                                               if ([actionSheet.title isEqualToString:@"修改头像"]) {
                                                                   rectH = WIDTH;
                                                                   rectW = 0;
                                                               }
                                                               CGRect cropRect = CGRectMake(0, 0, rectW, rectH);
                                                               NSInteger maxCount = weakself.isCover ? 1 : (10 - count);
                                                               [weakself openPhotoAlbum:maxCount viewController:vc cropRect:cropRect];
                                                           }
                                                       }
                                             otherButtonTitles:@"拍摄照片", @"从相册选取", nil];
    
    [actionSheet show];
}

/**
 *  打开相册
 */
- (void)openPhotoAlbum:(NSInteger)maxImagesCount viewController:(UIViewController *)vc cropRect:(CGRect)rect {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount delegate:nil];
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowCrop = maxImagesCount == 1;
    imagePickerVc.cropRect = rect;
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakself = self;
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count) {
            //            NSMutableArray *muArray = [NSMutableArray array];
            //            for (PHAsset *asset in assets) {
            //                TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhoto];
            //                [muArray addObject:model];
            //            }
            
            //            [[TZImageManager manager] getPhotosBytesWithArray:muArray completion:^(NSString *totalBytes) {
            //                strongself.photosSize = totalBytes;
            //            }];
            
            if (weakself.selectedPhotosReturnBlock) {
                weakself.selectedPhotosReturnBlock(weakself.isCover, photos);
            }
        }
    };
    [vc presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 *  打开相机
 */
#pragma mark - Private Method
- (void)openCameraTakePhotoOnViewController:(UIViewController *)vc {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无权限 做一个友好的提示
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        NSString *message = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\""],appName];
        [AlertViewTool showAlertViewWithTitle:[NSBundle tz_localizedStringForKey:@"Can not use camera"]
                                      Message:message
                                  cancelTitle:[NSBundle tz_localizedStringForKey:@"Cancel"]
                                    sureTitle:[NSBundle tz_localizedStringForKey:@"Setting"]
                                    sureBlock:nil
                                  cancelBlock:nil];
    } else { // 调用相机
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerVc = [[UIImagePickerController alloc] init];
            imagePickerVc.delegate = self;
            imagePickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerVc.allowsEditing = YES;
            // set appearance / 改变相册选择页的导航栏外观
            imagePickerVc.navigationBar.barTintColor = vc.navigationController.navigationBar.barTintColor;
            imagePickerVc.navigationBar.tintColor = vc.navigationController.navigationBar.tintColor;
            UIBarButtonItem *tzBarItem, *BarItem;
            if (iOS9Later) {
                tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
                BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
            }
            [BarItem setTitleTextAttributes:[tzBarItem titleTextAttributesForState:UIControlStateNormal]
                                   forState:UIControlStateNormal];
            
            [vc presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        /**
         *  保存图片
         */
        [[TZImageManager manager] savePhotoWithImage:image completion:nil];
        
        if (self.selectedPhotosReturnBlock) {
            self.selectedPhotosReturnBlock(self.isCover, @[image]);
        }        
    }
}

@end
