/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseChatToolbar.h"

#import "EaseFaceView.h"
#import "EaseEmoji.h"
#import "EaseEmotionEscape.h"
#import "EaseEmotionManager.h"
#import "EaseLocalDefine.h"
#import "Masonry.h"
#import "YGRecordView.h"
#import "FacePanel.h"
#import "ChatKeyBoardMacroDefine.h"
#import "FaceSourceManager.h"


@interface EaseChatToolbar()<UITextViewDelegate, EMFaceDelegate, YGSelectPicViewDelegate, FacePanelDelegate, YGRecordViewDelegate>

@property (nonatomic) CGFloat version;
@property (strong, nonatomic) NSMutableArray *leftItems;
@property (strong, nonatomic) NSMutableArray *rightItems;
@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;
@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIButton *faceButton;
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;//上一次inputTextView的contentSize.height
@property (nonatomic) NSLayoutConstraint *inputViewWidthItemsLeftConstraint;
@property (nonatomic) NSLayoutConstraint *inputViewWidthoutItemsLeftConstraint;
@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, strong) UIView *functionView;
@property (nonatomic, strong) NSMutableArray *functionBtnArray;

@property (nonatomic, strong) UIView *snapFunctionView;
@property (nonatomic, strong) NSMutableArray *snapBtnArray;
@property (nonatomic, assign) BOOL isSnap;

@property (nonatomic, strong) YGRecordView *recordView;
@property (nonatomic, strong) YGSelectPicView *selectPicView;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, strong) UIImageView *inputBgView;

@property (nonatomic, strong) FacePanel *facePanel;


@end

@implementation EaseChatToolbar

@synthesize faceView = _faceView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame horizontalPadding:0 verticalPadding:0 inputViewMinHeight:82 inputViewMaxHeight:150 type:EMChatToolbarTypeGroup];
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                         type:(EMChatToolbarType)type
{
    self = [self initWithFrame:frame inputViewMinHeight:82 inputViewMaxHeight:150 type:type];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight
                         type:(EMChatToolbarType)type {
    if (frame.size.height < inputViewMinHeight) {
        frame.size.height = inputViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.screenWidth = [UIScreen mainScreen].bounds.size.width;
        _inputViewMinHeight = inputViewMinHeight;
        _inputViewMaxHeight = inputViewMaxHeight;
        _chatBarType = type;
        
        _leftItems = [NSMutableArray new];
        _rightItems = [NSMutableArray new];
        _version = [[[UIDevice currentDevice] systemVersion] floatValue];
        _activityButtomView = nil;
        _isShowButtomView = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        self.isSnap = NO;
        [self setupSubviews];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight
                         type:(EMChatToolbarType)type
{
    if (frame.size.height < inputViewMinHeight) {
        frame.size.height = inputViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.screenWidth = [UIScreen mainScreen].bounds.size.width;
        _inputViewMinHeight = inputViewMinHeight;
        _inputViewMaxHeight = inputViewMaxHeight;
        _chatBarType = type;
        
        _leftItems = [NSMutableArray new];
        _rightItems = [NSMutableArray new];
        _version = [[[UIDevice currentDevice] systemVersion] floatValue];
        _activityButtomView = nil;
        _isShowButtomView = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(chatKeyboardWillChangeFrame:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        self.isSnap = NO;
        [self setupSubviews];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

#pragma mark - setup subviews
- (void)setupSubviews {
    self.backgroundColor = [UIColor blueColor];
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    _backgroundImageView.image = [[UIImage imageNamed:@"EaseUIResource.bundle/messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    [self addSubview:_backgroundImageView];
    
    //toolbar
    _toolbarView = [[UIView alloc] initWithFrame:self.bounds];
    _toolbarView.backgroundColor = [UIColor clearColor];
    [self addSubview:_toolbarView];
    _toolbarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _toolbarView.frame.size.width, _toolbarView.frame.size.height)];
    _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
    [_toolbarView addSubview:_toolbarBackgroundImageView];
    
    [self setupInputTextView];
    [self setupFunctionView];
    [self setUpSnapFunctionView];
}


- (void) setupInputTextView {
    self.inputView = [[UIView alloc] init];
    [_toolbarView addSubview:self.inputView];
    
    self.inputBgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 9, self.screenWidth - 12 * 2, 31)];
    UIImage *bgImage = [UIImage imageNamed:@"message_chat_input_bg"];
    self.inputBgView.image = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width / 2 topCapHeight:bgImage.size.height / 2];
    [self.inputView addSubview:self.inputBgView];
    
    //input textview
    _inputTextView = [[EaseTextView alloc] initWithFrame:CGRectMake(12 , 9, self.screenWidth - 12 * 2, 31)];
    _inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _inputTextView.scrollEnabled = YES;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    //_inputTextView.placeHolder = NSEaseLocalizedString(@"message.toolBar.inputPlaceHolder", @"input a new message");
    _inputTextView.font = [UIFont systemFontOfSize:14];
    _inputTextView.delegate = self;
    _inputTextView.backgroundColor = [UIColor clearColor];
    _previousTextViewContentHeight =  82; // [self _getTextViewContentH:_inputTextView];
    [self.inputView addSubview:_inputTextView];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toolbarView.mas_top);
        make.left.mas_equalTo(self.toolbarView.mas_left);
        make.right.mas_equalTo(self.toolbarView.mas_right);
        make.bottom.mas_equalTo(self.toolbarView.mas_bottom).with.offset(-42);
    }];
    
    [self.inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputView.mas_left).with.offset(12);
        make.right.mas_equalTo(self.inputView.mas_right).with.offset(-12);
        make.top.mas_equalTo(self.inputView.mas_top).with.offset(9);
        make.bottom.mas_equalTo(self.inputView.mas_bottom);
    }];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputView.mas_left).with.offset(12);
        make.right.mas_equalTo(self.inputView.mas_right).with.offset(-12);
        make.top.mas_equalTo(self.inputView.mas_top).with.offset(10);
        make.bottom.mas_equalTo(self.inputView.mas_bottom);
    }];
}

