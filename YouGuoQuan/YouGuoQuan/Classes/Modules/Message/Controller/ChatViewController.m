//
//  ChatViewController.m
//  YouGuoQuan
//
//  Created by liushuai on 2016/12/16.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "ChatViewController.h"
#import <AVKit/AVKit.h>

#import <TZImagePickerController.h>
#import <TZImageManager.h>
#import "POISearchViewController.h"
#import "EaseLocationViewController.h"
#import "DateCategoryViewController.h"
#import "RewardViewController.h"
#import "ReportViewController.h"
#import "UserCenterViewController.h"

#import "EMCDDeviceManager+Media.h"
#import "EMCDDeviceManager+ProximitySensor.h"
#import "UIViewController+HUD.h"
#import "NSDate+Category.h"

#import "EaseMessageReadManager.h"
#import "EaseChatToolbar.h"

#import "EaseBaseMessageCell.h"
#import "EaseMessageTimeCell.h"
#import "EaseRedPacketCell.h"
#import "EaseSnapViewCell.h"

#import "EaseLocalDefine.h"
#import "EaseSDKHelper.h"
#import "MoreMenuHelp.h"
#import "PhotoBrowserHelp.h"
#import "AlertViewTool.h"
#import "EaseEmotion.h"
#import <MJRefresh.h>
#import "JZLocationConverter.h"
#import <IQKeyboardManager.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "PayTool.h"

NSString * const Flag_BlackTips = @"black";     // 被拉黑提示消息的扩展key,根据这个判断是不是拉黑提示的消息
NSString * const Flag_Redpacket = @"Redpacket"; // 打赏消息的扩展key,根据这个判断是不是打赏的消息

//EMCDDeviceManagerDelegate,
@interface ChatViewController () <EaseMessageCellDelegate, EMChatManagerDelegate, EMChatToolbarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    dispatch_queue_t _messageQueue;
}
// tableView
@property (strong, nonatomic) UITableView *tableView;
// EMMessage类型的消息列表
@property (strong, nonatomic) NSMutableArray *msgsArray;
// 包括消息以及时间
@property (strong, nonatomic) NSMutableArray *dataArray;
// 聊天的会话对象
@property (strong, nonatomic) EMConversation *conversation;
// 时间间隔标记
@property (nonatomic, assign) NSTimeInterval messageTimeIntervalTag;
// 是否滚动到最后一条
@property (nonatomic, assign) BOOL scrollToBottomWhenAppear; //default YES;
// 页面是否处于显示状态
@property (nonatomic, assign) BOOL isViewDidAppear;
// 底部输入控件
@property (nonatomic, strong) EaseChatToolbar *chatToolbar;

@property (nonatomic, strong) UIMenuController *menuController;
@property (nonatomic, strong) UIMenuItem *delMenuItem;
@property (nonatomic, strong) UIMenuItem *cpyMenuItem;
@property (nonatomic, strong) id<IMessageModel> menuModel;
@end

@implementation ChatViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //停止音频播放及播放动画
    [[EMClient sharedClient] removeDelegate:self];
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    //[EMCDDeviceManager sharedInstance].delegate = nil;
}

#pragma mark - 懒加载
- (EaseChatToolbar *)chatToolbar {
    if (!_chatToolbar) {
        CGFloat chatbarH = [EaseChatToolbar defaultHeight];
        CGFloat chatbarY = self.view.frame.size.height - chatbarH;
        CGFloat chatbarW = self.view.frame.size.width;
        _chatToolbar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, chatbarY, chatbarW, chatbarH)
                                                         type:EMChatToolbarTypeChat];
        _chatToolbar.delegate = self;
        
        CGRect tableFrame = self.tableView.frame;
        tableFrame.size.height = chatbarY;
        self.tableView.frame = tableFrame;
    }
    return _chatToolbar;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSMutableArray *)msgsArray {
    if (!_msgsArray) {
        _msgsArray = [NSMutableArray new];
    }
    return _msgsArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BackgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    }
    return _tableView;
}

#pragma mark - setter
- (void)setIsViewDidAppear:(BOOL)isViewDidAppear {
    _isViewDidAppear = isViewDidAppear;
    if (_isViewDidAppear) {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.msgsArray) {
            if ([self shouldSendHasReadAckForMessage:message read:NO]) {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count]) {
            [self sendHasReadResponseForMessages:unreadMessages isRead:YES];
        }
        [_conversation markAllMessagesAsRead:nil];
    }
}

#pragma mark - 控制器初始化
- (instancetype)initWithConversationChatter:(NSString *)conversationId userInfo:(NSDictionary *)target {
    if ([conversationId length] == 0) {
        return nil;
    }
    
    if (self = [super init]) {
        _conversation = [[EMClient sharedClient].chatManager getConversation:conversationId
                                                                        type:EMConversationTypeChat
                                                            createIfNotExist:YES];
        _conversation.ext = @{Key_Conversation_Ext : target};
        _messageTimeIntervalTag = -1;
        _scrollToBottomWhenAppear = YES;
        [_conversation markAllMessagesAsRead:nil];
    }
    return self;
}

- (instancetype)initWithConversation:(EMConversation *)conversation {
    if (self = [super init]) {
        _conversation = conversation;
        NSDictionary *infoDict = conversation.ext[Key_Conversation_Ext];
        self.titleString = infoDict[@"nickName"];
        _messageTimeIntervalTag = -1;
        _scrollToBottomWhenAppear = YES;
        [_conversation markAllMessagesAsRead:nil];
    }
    return self;
}

