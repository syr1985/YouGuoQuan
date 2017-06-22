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
#import <Photos/Photos.h>

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
                                                               [self openCameraTakePhotoOnViewController:vc forVideo:NO];
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
                                                               [weakself openCameraTakePhotoOnViewController:vc forVideo:NO];
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

- (void)showActionSheetForSelectVideoWithTitle:(NSString *)title viewController:(UIViewController *)vc returnBlock:(void (^)(UIImage *coverImage, id asset, double time))result {
    _selectedVideosReturnBlock = [result copy];
    
    __weak typeof(self) weakself = self;
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:title
                                             cancelButtonTitle:@"取消"
                                                       clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                           if (buttonIndex == 1) {
                                                               [weakself openCameraTakePhotoOnViewController:vc forVideo:YES];
                                                           } else if (buttonIndex == 2) {
                                                               [weakself openVideoAlbumWithViewController:vc];
                                                           }
                                                       }
                                             otherButtonTitles:@"拍摄视频", @"从资源库选取", nil];
    
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

- (void)openVideoAlbumWithViewController:(UIViewController *)vc {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingImage = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakself = self;
    imagePickerVc.didFinishPickingVideoHandle = ^(UIImage *coverImage, id asset) {
        [[TZImageManager manager] getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
            double time = CMTimeGetSeconds(playerItem.asset.duration);
            if (weakself.selectedVideosReturnBlock) {
                weakself.selectedVideosReturnBlock(coverImage, asset, time);
            }
        }];
    };
    
    [vc presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 *  打开相机
 */
#pragma mark - Private Method
- (void)openCameraTakePhotoOnViewController:(UIViewController *)vc forVideo:(BOOL)takeVideo {
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
            //            NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePickerVc.sourceType];
            //            NSLog(@"%@",mediaTypes);
            imagePickerVc.mediaTypes = takeVideo ? @[@"public.movie"] :@[@"public.image"];
            
            imagePickerVc.allowsEditing = YES;
            [imagePickerVc setVideoMaximumDuration:10.f];
            //            imagePickerVc.cameraCaptureMode = takeVideo ? UIImagePickerControllerCameraCaptureModeVideo : UIImagePickerControllerCameraCaptureModePhoto;
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
    } else if ([type isEqualToString:@"public.movie"]) {
        /**
         {
         UIImagePickerControllerMediaType = "public.movie";
         UIImagePickerControllerMediaURL = "file:///private/var/mobile/Containers/Data/Application/AC58F479-4150-47F7-8D0E-DFBA4C82C7C2/tmp/51953725964__C1B1BF9E-729B-432F-AB58-3D25FF1C2197.MOV";
         }
         */
        NSString *path = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}

// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [SVProgressHUD showInfoWithStatus:@"视频保存成功"];
        __weak typeof(self) weakself = self;
        [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:NO completion:^(TZAlbumModel *model) {
            if (model.models.count) {
                TZAssetModel *lastModel = [model.models firstObject];
                //            for (TZAssetModel *modell in model.models) {
                //                NSLog(@"%@",modell.asset);
                //                NSLog(@"%@",modell.timeLength);
                //            }
                [[TZImageManager manager] getPhotoWithAsset:lastModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                    [[TZImageManager manager] getVideoWithAsset:lastModel.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
                        double time = CMTimeGetSeconds(playerItem.asset.duration);
                        if (weakself.selectedVideosReturnBlock) {
                            weakself.selectedVideosReturnBlock(photo, lastModel.asset, time);
                        }
                    }];
                }];
            }
        }];
    } else {
        [SVProgressHUD showInfoWithStatus:@"视频保存失败"];
    }
}

@end