- (void) setupFunctionView {
    NSArray *normalImages = @[@"消息-语音", @"消息-位置", @"送礼物", @"消息-表情"];// @"消息-发图", @"消息-阅后即焚", @"消息-约见",
    NSArray *highlightedImages = @[@"消息-语音-点击", @"消息-位置-点击", @"消息界面送礼点击", @"消息-表情-点击"];//, @"消息-发图-点击", @"消息-阅后即焚-点击" @"消息-约见-点击",
    if (![LoginData sharedLoginData].ope) {
        normalImages = @[@"消息-语音", @"消息-位置", @"消息-表情"];//@"消息-发图", @"消息-阅后即焚",
        highlightedImages = @[@"消息-语音-点击", @"消息-位置-点击", @"消息-表情-点击"];// @"消息-发图-点击", @"消息-阅后即焚-点击",
    }
    
    self.functionView = [[UIView alloc] initWithFrame:CGRectMake(6, 40, _screenWidth - 6 * 2, 42)];
    [self.toolbarView addSubview:self.functionView];
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.toolbarView.mas_left).with.offset(6);
        make.right.mas_equalTo(self.toolbarView.mas_right).with.offset(-6);
        make.bottom.mas_equalTo(self.toolbarView.mas_bottom);
        make.height.mas_equalTo(42);
    }];
    
    NSInteger count = normalImages.count;
    CGFloat gap = 6;
    CGFloat btnW = (_screenWidth - gap * (count + 1)) / count;
    self.functionBtnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        CGFloat btnX = (btnW + gap) * i;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, 0, btnW, 42)];
        [btn setImage:[UIImage imageNamed:normalImages[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:highlightedImages[i]] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:highlightedImages[i]] forState:UIControlStateSelected];
        btn.tag = i;
        [btn addTarget:self action:@selector(actionFunctionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.functionView addSubview:btn];
        [self.functionBtnArray addObject:btn];
    }
}