#pragma mark - 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [self configeViewController];
    
    [self configeDelegate];
    
    [self configeNotification];
    
    [self configeGestureRecognizer];
    
    [self configeTableViewHeader];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    self.isViewDidAppear = YES;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:NO];
    
    if (self.scrollToBottomWhenAppear) {
        [self _scrollViewToBottom:NO];
    }
    self.scrollToBottomWhenAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    self.isViewDidAppear = NO;
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自定义方法
- (void)configeViewController {
    self.view.backgroundColor = BackgroundColor;
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.chatToolbar];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(popupShowMoreMenu)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.tintColor = FontColor;
    self.navigationController.navigationBar.backgroundColor = NavBackgroundColor;
}

- (void)configeDelegate {
    _messageQueue = dispatch_queue_create("hyphenate.com", NULL);//DISPATCH_QUEUE_CONCURRENT
    //Register the delegate
    //[EMCDDeviceManager sharedInstance].delegate = self;
    [[EMClient sharedClient].chatManager addDelegate:self];
}

- (void)configeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)didBecomeActive {
    self.dataArray = [[self formatMessages:self.msgsArray] mutableCopy];
    [self.tableView reloadData];
    
    if (self.isViewDidAppear) {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.msgsArray) {
            if ([self shouldSendHasReadAckForMessage:message read:NO]) {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count]) {
            [self sendHasReadResponseForMessages:unreadMessages isRead:YES];
        }
        [_conversation markAllMessagesAsRead:nil];
    }
}

#pragma mark - 导航按钮方法
- (void)popupShowMoreMenu {
    [self.chatToolbar endEditing:YES];
    
    __weak typeof(self) weakself = self;
    [MoreMenuHelp showMoreMenuWithCancel:^(NSUInteger buttonIndex) {
        // 举报操作
        NSDictionary *infoDict = self.conversation.ext[Key_Conversation_Ext];
        NSString *userId = infoDict[@"userId"];
        if (buttonIndex == 1) {
            UIStoryboard *discoverySB = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
            ReportViewController *reportVC = [discoverySB instantiateViewControllerWithIdentifier:@"Report"];
            reportVC.aboutId = userId;
            reportVC.reportType = ReportType_Person;
            reportVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [weakself presentViewController:reportVC animated:YES completion:nil];
        } else if (buttonIndex == 2) {
            [AlertViewTool showAlertViewWithTitle:nil Message:@"拉黑对方后，对方将无法与您聊天，您也无法查看对方动态，是否继续？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
                // 拉黑操作
                [NetworkTool doOperationWithType:@"3" userId:userId operationType:@"1" success:^{
                    [SVProgressHUD showSuccessWithStatus:@"已将对方拉黑"];
                }];
            } cancelBlock:nil];
        }
    }];
}

- (void)configeGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(keyBoardHidden:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - 手势处理
- (void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer {
    [self.chatToolbar endEditing:YES];
}

- (void)configeTableViewHeader {
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadMoreData)];
    // 设置文字
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置刷新控件
    self.tableView.mj_header = header;
}

- (void)loadMoreData {
    NSString *messageId = nil;
    if (self.msgsArray.count != 0) {
        messageId = [(EMMessage *)self.msgsArray.firstObject messageId];
    }
    [self loadMessagesBefore:messageId append:YES];
    
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - 加载某条消息之前的消息数据
- (void)loadMessagesBefore:(NSString*)messageId append:(BOOL)isAppend {
    __weak typeof(self) weakSelf = self;
    void (^refresh)(NSArray *messages) = ^(NSArray *messages) {
        dispatch_async(_messageQueue, ^{
            //Format the message
            NSArray *formatMsgs = [weakSelf formatMessages:messages];
            //Refresh the page
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    NSInteger scrollToIndex = 0;
                    if (isAppend) {
                        [strongSelf.msgsArray insertObjects:messages
                                                  atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, messages.count)]];
                        
                        //Combine the message
                        id object = [strongSelf.dataArray firstObject];
                        if ([object isKindOfClass:[NSString class]]) {
                            NSString *timestamp = object;
                            [formatMsgs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                                if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model]) {
                                    [strongSelf.dataArray removeObjectAtIndex:0];
                                    *stop = YES;
                                }
                            }];
                        }
                        scrollToIndex = strongSelf.dataArray.count;
                        [strongSelf.dataArray insertObjects:formatMsgs
                                                  atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, formatMsgs.count)]];
                    } else {
                        [strongSelf.msgsArray removeAllObjects];
                        [strongSelf.msgsArray addObjectsFromArray:messages];
                        
                        [strongSelf.dataArray removeAllObjects];
                        [strongSelf.dataArray addObjectsFromArray:formatMsgs];
                    }
                    
                    EMMessage *latest = [strongSelf.msgsArray lastObject];
                    strongSelf.messageTimeIntervalTag = latest.timestamp;
                    
                    [strongSelf.tableView reloadData];
                    [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:strongSelf.dataArray.count - scrollToIndex - 1 inSection:0]
                                                atScrollPosition:UITableViewScrollPositionTop
                                                        animated:NO];
                }
            });
            
            //re-download all messages that are not successfully downloaded
            for (EMMessage *message in messages) {
                [weakSelf downloadMessageAttachments:message];
            }
            
            //send the read acknoledgement
            [weakSelf sendHasReadResponseForMessages:messages isRead:NO];
        });
    };
    
    [self.conversation loadMessagesStartFromId:messageId
                                         count:20
                               searchDirection:EMMessageSearchDirectionUp
                                    completion:^(NSArray *aMessages, EMError *aError) {
                                        if (!aError && aMessages.count) {
                                            refresh(aMessages);
                                        }
                                    }];
}

