//
//  PublishVideoViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/28.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PublishVideoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <TZImagePickerController.h>
#import <TZImageManager.h>
#import "AlertViewTool.h"
#import "TakePhotoHelp.h"

@interface PublishVideoViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectVideoButton;
@property (weak, nonatomic) IBOutlet UILabel  *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *publishVideoButton;
@property (weak, nonatomic) UILabel  *placeholder;
@property (nonatomic, strong) UIImage *videoCoverImage;
@property (nonatomic, strong) id asset;
@property (nonatomic,   copy) NSString *duration;

@end

@implementation PublishVideoViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BackgroundColor;
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.text = @"说点什么吧，这段话会被用作标题哦~";
    placeholder.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    placeholder.textColor = GaryFontColor;
    placeholder.frame = CGRectMake(5, 5, _titleTextView.frame.size.width - 10, 21);
    placeholder.backgroundColor = [UIColor clearColor];
    [self.titleTextView addSubview:placeholder];
    _placeholder = placeholder;
}

- (void)viewWillAppear:(BOOL)animated {
    if (![LoginData sharedLoginData].userId) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%s",__func__);
}

#pragma mark -
#pragma mark - 关闭页面
- (IBAction)dismissViewController {
    __weak typeof(self) weakself = self;
    [AlertViewTool showAlertViewWithTitle:nil Message:@"您确认放弃此次操作吗？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
        [weakself dismissViewControllerAnimated:YES completion:nil];
    } cancelBlock:nil];
}

- (IBAction)selectVideoButtonClicked {
    __weak typeof(self) weakself = self;
    [[TakePhotoHelp sharedInstance] showActionSheetForSelectVideoWithTitle:@"" viewController:self returnBlock:^(UIImage *coverImage, id asset, double time) {
        NSUInteger seconds = (NSUInteger)roundf(time) % 60;
        if (seconds > 10) {
            [SVProgressHUD showInfoWithStatus:@"视频时长限制在10秒以内"];
        } else {
            NSUInteger mintues = time / 60;
            weakself.asset = asset;
            weakself.videoCoverImage = coverImage;
            weakself.duration  = [NSString stringWithFormat:@"%lu:%02lu", (unsigned long)mintues, (unsigned long)seconds];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakself.publishVideoButton.enabled = weakself.titleTextView.text.length && weakself.videoCoverImage;
                [weakself.selectVideoButton setBackgroundImage:coverImage forState:UIControlStateNormal];
                [weakself.selectVideoButton setTitle:@"设置封面" forState:UIControlStateNormal];
                weakself.videoTimeLabel.text = [NSString stringWithFormat:@"视频时长：%@",weakself.duration];
            });
        }
    }];
}

- (IBAction)publishVideo:(UIButton *)sender {
    sender.enabled = NO;
    
    if (!self.titleTextView.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入文字描述"];
        return;
    }
    
    if (!self.videoCoverImage) {
        [SVProgressHUD showInfoWithStatus:@"请选择一个视频"];
        return;
    }
    
    __weak typeof(self) weakself = self;
    NSData *imageData = UIImageJPEGRepresentation(self.videoCoverImage, 0.8);
    [SVProgressHUD showWithStatus:@"发布视频"];
    [NetworkTool uploadImage:imageData
                    progress:nil
                     success:^(NSString *url) {
                         if ([weakself.asset isKindOfClass:[PHAsset class]]) {
                             [NetworkTool uploadVideoPHAssetToQiniu:weakself.asset
                                                           progress:nil
                                                            success:^(NSString *videoUrl) {
                                                                [self publishWithVideoURL:videoUrl coverURL:url];
                                                            } failure:^{
                                                                [self publishFailure];
                                                            }];
                         }
                     } failure:^{
                         [self publishFailure];
                     }];
}

- (void)publishWithVideoURL:(NSString *)videoUrl coverURL:(NSString *)url {
    //    if (videoUrl.length == 0) {
    //        [SVProgressHUD showInfoWithStatus:@"您的视频违反了相关规定，无法上传"];
    //        return;
    //    }
    [NetworkTool publishTrends:nil
                         intro:self.titleTextView.text
                         video:videoUrl
                         cover:url
                    trendsType:@"2"
                      duration:self.duration
                       success:^{
                           [self publishSuccess];
                       } failure:^{
                           [self publishFailure];
                       }];
}

- (void)publishSuccess {
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_PublishSuccess object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"发布视频成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)publishFailure {
    self.publishVideoButton.enabled = YES;
    [SVProgressHUD dismiss];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:@"发布视频失败"];
    });
}

#pragma mark - textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) { //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.view endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    if (textView.text.length > 0) {
        _placeholder.hidden = YES;
    }
    
    if (textView.text.length > 20) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        _placeholder.hidden = NO;
    } else {
        _placeholder.hidden = YES;
    }
    self.publishVideoButton.enabled = textView.text.length && self.videoCoverImage;
}

@end