- (void) setUpSnapFunctionView {
    self.snapBtnArray = [[NSMutableArray alloc] init];
    self.snapFunctionView  = [[UIView alloc] initWithFrame:CGRectMake(6, 40, _screenWidth - 6 * 2, 42)];
    self.snapFunctionView.hidden = YES;
    [self.toolbarView addSubview:self.snapFunctionView];
    [self.snapFunctionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.toolbarView.mas_left).with.offset(6);
        make.right.mas_equalTo(self.toolbarView.mas_right).with.offset(-6);
        make.bottom.mas_equalTo(self.toolbarView.mas_bottom);
        make.height.mas_equalTo(42);
    }];
    
    UIButton * recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 42, 42)];
    [recordBtn setImage:[UIImage imageNamed:@"阅后即焚-语音"] forState:UIControlStateNormal];
    [recordBtn setImage:[UIImage imageNamed:@"阅后即焚-语音@2x"] forState:UIControlStateHighlighted];
    recordBtn.tag = 0;
    [recordBtn addTarget:self action:@selector(actionFunctionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.snapBtnArray addObject:recordBtn];
    [self.snapFunctionView addSubview:recordBtn];
    
    UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 42, 42)];
    [imageBtn setImage:[UIImage imageNamed:@"阅后即焚-发图"] forState:UIControlStateNormal];
    [imageBtn setImage:[UIImage imageNamed:@"阅后即焚-发图"] forState:UIControlStateHighlighted];
    [imageBtn setImage:[UIImage imageNamed:@"阅后即焚-发图"] forState:UIControlStateSelected];
    imageBtn.tag = 1;
    [imageBtn addTarget:self action:@selector(actionFunctionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.snapBtnArray addObject:imageBtn];
    [self.snapFunctionView addSubview:imageBtn];
    
    UIButton *exitSnapBtn = [[UIButton alloc] initWithFrame:CGRectMake(_screenWidth - 13 - 42, 0, 42, 42)];
    [exitSnapBtn setImage:[UIImage imageNamed:@"阅后即焚-退出"] forState:UIControlStateNormal];
    [exitSnapBtn setImage:[UIImage imageNamed:@"阅后即焚-退出"] forState:UIControlStateHighlighted];
    [exitSnapBtn setImage:[UIImage imageNamed:@"阅后即焚-退出"] forState:UIControlStateSelected];
    exitSnapBtn.tag = 7;
    [exitSnapBtn addTarget:self action:@selector(actionFunctionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.snapBtnArray addObject:exitSnapBtn];
    [self.snapFunctionView addSubview:exitSnapBtn];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //    _delegate = nil;
    //    _inputTextView.delegate = nil;
    //    _inputTextView = nil;
    //    
    NSLog(@"%s",__func__);
}

#pragma mark - getter

- (FacePanel *)facePanel {
    if (!_facePanel) {
        _facePanel = [[FacePanel alloc] initWithFrame:CGRectMake(0, kChatKeyBoardHeight-kFacePanelHeight, kScreenWidth, kFacePanelHeight)];
        _facePanel.delegate = self;
        NSArray<FaceSubjectModel *> *subjectMItems = [FaceSourceManager loadFaceSource];
        [_facePanel loadFaceSubjectItems:subjectMItems];
        _facePanel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _facePanel;
}


- (EaseFaceView *)faceView {
    if (!_faceView) {
        _faceView = [[EaseFaceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolbarView.frame), self.frame.size.width, 180)];
        _faceView.delegate = self;
        _faceView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
        _faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _faceView;
}

- (void)setFaceView:(EaseFaceView *)faceView {
    if (_faceView != faceView) {
        _faceView = faceView;
        
        for (EaseChatToolbarItem *item in self.rightItems) {
            if (item.button == self.faceButton) {
                item.button2View = _faceView;
                break;
            }
        }
    }
}

- (NSArray*)inputViewLeftItems {
    return self.leftItems;
}

- (void)setInputViewLeftItems:(NSArray *)inputViewLeftItems {
    for (EaseChatToolbarItem *item in self.leftItems) {
        [item.button removeFromSuperview];
        [item.button2View removeFromSuperview];
    }
    [self.leftItems removeAllObjects];
    
    CGFloat oX = 0;
    CGFloat itemHeight = self.toolbarView.frame.size.height;
    for (id item in inputViewLeftItems) {
        if ([item isKindOfClass:[EaseChatToolbarItem class]]) {
            EaseChatToolbarItem *chatItem = (EaseChatToolbarItem *)item;
            if (chatItem.button) {
                CGRect itemFrame = chatItem.button.frame;
                if (itemFrame.size.height == 0) {
                    itemFrame.size.height = itemHeight;
                }
                
                if (itemFrame.size.width == 0) {
                    itemFrame.size.width = itemFrame.size.height;
                }
                
                itemFrame.origin.x = oX;
                itemFrame.origin.y = (self.toolbarView.frame.size.height - itemFrame.size.height) / 2;
                chatItem.button.frame = itemFrame;
                oX += itemFrame.size.width;
                
                [self.toolbarView addSubview:chatItem.button];
                [self.leftItems addObject:chatItem];
            }
        }
    }
    
    CGRect inputFrame = self.inputTextView.frame;
    CGFloat value = inputFrame.origin.x - oX;
    inputFrame.origin.x = oX;
    inputFrame.size.width += value;
    self.inputTextView.frame = inputFrame;
    
    CGRect recordFrame = self.recordButton.frame;
    recordFrame.origin.x = inputFrame.origin.x;
    recordFrame.size.width = inputFrame.size.width;
    self.recordButton.frame = recordFrame;
}

- (NSArray*)inputViewRightItems {
    return self.rightItems;
}

- (void)setInputViewRightItems:(NSArray *)inputViewRightItems {
    for (EaseChatToolbarItem *item in self.rightItems) {
        [item.button removeFromSuperview];
        [item.button2View removeFromSuperview];
    }
    [self.rightItems removeAllObjects];
    
    CGFloat oMaxX = self.toolbarView.frame.size.width;
    CGFloat itemHeight = self.toolbarView.frame.size.height;
    if ([inputViewRightItems count] > 0) {
        for (NSInteger i = (inputViewRightItems.count - 1); i >= 0; i--) {
            id item = [inputViewRightItems objectAtIndex:i];
            if ([item isKindOfClass:[EaseChatToolbarItem class]]) {
                EaseChatToolbarItem *chatItem = (EaseChatToolbarItem *)item;
                if (chatItem.button) {
                    CGRect itemFrame = chatItem.button.frame;
                    if (itemFrame.size.height == 0) {
                        itemFrame.size.height = itemHeight;
                    }
                    
                    if (itemFrame.size.width == 0) {
                        itemFrame.size.width = itemFrame.size.height;
                    }
                    
                    oMaxX -= itemFrame.size.width;
                    itemFrame.origin.x = oMaxX;
                    itemFrame.origin.y = (self.toolbarView.frame.size.height - itemFrame.size.height) / 2;
                    chatItem.button.frame = itemFrame;
                    
                    [self.toolbarView addSubview:chatItem.button];
                    [self.rightItems addObject:item];
                }
            }
        }
    }
    
    CGRect inputFrame = self.inputTextView.frame;
    CGFloat value = oMaxX - CGRectGetMaxX(inputFrame);
    inputFrame.size.width += value;
    self.inputTextView.frame = inputFrame;
    
    CGRect recordFrame = self.recordButton.frame;
    recordFrame.origin.x = inputFrame.origin.x;
    recordFrame.size.width = inputFrame.size.width;
    self.recordButton.frame = recordFrame;
}

#pragma mark - private input view

- (CGFloat)_getTextViewContentH:(UITextView *)textView {
    if (self.version >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

- (void)_willShowInputTextViewToHeight:(CGFloat)toHeight {
    
    if (toHeight + 48 < self.inputViewMinHeight) {
        toHeight = self.inputViewMinHeight - 48;
    }
    if (toHeight + 48 > self.inputViewMaxHeight ) {
        toHeight = self.inputViewMaxHeight - 48;
    }
    
    if (toHeight == _previousTextViewContentHeight - 48) {
        return;
    } else {
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight + 48;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;
        
        if (self.version < 7.0) {
            [self.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height) / 2) animated:YES];
        }
        _previousTextViewContentHeight = toHeight + 48;
        
        if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)]) {
            [_delegate chatToolbarDidChangeFrameToHeight:self.frame.size.height];
        }
    }
}