#pragma mark - 加载数据时，如果消息没下载成功，则重新下载
- (void)downloadMessageAttachments:(EMMessage *)message {
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error) {
            [weakSelf reloadTableViewDataWithMessage:message];
        } else {
            [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    EMMessageBody *messageBody = message.body;
    if ([messageBody type] == EMMessageBodyTypeImage) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus != EMDownloadStatusSuccessed) {
            //download the message thumbnail
            [[[EMClient sharedClient] chatManager] downloadMessageThumbnail:message progress:nil completion:completion];
        }
    } else if ([messageBody type] == EMMessageBodyTypeVideo) {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus != EMDownloadStatusSuccessed) {
            //download the message thumbnail
            [[[EMClient sharedClient] chatManager] downloadMessageThumbnail:message progress:nil completion:completion];
        }
    } else if ([messageBody type] == EMMessageBodyTypeVoice) {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.downloadStatus != EMDownloadStatusSuccessed) {
            //download the message attachment
            [[EMClient sharedClient].chatManager downloadMessageAttachment:message progress:nil completion:^(EMMessage *message, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:message];
                } else {
                    [weakSelf showHint:NSEaseLocalizedString(@"message.voiceFail", @"voice for failure!")];
                }
            }];
        }
    }
}

#pragma mark - private helper
- (void)_scrollViewToBottom:(BOOL)animated {
    if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (NSURL *)_convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [EMCDDeviceManager dataPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            //NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    return mp4Url;
}

- (BOOL)shouldSendHasReadAckForMessage:(EMMessage *)message read:(BOOL)read {
    NSString *account = [[EMClient sharedClient] currentUsername];
    if (message.chatType != EMChatTypeChat // 是不是聊天，这边是0
        || message.isReadAcked // 消息状态是不是已读
        || [account isEqualToString:message.from] // 是不是自己发的消息
        || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) // 应用在不在后台
        || !self.isViewDidAppear) {
        return NO;
    }
    
    EMMessageBody *body = message.body;
    if ([message.ext[Flag_Snap] boolValue]) {
        if ((body.type == EMMessageBodyTypeText) &&
            !read) {
            return NO;
        }
    }
    
    if (((body.type == EMMessageBodyTypeVideo) ||
         (body.type == EMMessageBodyTypeVoice) ||
         (body.type == EMMessageBodyTypeImage)) &&
        !read) {
        return NO;
    } else {
        return YES;
    }
}

- (void)sendHasReadResponseForMessages:(NSArray*)messages isRead:(BOOL)isRead {
    NSMutableArray *unreadMessages = [NSMutableArray array];
    for (NSInteger i = 0; i < [messages count]; i++) {
        EMMessage *message = messages[i];
        if ([self shouldSendHasReadAckForMessage:message read:isRead]) {
            [unreadMessages addObject:message];
        }
    }
    
    if ([unreadMessages count]) {
        for (EMMessage *message in unreadMessages) {
            [[EMClient sharedClient].chatManager sendMessageReadAck:message completion:nil];
        }
    }
}

