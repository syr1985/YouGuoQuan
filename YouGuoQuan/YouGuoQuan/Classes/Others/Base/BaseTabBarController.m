//
//  BaseTabBarController.m
//  ShakeAround
//
//  Created by erick on 15/11/18.
//  Copyright © 2015年 erick. All rights reserved.
//

#import "BaseTabBarController.h"
#import "OfficiallyCertifiedViewController.h"
#import "RechargeViewController.h"
#import "UserBaseInfoModel.h"

#import "UIView+SCFrame.h"
#import "XYTabBar.h"
#import <PopMenu.h>
#import "AlertViewTool.h"
#import "AuthorityTool.h"

@interface BaseTabBarController ()
@property (nonatomic, strong) PopMenu *popMenu;
@end

@implementation BaseTabBarController

- (PopMenu *)popMenu {
    if (!_popMenu) {
        NSArray *icons = @[@"发布商品", @"红包照片", @"发布微信", @"视频动态", @"图文动态", @"充值", @"发布-关闭"];
        if (![LoginData sharedLoginData].ope) {
            icons = @[@"视频动态", @"图文动态",@"充值", @"发布-关闭"];
        }
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:icons.count];
        
        NSUInteger index = 0;
        for (NSString *icon in icons) {
            MenuItem *menuItem = [MenuItem itemWithTitle:@"" iconName:icon];
            menuItem.index = index++;
            [items addObject:menuItem];
        }
        
        _popMenu = [[PopMenu alloc] initWithFrame:self.view.bounds items:items];
        _popMenu.menuAnimationType = kPopMenuAnimationTypeNetEase;
        
        __weak typeof(self) weakself = self;
        _popMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
            if (!selectedItem) {
                weakself.tabBarController.selectedIndex = 0;
            } else {
                if (![LoginData sharedLoginData].ope) {
                    switch (selectedItem.index) {
                        case 0:
                        {
                            [weakself presentViewControllerWithIdentifier:@"PublishVideo"];
                        }
                            break;
                        case 1:
                        {
                            [weakself presentViewControllerWithIdentifier:@"PublishTrends"];
                        }
                            break;
                        case 2:
                        {
                            [weakself presentViewControllerWithIdentifier:@"RechargeVC"];
                        }
                            break;
                        default:
                            weakself.tabBarController.selectedIndex = 0;
                            break;
                    }
                } else {
                    switch (selectedItem.index) {
                        case 0:
                        {
                            [weakself presentViewControllerWithIdentifier:@"PublishProduct"];
                        }
                            break;
                        case 1:
                        {
                            [weakself presentViewControllerWithIdentifier:@"PublishRedEnvelope"];
                        }
                            break;
                        case 2:
                        {
                            [weakself presentViewControllerWithIdentifier:@"PublishWeixin"];
                        }
                            break;
                        case 3:
                        {
                            [weakself presentViewControllerWithIdentifier:@"PublishVideo"];
                        }
                            break;
                        case 4:
                        {
                            [weakself presentViewControllerWithIdentifier:@"PublishTrends"];
                        }
                            break;
                        case 5:
                        {
                            [weakself presentViewControllerWithIdentifier:@"RechargeVC"];
                        }
                            break;
                        default:
                            weakself.tabBarController.selectedIndex = 0;
                            break;
                    }
                }
            }
        };
    }
    return _popMenu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.backgroundColor = RGBA(255, 255, 255, 0.9);
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    
    UIViewController *youguoVC  = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateInitialViewController];
    UIViewController *discoveVC = [[UIStoryboard storyboardWithName:@"Discovery" bundle:nil] instantiateInitialViewController];
    UIViewController *messageVC = [[UIStoryboard storyboardWithName:@"Message" bundle:nil] instantiateInitialViewController];
    UIViewController *profileVC = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateInitialViewController];
    
    [self createChildVCWithVC:youguoVC  Title:@"尤果" Image:@"主页-灰" SelectedImage:@"主页选中-橙"];
    
    [self createChildVCWithVC:discoveVC Title:@"发现" Image:@"发现-灰" SelectedImage:@"发现选中-橙"];
    
    [self createChildVCWithVC:messageVC Title:@"消息" Image:@"消息-灰" SelectedImage:@"消息选中-橙"];
    
    [self createChildVCWithVC:profileVC Title:@"个人" Image:@"我的-灰" SelectedImage:@"我的选中-橙"];
    
    __weak typeof(self) weakself = self;
    XYTabBar *tabBar = [[XYTabBar alloc] init];
    tabBar.publishButtonClickedBlock = ^{
        [weakself tabBarDidClickPlusButton];
    };
    [self setValue:tabBar forKey:@"tabBar"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUInteger count = self.tabBar.subviews.count;
    for (int i = 0; i< count; i++) {
        UIView *child = self.tabBar.subviews[i];
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.frameWidth = self.tabBar.frameWidth / count;
        }
    }
}

- (void)createChildVCWithVC:(UIViewController *)childVC Title:(NSString *)title Image:(NSString *)image SelectedImage:(NSString *)selectedimage {
    //设置子控制器的文字
    //等价于
    childVC.title = title;//同时设置tabbar和navigation的标题
    //设置文字的样式
    NSMutableDictionary *textAttrs = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *selectedtextAttrs = [[NSMutableDictionary alloc]init];
    textAttrs[NSForegroundColorAttributeName] = GaryFontColor;
    selectedtextAttrs[NSForegroundColorAttributeName] = NavTabBarColor;
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:selectedtextAttrs forState:UIControlStateSelected];
    //设置子控制器的图片
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //这句话的意思是声明这张图片按照原始的样子显示出来，不要自动渲染成其他颜色
    
    //给子控制器包装导航控制器
    [self addChildViewController:childVC];
}


- (void)tabBarDidClickPlusButton {
    if ([LoginData sharedLoginData].userId) {
        if (!self.popMenu.isShowed) {
            [self.popMenu showMenuAtView:[UIApplication sharedApplication].keyWindow showCloseButton:YES];
        }
    } else {
        UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *loginVC = [loginSB instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)presentViewControllerWithIdentifier:(NSString *)vcId {
    if ([vcId isEqualToString:@"RechargeVC"]) {
        UIStoryboard *walletSB = [UIStoryboard storyboardWithName:@"Wallet" bundle:nil];
        RechargeViewController *rechargeVC = [walletSB instantiateViewControllerWithIdentifier:vcId];
        rechargeVC.present = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rechargeVC];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        if ([self canPublishWithID:vcId]) {
            UIStoryboard *publishSB = [UIStoryboard storyboardWithName:@"Publish" bundle:nil];
            UINavigationController *publishVC = [publishSB instantiateViewControllerWithIdentifier:vcId];
            [self presentViewController:publishVC animated:YES completion:nil];
        } else {
            if ([vcId isEqualToString:@"PublishProduct"]) {
                [AuthorityTool publishProductPermissionDeniedFromViewController:self];
            } else {
                [AuthorityTool publishPermissionDeniedFromViewController:self];
            }
        }
    }
}

- (BOOL)canPublishWithID:(NSString *)vcId {
    if ([vcId isEqualToString:@"PublishProduct"]) {
        return  [LoginData sharedLoginData].star > 3 ||
                [LoginData sharedLoginData].audit == 1 ||
                [LoginData sharedLoginData].audit == 3;
    } else {
        return  [LoginData sharedLoginData].star > 2 ||
                [LoginData sharedLoginData].isRecommend ||
                [LoginData sharedLoginData].audit == 1 ||
                [LoginData sharedLoginData].audit == 3;
    }
}

@end