#pragma mark - private bottom view

- (void)_willShowBottomHeight:(CGFloat)bottomHeight {
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height) {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    } else {
        self.isShowButtomView = YES;
    }
    
    self.frame = toFrame;
    
    if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)]) {
        [_delegate chatToolbarDidChangeFrameToHeight:toHeight];
    }
}

- (void)_willShowBottomView:(UIView *)bottomView {
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self _willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)_willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame {
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        [self _willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    } else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        [self _willShowBottomHeight:0];
    } else {
        [self _willShowBottomHeight:toFrame.size.height];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    
    for (EaseChatToolbarItem *item in self.leftItems) {
        item.button.selected = NO;
    }
    
    for (EaseChatToolbarItem *item in self.rightItems) {
        item.button.selected = NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:textView.text];
            self.inputTextView.text = @"";
            [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];
        }
        
        return NO;
    } else if ([text isEqualToString:@"@"]) {
        if ([self.delegate respondsToSelector:@selector(didInputAtInLocation:)]) {
            if ([self.delegate didInputAtInLocation:range.location]) {
                [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];
                return NO;
            }
        }
    } else if ([text length] == 0) {
        //delete one character
        if (range.length == 1 && [self.delegate respondsToSelector:@selector(didDeleteCharacterFromLocation:)]) {
            return ![self.delegate didDeleteCharacterFromLocation:range.location];
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self _willShowInputTextViewToHeight:[self _getTextViewContentH:textView]];
}