#pragma mark - Table view data source & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        //time cell
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *timeCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (timeCell == nil) {
            timeCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        timeCell.title = object;
        return timeCell;
    } else {
        __weak typeof(self) weakself = self;
        id<IMessageModel> model = object;
        if ([model.message.ext[Flag_Snap] boolValue]) {
            NSString *CellIdentifier = [EaseSnapViewCell cellIdentifierWithModel:model];
            EaseSnapViewCell *snapCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!snapCell) {
                snapCell = [[EaseSnapViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:CellIdentifier
                                                             model:model];
                snapCell.delegate = self;
            }
            
            snapCell.deleteMessageBolckWithModel = ^(id<IMessageModel> model) {
                [weakself deleteMessageModel:model.messageId];
            };
            
            snapCell.sendMessageReadBolckWithModel = ^(id<IMessageModel> model) {
                [[EMClient sharedClient].chatManager sendMessageReadAck:model.message completion:nil];
                
                model.isMessageRead = YES;
                NSInteger row = [weakself.dataArray indexOfObject:model];
                if (row != NSNotFound) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                    [weakself.tableView beginUpdates];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath]
                                              withRowAnimation:UITableViewRowAnimationNone];
                    [weakself.tableView endUpdates];
                }
            };
            
            snapCell.model = model;
            
            if (!model.isSender) {
                if (_conversation.ext) {
                    snapCell.infoDict = _conversation.ext[Key_Conversation_Ext];
                }
            }
            return snapCell;
        } else if ([model.message.ext[Flag_BlackTips] boolValue]) {
            NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
            EaseMessageTimeCell *timeCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
            
            if (timeCell == nil) {
                timeCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:TimeCellIdentifier];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            timeCell.title = model.text;
            return timeCell;
        } else if ([model.message.ext[Flag_Redpacket] boolValue]) {
            // 红包
            NSString *redCellIdentifier = [EaseRedPacketCell cellIdentifier];
            EaseRedPacketCell *redCell = (EaseRedPacketCell *)[tableView dequeueReusableCellWithIdentifier:redCellIdentifier];
            
            if (redCell == nil) {
                redCell = [[EaseRedPacketCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:redCellIdentifier];
                redCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            redCell.model = model;
            return redCell;
        } else {
            NSString *CellIdentifier = [EaseMessageCell cellIdentifierWithModel:model];
            EaseBaseMessageCell *sendCell = (EaseBaseMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (sendCell == nil) {
                sendCell = [[EaseBaseMessageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:CellIdentifier
                                                                model:model];
                sendCell.delegate = self;
            }
            
            sendCell.longPressBlock =^(id<IMessageModel> model, EaseBubbleView *bubbleView) {
                weakself.menuModel = model;
                
                if (!weakself.menuController) {
                    weakself.menuController = [UIMenuController sharedMenuController];
                }
                
                if (!weakself.delMenuItem) {
                    weakself.delMenuItem = [[UIMenuItem alloc] initWithTitle:NSEaseLocalizedString(@"delete", @"Delete")
                                                                      action:@selector(deleteMenuAction)];
                }
                
                if (!weakself.cpyMenuItem) {
                    weakself.cpyMenuItem = [[UIMenuItem alloc] initWithTitle:NSEaseLocalizedString(@"copy", @"Copy")
                                                                      action:@selector(copyMenuAction)];
                }
                
                if (model.bodyType == EMMessageBodyTypeText) {
                    [weakself.menuController setMenuItems:@[weakself.cpyMenuItem, weakself.delMenuItem]];
                } else {
                    [weakself.menuController setMenuItems:@[weakself.delMenuItem]];
                }
                [weakself.menuController setTargetRect:bubbleView.frame inView:bubbleView.superview];
                [weakself.menuController setMenuVisible:YES animated:YES];
            };
            
            sendCell.model = model;
            
            if (!model.isSender) {
                if (_conversation.ext) {
                    sendCell.infoDict = _conversation.ext[Key_Conversation_Ext];
                }
            }
            return sendCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = self.dataArray[indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        return 40;
    } else {
        id<IMessageModel> model = object;
        if ([model.message.ext[Flag_Redpacket] boolValue]) {
            return 40;
        } else if ([model.message.ext[Flag_Snap] boolValue]) {
            return [EaseSnapViewCell cellHeightWithModel:model];
        } else {
            return [EaseBaseMessageCell cellHeightWithModel:model];
        }
    }
}

#pragma mark - 长按菜单方法
- (void)copyMenuAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.menuModel.text;
}

- (void)deleteMenuAction {
    [self deleteMessageModel:self.menuModel.messageId];
}

- (void)deleteMessageModel:(NSString *)messageId {
    EMError *error = nil;
    [self.conversation deleteMessageWithId:messageId error:&error];
    if (!error) {
        __block NSInteger rowInMsgArray = NSNotFound;
        [self.msgsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EMMessage *message = (EMMessage *)obj;
            if ([messageId isEqualToString:message.messageId]) {
                rowInMsgArray = idx;
                *stop = YES;
            }
        }];
        if (rowInMsgArray != NSNotFound) {
            [self.msgsArray removeObjectAtIndex:rowInMsgArray];
        }
        
        __block NSInteger row = NSNotFound;
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj conformsToProtocol:@protocol(IMessageModel)]) {
                id<IMessageModel> message = (id<IMessageModel>)obj;
                if ([messageId isEqualToString:message.messageId]) {
                    row = idx;
                    *stop = YES;
                }
            }
        }];
        if (row != NSNotFound) {
            NSRange range = {row, 1};
            NSMutableArray *indexPaths = [NSMutableArray array];
            [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            id preModel = self.dataArray[row - 1];
            if (row == self.dataArray.count - 1) {
                if ([preModel isKindOfClass:[NSString class]]) {
                    range.location = row - 1;
                    range.length = 2;
                    [indexPaths addObject:[NSIndexPath indexPathForRow:row - 1 inSection:0]];
                }
            } else {
                id nextModel = self.dataArray[row + 1];
                if ([preModel isKindOfClass:[NSString class]] && [nextModel isKindOfClass:[NSString class]]) {
                    range.location = row - 1;
                    range.length = 2;
                    [indexPaths addObject:[NSIndexPath indexPathForRow:row - 1 inSection:0]];
                }
            }
            //[self.msgsArray removeObject:model.message];
            [self.dataArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
    }
}

#pragma mark - EaseMessageCellDelegate
// 只处理图片、声音、视频、位置、文件的cell
- (void)messageCellSelected:(id<IMessageModel>)model sourceView:(UIImageView *)tapView {
    switch (model.bodyType) {
        case EMMessageBodyTypeImage:
        {
            [self _imageMessageCellSelected:model sourceView:tapView];
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            [self _locationMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            [self _audioMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            [self _videoMessageCellSelected:model];
        }
            break;
        default:
            break;
    }
}

- (void)_locationMessageCellSelected:(id<IMessageModel>)model {
    _scrollToBottomWhenAppear = NO;
    
    EaseLocationViewController *locationController = [[EaseLocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)_imageMessageCellSelected:(id<IMessageModel>)model sourceView:(UIImageView *)tapView {
    _scrollToBottomWhenAppear = NO;
    __weak typeof(self) weakSelf = self;
    EMImageMessageBody *imageBody = (EMImageMessageBody*)model.message.body;
    if (imageBody.type == EMMessageBodyTypeImage) {
        if (imageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
            if (imageBody.downloadStatus == EMDownloadStatusSuccessed) {
                // send the acknowledgement
                [weakSelf sendHasReadResponseForMessages:@[model.message] isRead:YES];
                if ([model.message.ext[Flag_Snap] boolValue] && !model.isSender) {
                    [PhotoBrowserHelp openPhotoBrowserWithImages:@[model.fileURLPath] sourceImageView:tapView];
                    [self deleteMessageModel:model.messageId];
                    return;
                }
                // open photo browser
                NSString *localPath = model.message == nil ? model.fileLocalPath : [imageBody localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    if (image) {
                        [PhotoBrowserHelp openPhotoBrowserWithImageArray:@[image] sourceImageView:tapView];
                    } else {
                        [PhotoBrowserHelp openPhotoBrowserWithImages:@[model.fileURLPath] sourceImageView:tapView];
                    }
                    return;
                }
            }
            [weakSelf showHudInView:weakSelf.view hint:NSEaseLocalizedString(@"message.downloadingImage", @"downloading a image...")];
            [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
                [weakSelf hideHud];
                if (!error) {
                    //send the acknowledgement
                    [weakSelf sendHasReadResponseForMessages:@[model.message] isRead:YES];
                    if ([model.message.ext[Flag_Snap] boolValue] && !model.isSender) {
                        [PhotoBrowserHelp openPhotoBrowserWithImages:@[model.fileURLPath] sourceImageView:tapView];
                        [weakSelf deleteMessageModel:model.messageId];
                        return;
                    }
                    NSString *localPath = message == nil ? model.fileLocalPath : [(EMImageMessageBody*)message.body localPath];
                    if (localPath && localPath.length) {
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        if (image) {
                           [PhotoBrowserHelp openPhotoBrowserWithImageArray:@[image] sourceImageView:tapView];
                        }
                    }
                } else {
                    [weakSelf showHint:NSEaseLocalizedString(@"message.imageFail", @"image for failure!")];
                }
            }];
        } else {
            //get the message thumbnail
            [[EMClient sharedClient].chatManager downloadMessageThumbnail:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                } else {
                    [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            }];
        }
    }
}

- (void)_audioMessageCellSelected:(id<IMessageModel>)model {
    _scrollToBottomWhenAppear = NO;
    EMVoiceMessageBody *body = (EMVoiceMessageBody*)model.message.body;
    EMDownloadStatus downloadStatus = [body downloadStatus];
    if (downloadStatus == EMDownloadStatusDownloading) {
        [self showHint:NSEaseLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        return;
    } else if (downloadStatus == EMDownloadStatusFailed) {
        [self showHint:NSEaseLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:nil];
        return;
    }
    
    // play the audio
    if (model.bodyType == EMMessageBodyTypeVoice) {
        //send the acknowledgement
        [self sendHasReadResponseForMessages:@[model.message] isRead:YES];
        __weak typeof(self) weakSelf = self;
        BOOL isPrepare = [[EaseMessageReadManager defaultManager] prepareMessageAudioModel:model updateViewCompletion:^(EaseMessageModel *prevAudioModel, EaseMessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            __weak typeof(self) weakSelf = self;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.fileLocalPath completion:^(NSError *error) {
                [[EaseMessageReadManager defaultManager] stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                    
                    // 播放结束后删除阅后即焚声音消息
                    if (!model.isSender) {
                        if ([model.message.ext[Flag_Snap] boolValue]) {
                            //#warning - delete voice message
                            [weakSelf deleteMessageModel:model.messageId];
                        }
                    }
                });
            }];
        }
    }
}

- (void)_videoMessageCellSelected:(id<IMessageModel>)model {
    _scrollToBottomWhenAppear = NO;
    
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)model.message.body;
    NSString *localPath = [model.fileLocalPath length] > 0 ? model.fileLocalPath : videoBody.localPath;
    if ([localPath length] == 0) {
        [self showHint:NSEaseLocalizedString(@"message.videoFail", @"video for failure!")];
        return;
    }
    
    __weak typeof(self) weakself = self;
    dispatch_block_t block = ^{
        //send the acknowledgement
        [weakself sendHasReadResponseForMessages:@[model.message] isRead:YES];
        
        NSURL *videoURL = [NSURL fileURLWithPath:localPath];
        AVPlayerViewController *avPlayerVC = [[AVPlayerViewController alloc] init];
        avPlayerVC.player = [[AVPlayer alloc] initWithURL:videoURL];
        [weakself presentViewController:avPlayerVC animated:YES completion:nil];
    };
    
    __weak typeof(self) weakSelf = self;
    if (videoBody.thumbnailDownloadStatus == EMDownloadStatusFailed || ![[NSFileManager defaultManager] fileExistsAtPath:videoBody.thumbnailLocalPath]) {
        [self showHint:@"开始下载图片, 请稍后点击"];
        [[EMClient sharedClient].chatManager downloadMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
            if (!error) {
                [weakSelf reloadTableViewDataWithMessage:aMessage];
            } else {
                [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
            }
        }];
        return;
    }
    
    if (videoBody.downloadStatus == EMDownloadStatusSuccessed && [[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        block();
        return;
    }
    
    [self showHudInView:self.view hint:NSEaseLocalizedString(@"message.downloadingVideo", @"downloading video...")];
    [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            block();
        } else {
            [weakSelf showHint:NSEaseLocalizedString(@"message.videoFail", @"video for failure!")];
        }
    }];
}

- (void)statusButtonSelcted:(id<IMessageModel>)model withMessageCell:(EaseMessageCell*)messageCell {
    if ((model.messageStatus != EMMessageStatusFailed) && (model.messageStatus != EMMessageStatusPending)) {
        return;
    }
    __weak typeof(self) weakself = self;
    [[[EMClient sharedClient] chatManager] resendMessage:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            [weakself refreshAfterSentMessage:message];
        } else {
            NSString *errorDesc = @"";
            switch (error.code) {
                case EMErrorServerNotReachable:
                    errorDesc = @"服务器未连接";
                    break;
                case EMErrorServerTimeout:
                    errorDesc = @"服务器未连接";
                    break;
                case EMErrorServerBusy:
                    errorDesc = @"服务器忙碌";
                    break;
                case EMErrorFileNotFound:
                    errorDesc = @"文件没有找到";
                    break;
                case EMErrorFileInvalid:
                    errorDesc = @"文件无效";
                    break;
                default:
                    break;
            }
            [SVProgressHUD showErrorWithStatus:errorDesc];
            [weakself.tableView reloadData];
        }
    }];
}

- (void)avatarViewSelcted:(id<IMessageModel>)model {
    _scrollToBottomWhenAppear = NO;
    
    if (model.isSender) {
        self.tabBarController.selectedIndex = 3;
    } else {
        NSDictionary *userInfo = _conversation.ext[Key_Conversation_Ext];
        NSString *otherId = userInfo[@"userId"];
        UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
        UserCenterViewController *userCenterVC = [otherSB instantiateViewControllerWithIdentifier:@"UserCenter"];
        userCenterVC.userId = otherId;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - EMChatToolbarDelegate

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight {
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = weakself.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = weakself.view.frame.size.height - toHeight;
        weakself.tableView.frame = rect;
    }];
    
    [self _scrollViewToBottom:NO];
}

- (void)inputTextViewWillBeginEditing:(EaseTextView *)inputTextView {
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    [_menuController setMenuItems:nil];
}

#pragma mark - 发送文本消息
- (void)didSendText:(NSString *)text {
    if (text && text.length) {
        [self sendTextMessage:text];
    }
}

#pragma mark - 发送emoj表情符号
- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext {
    if ([ext objectForKey:EASEUI_EMOTION_DEFAULT_EXT]) {
        EaseEmotion *emotion = [ext objectForKey:EASEUI_EMOTION_DEFAULT_EXT];
        [self sendTextMessage:emotion.emotionTitle
                      withExt:@{MESSAGE_ATTR_EXPRESSION_ID:emotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)}];
        return;
    }
    if (text && text.length > 0) {
        [self sendTextMessage:text withExt:ext];
    }
}

