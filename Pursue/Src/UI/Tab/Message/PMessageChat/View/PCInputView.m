//
//  PCInputView.m
//  Pursue
//
//  Created by YaHaoo on 16/2/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PCInputView.h"
#import "AKTKit.h"

@interface PCInputView ()
///< UI items
@property (strong, nonatomic) UIButton *location;
@property (strong, nonatomic) UITextField *tf;
@property (strong, nonatomic) UIView *line;
//@property (strong, nonatomic) UIButton *send;

///< Control variables
@property (assign, nonatomic) BOOL canAnimate;
@end
@implementation PCInputView
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}
#pragma mark - super methods
//|---------------------------------------------------------------------------------------------------------------------------
- (void)aktLayoutUpdate {
    // Location
    [self.location aktLayout:^(AKTLayoutAttribute *layout) {
        layout.centerY.equalToView(self);
        layout.whRatio.equalToConstant(1);
        layout.height.equalToConstant(self.height);
        layout.left.equalToView(self);
    }];
    // Send
    [self.send aktLayout:^(AKTLayoutAttribute *layout) {
        layout.centerY.equalToView(self);
        layout.right.equalToView(self).offset(-0);
        layout.top.equalToView(self).offset(0);
        layout.whRatio.equalToConstant(1.5);
    }];
    // Line
    [self.line aktLayout:^(AKTLayoutAttribute *layout) {
        layout.left.equalToConstant(self.location.width).offset(10);
        layout.right.equalToConstant(self.send.x).offset(-10);
        layout.height.equalToConstant(1);
        layout.bottom.equalToView(self).offset(-6);
    }];
    // Tf
    [self.tf aktLayout:^(AKTLayoutAttribute *layout) {
        layout.centerY.equalToView(self);
        layout.left.equalToView(self.line).offset(5);
        layout.right.equalToView(self.line).offset(-5);
        layout.bottom.equalToConstant(self.line.y);
    }];
}
#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    // Setup self
    self.backgroundColor = mAKT_Color_Text_X;
    self.layer.shadowOpacity = .3;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 1;
    // Add keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUp:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDown:) name:UIKeyboardWillHideNotification object:nil];
    self.canAnimate = YES;
    
    // Setup UI items
    _location = self.location;
    _send = self.send;
    _line = self.line;
    _tf = self.tf;
}
#pragma mark - property settings
//|---------------------------------------------------------------------------------------------------------------------------
- (UIButton *)location {
    if (_location == nil) {
        _location = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:_location];
        [_location.titleLabel setTextAlignment:(NSTextAlignmentRight)];
        [_location setImage:mAKT_Image(@"P_Location") forState:(UIControlStateNormal)];
        [_location setTintColor:mAKT_COLOR_Color(79, 126, 218, 1)];
        [_location addTarget:self action:@selector(location:) forControlEvents:(UIControlEventTouchUpInside)];
#ifdef DEBUG
        _location.backgroundColor = mAKT_COLOR_Color(0, 255, 0, .2);
#endif
    }
    return _location;
}

- (UIButton *)send {
    if (_send == nil) {
        _send = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:_send];
        [_send setBackgroundColor:mAKT_COLOR_Color(79, 126, 218, 1)];
        [_send setTitle:@"回复" forState:(UIControlStateNormal)];
        [_send.titleLabel setFont:mAKT_Font_SS];
        [_send setTitleColor:mAKT_Color_Text_X forState:(UIControlStateNormal)];
        [_send addTarget:self action:@selector(send:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _send;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [UIView new];
        [self addSubview:_line];
        _line.backgroundColor = mAKT_Color_Text_XXX;
    }
    return _line;
}

- (UITextField *)tf {
    if (_tf == nil) {
        _tf = [UITextField new];
        [self addSubview:_tf];
        [_tf setFont:mAKT_Font_SSS];
        [_tf setPlaceholder:@"请输入内容"];
        [_tf setClearButtonMode:(UITextFieldViewModeWhileEditing)];
        [_tf setBorderStyle:(UITextBorderStyleNone)];
        [_tf setKeyboardType:(UIKeyboardTypeEmailAddress)];
        [_tf setReturnKeyType:(UIReturnKeyDone)];
        [_tf addTarget:self action:@selector(done:) forControlEvents:(UIControlEventEditingDidEndOnExit)];
//        [_tf setEnablesReturnKeyAutomatically:YES];
        //        [_tfPassword setValue:mAKT_T_XX forKeyPath:@"_placeholderLabel.textColor"];
#ifdef DEBUG
        [_tf setBackgroundColor:mAKT_Color_Red];
#endif
    }
    return _tf;
}
#pragma mark - click events
//|---------------------------------------------------------------------------------------------------------------------------
- (void)location:(UIButton *)btn {
    
}

- (void)send:(UIButton *)btn {
    if (self.sendAction) {
        self.sendAction(self.tf.text);
    }
}

- (void)done:(UITextField *)tf {
    if (self.locationAction) {
        self.locationAction();
    }
}
#pragma mark - notification
//|---------------------------------------------------------------------------------------------------------------------------
- (void)keyboardUp:(NSNotification *)noti {
    [self keyboardHandleWithNoti:noti];
}

- (void)keyboardDown:(NSNotification *)noti {
    [self keyboardHandleWithNoti:noti];
}







/*
 *       - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 *-------|The following are function implementations that is provided to the external call|
 *       - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 */
#pragma mark - function implementations
//|---------------------------------------------------------------------------------------------------------------------------
/*
 * Handle for keboard up & down
 */
- (void)keyboardHandleWithNoti:(NSNotification *)noti {
    if (self.canAnimate == NO) {
        return;
    }
    
    NSDictionary *dic = noti.userInfo;
    CGRect endFrame = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:.25 animations:^{
        self.y = endFrame.origin.y-self.height;
    }];
    
    // Output frame
    if (self.frameChangeAction) {
        self.frameChangeAction(self.frame);
    }
}
@end