#pragma mark - DXFaceDelegate

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete {
    NSString *chatText = self.inputTextView.text;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextView.attributedText];
    
    if (!isDelete && str.length > 0) {
        if (self.version >= 7.0) {
            NSRange range = [self.inputTextView selectedRange];
            [attr insertAttributedString:[[EaseEmotionEscape sharedInstance] attStringFromTextForInputView:str textFont:self.inputTextView.font] atIndex:range.location];
            self.inputTextView.attributedText = attr;
        } else {
            self.inputTextView.text = @"";
            self.inputTextView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
        }
    }
    else {
        if (self.version >= 7.0) {
            if (chatText.length > 0) {
                NSInteger length = 1;
                if (chatText.length >= 2) {
                    NSString *subStr = [chatText substringFromIndex:chatText.length-2];
                    if ([EaseEmoji stringContainsEmoji:subStr]) {
                        length = 2;
                    }
                }
                self.inputTextView.attributedText = [self backspaceText:attr length:length];
            }
        } else {
            if (chatText.length >= 2)
            {
                NSString *subStr = [chatText substringFromIndex:chatText.length-2];
                if ([(EaseFaceView *)self.faceView stringIsFace:subStr]) {
                    self.inputTextView.text = [chatText substringToIndex:chatText.length-2];
                    [self textViewDidChange:self.inputTextView];
                    return;
                }
            }
            
            if (chatText.length > 0) {
                self.inputTextView.text = [chatText substringToIndex:chatText.length-1];
            }
        }
    }
    
    [self textViewDidChange:self.inputTextView];
}

-(NSMutableAttributedString*)backspaceText:(NSMutableAttributedString*) attr length:(NSInteger)length {
    NSRange range = [self.inputTextView selectedRange];
    if (range.location == 0) {
        return attr;
    }
    [attr deleteCharactersInRange:NSMakeRange(range.location - length, length)];
    return attr;
}

- (void)sendFace {
    NSString *chatText = self.inputTextView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            
            if (![_inputTextView.text isEqualToString:@""]) {
                
                //转义回来
                NSMutableString *attStr = [[NSMutableString alloc] initWithString:self.inputTextView.attributedText.string];
                [_inputTextView.attributedText enumerateAttribute:NSAttachmentAttributeName
                                                          inRange:NSMakeRange(0, self.inputTextView.attributedText.length)
                                                          options:NSAttributedStringEnumerationReverse
                                                       usingBlock:^(id value, NSRange range, BOOL *stop)
                 {
                     if (value) {
                         EMTextAttachment* attachment = (EMTextAttachment*)value;
                         NSString *str = [NSString stringWithFormat:@"%@",attachment.imageName];
                         [attStr replaceCharactersInRange:range withString:str];
                     }
                 }];
                [self.delegate didSendText:attStr];
                self.inputTextView.text = @"";
                [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];;
            }
        }
    }
}