#pragma mark - 录音
#pragma mark - 开始录音
- (void)didStartRecordingVoiceAction:(UIView *)recordView {
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:nil];
}

#pragma mark - 取消录音
- (void)didCancelRecordingVoiceAction:(UIView *)recordView {
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

#pragma mark - 完成录音并发送消息
- (void)didFinishRecoingVoiceAction:(UIView *)recordView {
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            [weakSelf sendVoiceMessageWithLocalPath:recordPath duration:aDuration];
        }
        else {
            [weakSelf showHudInView:weakSelf.view hint:error.domain];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
            });
        }
    }];
}

#pragma mark - YGSelectPicViewDelegate
- (void)didTapAlbum:(YGSelectPicView *)selectPicView {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:nil];
    imagePickerVc.selectedModels  = selectPicView.selectModels;
    imagePickerVc.isSelectOriginalPhoto = selectPicView.shouldSendOriginPhoto;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingVideo = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakself = self;
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        __strong typeof(self) strongself = weakself;
        if (photos.count) {
            if (isSelectOriginalPhoto) {
                for (id asset in assets) {
                    [[TZImageManager manager] getOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info) {
                        [strongself sendImageMessageWithData:data];
                    }];
                }
            } else {
                for (UIImage *image in photos) {
                    NSData *imageData = UIImagePNGRepresentation(image);
                    [strongself sendImageMessageWithData:imageData];
                }
            }
        }
    };
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - 发送图片消息
- (void)didSendPic:(YGSelectPicView *)selectPicView {
    [self.view endEditing:YES];
    __weak typeof(self) weakself = self;
    for (TZAssetModel *assetModel in selectPicView.selectModels) {
        if (selectPicView.shouldSendOriginPhoto) {
            [[TZImageManager manager] getOriginalPhotoDataWithAsset:assetModel.asset completion:^(NSData *data, NSDictionary *info) {
                [weakself sendImageMessageWithData:data];
            }];
        } else {
            [[TZImageManager manager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                if (!isDegraded) {
                    NSData *imageData = UIImagePNGRepresentation(photo);
                    [weakself sendImageMessageWithData:imageData];
                }
            }];
        }
    }
}