- (void)sendFaceWithEmotion:(EaseEmotion *)emotion {
    if (emotion) {
        if ([self.delegate respondsToSelector:@selector(didSendText:withExt:)]) {
            [self.delegate didSendText:emotion.emotionTitle withExt:@{EASEUI_EMOTION_DEFAULT_EXT:emotion}];
            [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];;
        }
    }
}


#pragma mark - YGRecordViewDelegate
- (void) didStartRecordingVoice: (YGRecordView *) recordView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction:)]) {
        [self.delegate didStartRecordingVoiceAction:recordView];
    }
}

- (void) didCancelRecordingVoice: (YGRecordView *) recordView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction:)]) {
        [self.delegate didCancelRecordingVoiceAction:recordView];
    }
}

- (void) didFinishRecoingVoice : (YGRecordView *) recordView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction:)]) {
        [self.delegate didFinishRecoingVoiceAction:recordView];
    }
}

#pragma mark - UIKeyboardNotification

- (void)chatKeyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    __weak typeof(self) weakself = self;
    void(^animations)() = ^{
        [weakself _willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

#pragma mark - action

- (void)styleButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        for (EaseChatToolbarItem *item in self.rightItems) {
            item.button.selected = NO;
        }
        
        for (EaseChatToolbarItem *item in self.leftItems) {
            if (item.button != button) {
                item.button.selected = NO;
            }
        }
        
        [self _willShowBottomView:nil];
        
        self.inputTextView.text = @"";
        [self textViewDidChange:self.inputTextView];
        [self.inputTextView resignFirstResponder];
    } else {
        [self.inputTextView becomeFirstResponder];
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.recordButton.hidden = !button.selected;
        self.inputTextView.hidden = button.selected;
    } completion:nil];
}

- (void)faceButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    EaseChatToolbarItem *faceItem = nil;
    for (EaseChatToolbarItem *item in self.rightItems) {
        if (item.button == button){
            faceItem = item;
            continue;
        }
        
        item.button.selected = NO;
    }
    
    for (EaseChatToolbarItem *item in self.leftItems) {
        item.button.selected = NO;
    }
    
    if (button.selected) {
        [self.inputTextView resignFirstResponder];
        
        [self _willShowBottomView:faceItem.button2View];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.recordButton.hidden = button.selected;
            self.inputTextView.hidden = !button.selected;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self.inputTextView becomeFirstResponder];
    }
}

- (void)moreButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    EaseChatToolbarItem *moreItem = nil;
    for (EaseChatToolbarItem *item in self.rightItems) {
        if (item.button == button){
            moreItem = item;
            continue;
        }
        
        item.button.selected = NO;
    }
    
    for (EaseChatToolbarItem *item in self.leftItems) {
        item.button.selected = NO;
    }
    
    if (button.selected) {
        [self.inputTextView resignFirstResponder];
        
        [self _willShowBottomView:moreItem.button2View];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.recordButton.hidden = button.selected;
            self.inputTextView.hidden = !button.selected;
        } completion:nil];
    }
    else
    {
        [self.inputTextView becomeFirstResponder];
    }
}

- (void)recordButtonTouchDown {
    if (_delegate && [_delegate respondsToSelector:@selector(didStartRecordingVoiceAction:)]) {
        //        [_delegate didStartRecordingVoiceAction:self.recordView];
    }
}

- (void)recordButtonTouchUpOutside
{
    if (_delegate && [_delegate respondsToSelector:@selector(didCancelRecordingVoiceAction:)])
    {
        //        [_delegate didCancelRecordingVoiceAction:self.recordView];
    }
}

- (void)recordButtonTouchUpInside
{
    self.recordButton.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction:)])
    {
        //        [self.delegate didFinishRecoingVoiceAction:self.recordView];
    }
    self.recordButton.enabled = YES;
}

- (void)recordDragOutside
{
    //    if ([self.delegate respondsToSelector:@selector(didDragOutsideAction:)])
    //    {
    //        //[self.delegate didDragOutsideAct÷ion:self.recordView];
    //    }
}

- (void)recordDragInside
{
    //    if ([self.delegate respondsToSelector:@selector(didDragInsideAction:)])
    //    {
    //        //        [self.delegate didDragInsideAction:self.recordView];
    //    }
}

#pragma mark - public

+ (CGFloat)defaultHeight {
    return 82;
}

- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    
    for (EaseChatToolbarItem *item in self.rightItems) {
        item.button.selected = NO;
    }
    
    for (UIButton *btn in self.functionBtnArray) {
        btn.selected = NO;
    }
    
    [self _willShowBottomView:nil];
    
    return result;
}

- (void)cancelTouchRecord
{
    //    if ([_recordView isKindOfClass:[EaseRecordView class]]) {
    //        [(EaseRecordView *)_recordView recordButtonTouchUpInside];
    //        [_recordView removeFromSuperview];
    //    }
}

- (void)willShowBottomView:(UIView *)bottomView
{
    [self _willShowBottomView:bottomView];
}


- (YGRecordView *) recordView {
    if (!_recordView) {
        _recordView = [[YGRecordView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, [YGRecordView viewHeight])];
        _recordView.delegate = self;
    }
    return _recordView;
}

- (YGSelectPicView *) selectPicView {
    if (!_selectPicView) {
        _selectPicView = [[YGSelectPicView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, [YGSelectPicView viewHeight])];
        
        _selectPicView.delegate = self;
    }
    return _selectPicView;
}