#pragma mark - 预览相册图片
- (void)previewPic:(YGSelectPicView *)selectPicView atIndex:(NSInteger)index {
    [self didTapAlbum:selectPicView];
}

#pragma mark - 发红包
- (void)showSendBonusController {
    NSDictionary *infoDict = _conversation.ext[Key_Conversation_Ext];
    UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
    RewardViewController *rewardVC = [otherSB instantiateViewControllerWithIdentifier:@"Reward"];
    rewardVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    rewardVC.userID  = infoDict[@"userId"];
    rewardVC.rType = @"hb";
    __weak typeof(self) weakself = self;
    rewardVC.payForReward = ^(NSNumber *amount, NSString *payType, NSString *orderNo) {
        NSString *message = [NSString stringWithFormat:@"本次消费您需支付%@ u币，确定支付？",amount];
        [AlertViewTool showAlertViewWithTitle:nil Message:message cancelTitle:@"取消" sureTitle:@"零钱支付" sureBlock:^{
            [weakself payByWalletWithOrderNo:orderNo payMethod:payType amount:amount];
        } cancelBlock:^{
            
        }];
    };
    [self presentViewController:rewardVC animated:YES completion:nil];
}

- (void)payByWalletWithOrderNo:(NSString *)orderNo payMethod:(NSString *)payType amount:(NSNumber *)amount {
    [NetworkTool payForRewardWithOrderNo:orderNo success:^{
        EMMessage *message = [EaseSDKHelper sendTextMessage:amount.stringValue
                                                         to:self.conversation.conversationId
                                                messageType:EMChatTypeChat
                                                 messageExt:@{Flag_Redpacket:@YES}];
        [self sendMessage:message];
    } failure:^(NSError *error, NSString *msg){
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        } else if ([msg isEqualToString:@"金额不足"]) {
            [PayTool payFailureTranslateToRechargeVC:self rechargeSuccess:^{
                [self payByWalletWithOrderNo:orderNo payMethod:payType amount:amount];
            } rechargeFailure:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"打赏失败"];
        }
    }];
}


#pragma mark - 定位位置
- (void)actionChooseLocation {
    [self.chatToolbar endEditing:YES];
    
    UIStoryboard *messageSB = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    POISearchViewController *chooseVC = [messageSB instantiateViewControllerWithIdentifier:@"POISearchVC"];
    __weak typeof(self) weakself = self;
    chooseVC.sendLocationInfo = ^(AMapPOI *poi, NSString *mapImageURL) {
        
        NSDictionary *ext = @{@"DetailAddress":poi.address,
                              @"MapViewImage":mapImageURL};
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        CLLocationCoordinate2D coordinate = [JZLocationConverter gcj02ToBd09:location];
        EMMessage *message = [EaseSDKHelper sendLocationMessageWithLatitude:coordinate.latitude
                                                                  longitude:coordinate.longitude
                                                                    address:poi.name
                                                                         to:weakself.conversation.conversationId
                                                                messageType:EMChatTypeChat
                                                                 messageExt:ext];
        [weakself sendMessage:message];
    };
    [self.navigationController pushViewController:chooseVC animated:YES];
}

#pragma mark - 约见
- (void)actionDate {
    [self.chatToolbar endEditing:YES];
    
    NSDictionary *infoDict = _conversation.ext[Key_Conversation_Ext];
    UIStoryboard *messageSB = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    DateCategoryViewController *dateCategoryVC = [messageSB instantiateViewControllerWithIdentifier:@"DateCategoryVC"];
    dateCategoryVC.userId = infoDict[@"userId"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateCategoryVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - EMChatManagerDelegate
#pragma mark - 收到消息
- (void)didReceiveMessages:(NSArray *)aMessages {
    for (EMMessage *message in aMessages) {
        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            [self addMessageToDataSource:message progress:nil];
            
            // 找出未读消息，将未读消息置为已读
            [self sendHasReadResponseForMessages:@[message] isRead:NO];
            
            if (([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) && self.isViewDidAppear) {
                [self.conversation markMessageAsReadWithId:message.messageId error:nil];
            }
        }
    }
}

#pragma mark - 收到消息送达回执
- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages {
    for(EMMessage *message in aMessages){
        [self updateMessageStatus:message];
    }
}

#pragma mark - 收到消息已读回执
- (void)didReceiveHasReadAcks:(NSArray *)aMessages {
    for (EMMessage *message in aMessages) {
        if (![self.conversation.conversationId isEqualToString:message.conversationId]){
            continue;
        }
        __block BOOL isHave = NO;
        __weak typeof(self) weakself = self;
        [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj conformsToProtocol:@protocol(IMessageModel)]) {
                id<IMessageModel> model = (id<IMessageModel>)obj;
                if ([model.messageId isEqualToString:message.messageId]) {
                    model.message.isReadAcked = YES;
                    [weakself.conversation markMessageAsReadWithId:message.messageId error:nil];
                    if ([model.message.ext[Flag_Snap] boolValue]) {
                        [weakself deleteMessageModel:model.messageId];
                    }
                    isHave = YES;
                    *stop = YES;
                }
            }
        }];
        if (isHave) {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - 消息状态改变
- (void)didMessageStatusChanged:(EMMessage *)aMessage error:(EMError *)aError {
    [self updateMessageStatus:aMessage];
}

#pragma mark - 消息附件下载状态改变，图片、声音、视频
- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error {
    if (!error) {
        EMFileMessageBody *fileBody = (EMFileMessageBody*)[message body];
        if ([fileBody type] == EMMessageBodyTypeImage) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed) {
                [self reloadTableViewDataWithMessage:message];
            }
        } else if([fileBody type] == EMMessageBodyTypeVoice){
            if ([fileBody downloadStatus] == EMDownloadStatusSuccessed) {
                [self reloadTableViewDataWithMessage:message];
            }
        } else if([fileBody type] == EMMessageBodyTypeVideo){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed) {
                [self reloadTableViewDataWithMessage:message];
            }
        }
    }
}

//#pragma mark - EMCDDeviceManagerProximitySensorDelegate
/*- (void)proximitySensorChanged:(BOOL)isCloseToUser {
 AVAudioSession *audioSession = [AVAudioSession sharedInstance];
 if (isCloseToUser) {
 [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
 } else {
 [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
 if (self.playingVoiceModel == nil) {
 [[EMCDDeviceManager sharedInstance] disableProximitySensor];
 }
 }
 [audioSession setActive:YES error:nil];
 }*/

#pragma mark - 将消息按时间分割，同时将时间信息加入到data array
- (NSArray *)formatMessages:(NSArray *)messages {
    NSMutableArray *formattedArray = [[NSMutableArray alloc] init];
    for (EMMessage *message in messages) {
        //Calculate time interval
        CGFloat interval = (self.messageTimeIntervalTag - message.timestamp) / 1000;
        if (self.messageTimeIntervalTag < 0 || interval > 300 || interval < -300) {
            NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSString *timeStr = [messageDate formattedTime];
            [formattedArray addObject:timeStr];
            self.messageTimeIntervalTag = message.timestamp;
        }
        
        //Construct message model
        id<IMessageModel> model = nil;
        model = [[EaseMessageModel alloc] initWithMessage:message];
        model.nickname = self.titleString;
        
        if (model) {
            [formattedArray addObject:model];
        }
    }
    return formattedArray;
}

#pragma mark - 当接收到消息或发送消息时，添加消息
- (void)addMessageToDataSource:(EMMessage *)message progress:(id)progress {
    [self.msgsArray addObject:message];
    
    NSArray *messages = [self formatMessages:@[message]];
    [self.dataArray addObjectsFromArray:messages];
    NSUInteger maxRow = self.dataArray.count - 1;
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:maxRow inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:YES];
        });
    });
}