#pragma mark Actions
- (void)actionFunctionButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    UIImage *bgImage = [UIImage imageNamed:@"message_chat_input_bg"];
    self.inputBgView.image = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width / 2 topCapHeight:bgImage.size.height / 2];
    if (sender.selected) {
        for (UIButton *btn in self.functionBtnArray) {
            if (btn != sender) {
                btn.selected = NO;
            }
        }
        for (UIButton *btn in self.snapBtnArray) {
            if (btn != sender) {
                btn.selected = NO;
            }
        }
        
        [self.inputTextView resignFirstResponder];
    } else {
        if (!self.isSnap) {
            [self.inputTextView becomeFirstResponder];
        } else {
            [self _willShowBottomView:nil];
        }
    }
    
    if (![LoginData sharedLoginData].ope) {
        switch (sender.tag) {
            case 0:
            {
                if (sender.selected) {
                    [self _willShowBottomView:self.recordView];
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.inputTextView.hidden = !sender.selected;
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
                break;
//            case 1:
//            {
//                if (sender.selected) {
//                    [self _willShowBottomView:self.selectPicView];
//                    [self.selectPicView reset];
//                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        self.inputTextView.hidden = !sender.selected;
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                
//            }
//                break;
//                
//            case 2:
//            {
//                if (sender.selected) {
//                    [self _willShowBottomView:nil];
//                }
//                
//                self.isSnap = sender.selected;
//                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    self.functionView.hidden = sender.selected;
//                    self.snapFunctionView.hidden = !sender.selected;
//                    self.inputTextView.hidden = !sender.selected;
//                    
//                    UIImage *bgImage = [UIImage imageNamed:@"消息-阅后即焚-输入框"];
//                    self.inputBgView.image = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width / 2 topCapHeight:bgImage.size.height / 2];
//                } completion:^(BOOL finished) {
//                    
//                }];
//                
//            }
//                break;
            case 1:
            {
                [self.delegate actionChooseLocation];
            }
                break;
            case 2:   //
            {
                if (sender.selected) {
                    [self.inputTextView resignFirstResponder];
                    
                    [self _willShowBottomView:self.facePanel];
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.recordButton.hidden = sender.selected;
                        self.inputTextView.hidden = !sender.selected;
                    } completion:^(BOOL finished) {
                        
                    }];
                } else {
                    [self.inputTextView becomeFirstResponder];
                }
                
            }
                break;
//            case 7:
//            {
//                self.isSnap = NO;
//                [self.inputTextView becomeFirstResponder];[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    self.functionView.hidden = NO;
//                    self.snapFunctionView.hidden = YES;
//                } completion:^(BOOL finished) {
//                    
//                }];
//            }
//                break;
            default:
                break;
        }
    } else {
        switch (sender.tag) {
            case 0:
            {
                if (sender.selected) {
                    [self _willShowBottomView:self.recordView];
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.inputTextView.hidden = !sender.selected;
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
                break;
//            case 1:
//            {
//                if (sender.selected) {
//                    [self _willShowBottomView:self.selectPicView];
//                    [self.selectPicView reset];
//                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        self.inputTextView.hidden = !sender.selected;
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                
//            }
//                break;
//                
//            case 2:
//            {
//                if (sender.selected) {
//                    [self _willShowBottomView:nil];
//                }
//                
//                self.isSnap = sender.selected;
//                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    self.functionView.hidden = sender.selected;
//                    self.snapFunctionView.hidden = !sender.selected;
//                    self.inputTextView.hidden = !sender.selected;
//                    
//                    UIImage *bgImage = [UIImage imageNamed:@"消息-阅后即焚-输入框"];
//                    self.inputBgView.image = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width / 2 topCapHeight:bgImage.size.height / 2];
//                } completion:^(BOOL finished) {
//                    
//                }];
//                
//            }
//                break;
            case 1:
            {
                [self.delegate actionChooseLocation];
            }
                break;
            case 2:  // 红包
            {
                [self.delegate showSendBonusController];
            }
                break;
//            case 5:   //约见
//            {
//                [self.delegate actionDate];
//            }
//                break;
            case 3:   //
            {
                if (sender.selected) {
                    [self.inputTextView resignFirstResponder];
                    
                    [self _willShowBottomView:self.facePanel];
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.recordButton.hidden = sender.selected;
                        self.inputTextView.hidden = !sender.selected;
                    } completion:^(BOOL finished) {
                        
                    }];
                } else {
                    [self.inputTextView becomeFirstResponder];
                }
                
            }
                break;
                
//            case 7:
//            {
//                self.isSnap = NO;
//                [self.inputTextView becomeFirstResponder];[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    self.functionView.hidden = NO;
//                    self.snapFunctionView.hidden = YES;
//                } completion:^(BOOL finished) {
//                    
//                }];
//            }
//                break;
                
            default:
                break;
        }
    }
}

- (void) didTapAlbum : (YGSelectPicView *) selectPicView {
    [self.delegate didTapAlbum:selectPicView];
}
- (void) didSendPic : (YGSelectPicView *) selectPicView {
    [self.delegate didSendPic:selectPicView];
}
- (void) previewPic : (YGSelectPicView *) selectPicView atIndex : (NSInteger) index {
    [self.delegate previewPic:selectPicView atIndex:index];
}

#pragma mark - FacePanelDelegate
- (void)facePanelFacePicked:(FacePanel *)facePanel faceSize:(NSInteger)faceSize faceName:(NSString *)faceName delete:(BOOL)isDelete {
    NSString *text = self.inputTextView.text;
    if (text == nil) {
        text = @"";
    }
    if (isDelete) {
        if (text.length > 1) {
            [self.inputTextView deleteBackward];
        } else {
            self.inputTextView.text = @"";
        }
    } else {
        NSRange range = [self.inputTextView selectedRange];
        
        NSMutableString *content = [[NSMutableString alloc] initWithString:text];
        [content replaceCharactersInRange:range withString:faceName];
        self.inputTextView.text = content;
        self.inputTextView.selectedRange = NSMakeRange(range.location + faceName.length, 0);
    }
    
    [self textViewDidChange:self.inputTextView];
}

- (void)facePanelSendTextAction:(FacePanel *)facePanel {
    [self.delegate didSendText:self.inputTextView.text ];
    self.inputTextView.text = @"";
    [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];;
}
- (void)facePanelAddSubject:(FacePanel *)facePanel {
    
}
- (void)facePanelSetSubject:(FacePanel *)facePanel {
    
}

@end