#pragma mark - 发送消息后刷新消息列表
- (void)refreshAfterSentMessage:(EMMessage*)aMessage {
    if ([self.msgsArray count] && [EMClient sharedClient].options.sortMessageByServerTime) {
        NSString *msgId = aMessage.messageId;
        EMMessage *last = self.msgsArray.lastObject;
        if ([last isKindOfClass:[EMMessage class]]) {
            __block NSUInteger index = NSNotFound;
            [self.msgsArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(EMMessage *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[EMMessage class]] && [obj.messageId isEqualToString:msgId]) {
                    index = idx;
                    *stop = YES;
                }
            }];
            if (index != NSNotFound) {
                [self.msgsArray removeObjectAtIndex:index];
                [self.msgsArray addObject:aMessage];
                
                //格式化消息
                self.messageTimeIntervalTag = -1;
                NSArray *formatMsgs = [self formatMessages:self.msgsArray];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:formatMsgs];
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:YES];
                return;
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 插入被屏蔽提示消息
- (void)importWarningMessage {
    __weak typeof(self) weakself = self;
    NSDictionary *messageExt = @{Flag_BlackTips : @YES};
    EMMessage *message = [EaseSDKHelper sendTextMessage:@"您已经被屏蔽，不能与Ta进行私信会话"
                                                     to:self.conversation.conversationId
                                            messageType:EMChatTypeChat
                                             messageExt:messageExt];
    [self addMessageToDataSource:message progress:nil];
    [[EMClient sharedClient].chatManager importMessages:@[message] completion:^(EMError *aError) {
        if (!aError) {
            [weakself refreshAfterSentMessage:message];
        }
    }];
}

#pragma mark - 发送消息
- (void)sendMessage:(EMMessage *)message {
    // add to local data array
    [self addMessageToDataSource:message progress:nil];
    // send message
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            // if success refresh
            [weakself refreshAfterSentMessage:aMessage];
        } else {
            // failer if in blacklist warning
            if (aError.code == EMErrorUserPermissionDenied) {
                //[weakself.dataArray addObject:@"您已经被屏蔽，不能与TA进行私信会话"];
                [weakself importWarningMessage];
            }
            [weakself.tableView reloadData];
        }
    }];
}

- (void)sendTextMessage:(NSString *)text {
    EaseChatToolbar *toolbar = (EaseChatToolbar*)self.chatToolbar;
    NSDictionary *messageExt = toolbar.isSnap ? @{Flag_Snap : @YES} : nil;
    [self sendTextMessage:text withExt:messageExt];
}

- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext {
    EMMessage *message = [EaseSDKHelper sendTextMessage:text
                                                     to:self.conversation.conversationId
                                            messageType:EMChatTypeChat
                                             messageExt:ext];
    [self sendMessage:message];
}

- (void)sendImageMessage:(UIImage *)image {
    EaseChatToolbar *toolbar = (EaseChatToolbar*)self.chatToolbar;
    NSDictionary *messageExt = toolbar.isSnap ? @{Flag_Snap : @YES} : nil;
    EMMessage *message = [EaseSDKHelper sendImageMessageWithImage:image
                                                               to:self.conversation.conversationId
                                                      messageType:EMChatTypeChat
                                                       messageExt:messageExt];
    [self sendMessage:message];
}

- (void)sendImageMessageWithData:(NSData *)imageData {
    EaseChatToolbar *toolbar = (EaseChatToolbar*)self.chatToolbar;
    NSDictionary *messageExt = toolbar.isSnap ? @{Flag_Snap : @YES} : nil;
    EMMessage *message = [EaseSDKHelper sendImageMessageWithImageData:imageData
                                                                   to:self.conversation.conversationId
                                                          messageType:EMChatTypeChat
                                                           messageExt:messageExt];
    [self sendMessage:message];
}

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration {
    EaseChatToolbar *toolbar = (EaseChatToolbar*)self.chatToolbar;
    NSDictionary *messageExt = toolbar.isSnap ? @{Flag_Snap : @YES} : nil;
    EMMessage *message = [EaseSDKHelper sendVoiceMessageWithLocalPath:localPath
                                                             duration:duration
                                                                   to:self.conversation.conversationId
                                                          messageType:EMChatTypeChat
                                                           messageExt:messageExt];
    [self sendMessage:message];
}

- (void)sendVideoMessageWithURL:(NSURL *)url {
    EaseChatToolbar *toolbar = (EaseChatToolbar*)self.chatToolbar;
    NSDictionary *messageExt = toolbar.isSnap ? @{Flag_Snap : @YES} : nil;
    EMMessage *message = [EaseSDKHelper sendVideoMessageWithURL:url
                                                             to:self.conversation.conversationId
                                                    messageType:EMChatTypeChat
                                                     messageExt:messageExt];
    [self sendMessage:message];
}

#pragma mark - 刷新消息信息
- (void)reloadTableViewDataWithMessage:(EMMessage *)message {
    if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
        for (int i = 0; i < self.dataArray.count; i++) {
            id object = self.dataArray[i];
            if ([object isKindOfClass:[EaseMessageModel class]]) {
                id<IMessageModel> model = object;
                if ([message.messageId isEqualToString:model.messageId]) {
                    id<IMessageModel> model = nil;
                    model = [[EaseMessageModel alloc] initWithMessage:message];
                    [self.dataArray replaceObjectAtIndex:i withObject:model];
                    [self.tableView beginUpdates];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]
                                          withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView endUpdates];
                    break;
                }
            }
        }
    }
}

#pragma mark - 更新消息状态
- (void)updateMessageStatus:(EMMessage *)aMessage {
    BOOL isChatting = [aMessage.conversationId isEqualToString:self.conversation.conversationId];
    if (aMessage && isChatting) {
        id<IMessageModel> model = [[EaseMessageModel alloc] initWithMessage:aMessage];
        if (model) {
            __block NSUInteger index = NSNotFound;
            [self.dataArray enumerateObjectsUsingBlock:^(EaseMessageModel *model, NSUInteger idx, BOOL *stop){
                if ([model conformsToProtocol:@protocol(IMessageModel)]) {
                    if ([aMessage.messageId isEqualToString:model.message.messageId]) {
                        index = idx;
                        *stop = YES;
                    }
                }
            }];
            
            if (index != NSNotFound) {
                [self.dataArray replaceObjectAtIndex:index withObject:model];
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            }
        }
    }
}

@end
