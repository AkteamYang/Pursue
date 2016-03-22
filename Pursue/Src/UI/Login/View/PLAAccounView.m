//
//  PLAAccounView.m
//  Pursue
//
//  Created by YaHaoo on 16/2/23.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PLAAccounView.h"
#import "AKTKit.h"

@interface PLAAccounView ()
///< UI items
@property (strong, nonatomic) UILabel *username;
//@property (strong, nonatomic) UITextField *tfUsername;
@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UILabel *password;
//@property (strong, nonatomic) UITextField *tfPassword;
@property (strong, nonatomic) UIView *line2;

///< Control variables
@property (assign, nonatomic) BOOL canAnimate;
@end
@implementation PLAAccounView
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}
#pragma mark - super methods
//|---------------------------------------------------------------------------------------------------------------------------
- (void)aktLayoutUpdate {
    // Username
    [self.username aktLayout:^(AKTLayoutAttribute *layout) {
        layout.top.left.right.equalToView(self);
        layout.height.equalToConstant(28);
    }];
    // TfUsername
    [self.tfUsername aktLayout:^(AKTLayoutAttribute *layout) {
        layout.centerX.equalToView(self);
        layout.width.equalToView(self).multiple(.8);
        layout.top.equalToConstant(self.username.akt_bottom.floatValue);
        layout.height.equalToConstant(self.height/2 - self.username.height);
    }];
    // Line1
    [self.line1 aktLayout:^(AKTLayoutAttribute *layout) {
        layout.centerXY.equalToView(self);
        layout.width.equalToView(self).multiple(.9);
        layout.height.equalToConstant(1);
    }];
    // Password
    [self.password aktLayout:^(AKTLayoutAttribute *layout) {
        layout.top.equalToConstant(self.line1.akt_bottom.floatValue);
        layout.left.right.equalToView(self);
        layout.height.equalToConstant(28);
    }];
    // TfPassword
    [self.tfPassword aktLayout:^(AKTLayoutAttribute *layout) {
        layout.centerX.equalToView(self);
        layout.width.equalToView(self).multiple(.8);
        layout.top.equalToConstant(self.password.akt_bottom.floatValue);
        layout.height.equalToConstant(self.height/2 - self.username.height);
    }];
    // Line2
    [self.line2 aktLayout:^(AKTLayoutAttribute *layout) {
        layout.centerX.equalToView(self);
        layout.width.equalToView(self).multiple(.9);
        layout.height.equalToConstant(1);
        layout.bottom.equalToView(self);
    }];
}
#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    // Setup self
#ifdef DEBUG
    self.backgroundColor = mAKT_COLOR_Color(255, 0, 0, .2);
#endif
    
    // Setup UI items
    _username = self.username;
    _tfUsername = self.tfUsername;
    _line1 = self.line1;
    _password = self.password;
    _tfPassword = self.tfPassword;
    _line2 = self.line2;
    
    // Add keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUp:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDown:) name:UIKeyboardWillHideNotification object:nil];
    
    self.canAnimate = YES;
}
#pragma mark - property settings
//|---------------------------------------------------------------------------------------------------------------------------
- (UILabel *)username {
    if (_username == nil) {
        _username = [UILabel new];
        [self addSubview:_username];
        _username.textColor = mAKT_Color_Text_XXX;
        _username.font = mAKT_Font_SSS;
        _username.text = @"请输入邮箱";
        [_username setTextAlignment:(NSTextAlignmentCenter)];
    }
    return _username;
}

- (UITextField *)tfUsername {
    if (_tfUsername == nil) {
        _tfUsername = [UITextField new];
        [self addSubview:_tfUsername];
        [_tfUsername setFont:mAKT_Font_SSS];
        [_tfUsername setPlaceholder:@"Darria@sina.com"];
        [_tfUsername setClearButtonMode:(UITextFieldViewModeWhileEditing)];
        [_tfUsername setBorderStyle:(UITextBorderStyleNone)];
        [_tfUsername setKeyboardType:(UIKeyboardTypeEmailAddress)];
        [_tfUsername setTextAlignment:(NSTextAlignmentCenter)];
        [_tfUsername setReturnKeyType:(UIReturnKeyNext)];
        [_tfUsername addTarget:self action:@selector(next:) forControlEvents:(UIControlEventEditingDidEndOnExit)];
//        [_tfUsername setValue:mAKT_T_XX forKeyPath:@"_placeholderLabel.textColor"];
#ifdef DEBUG
        [_tfUsername setBackgroundColor:mAKT_Color_Red];
//        _tfUsername.text = @"sdfsdfsf";
#endif
    }
    return _tfUsername;
}

- (UIView *)line1 {
    if (_line1 == nil) {
        _line1 = [UIView new];
        [self addSubview:_line1];
        _line1.backgroundColor = mAKT_Color_Background_X;
    }
    return _line1;
}

- (UILabel *)password {
    if (_password == nil) {
        _password = [UILabel new];
        [self addSubview:_password];
        _password.textColor = mAKT_Color_Text_XXX;
        _password.font = mAKT_Font_SSS;
        _password.text = @"请输入密码";
        [_password setTextAlignment:(NSTextAlignmentCenter)];
    }
    return _password;
}

- (UITextField *)tfPassword {
    if (_tfPassword == nil) {
        _tfPassword = [UITextField new];
        [self addSubview:_tfPassword];
        [_tfPassword setFont:mAKT_Font_SSS];
        [_tfPassword setPlaceholder:@". . . . . . . ."];
        [_tfPassword setClearButtonMode:(UITextFieldViewModeWhileEditing)];
        [_tfPassword setBorderStyle:(UITextBorderStyleNone)];
        [_tfPassword setKeyboardType:(UIKeyboardTypeEmailAddress)];
        [_tfPassword setSecureTextEntry:YES];
        [_tfPassword setTextAlignment:(NSTextAlignmentCenter)];
        [_tfPassword setReturnKeyType:(UIReturnKeyDone)];
        [_tfPassword addTarget:self action:@selector(done:) forControlEvents:(UIControlEventEditingDidEndOnExit)];
        [_tfPassword setEnablesReturnKeyAutomatically:YES];
//        [_tfPassword setValue:mAKT_T_XX forKeyPath:@"_placeholderLabel.textColor"];
#ifdef DEBUG
        [_tfPassword setBackgroundColor:mAKT_Color_Red];
#endif
    }
    return _tfPassword;
}

- (UIView *)line2 {
    if (_line2 == nil) {
        _line2 = [UIView new];
        [self addSubview:_line2];
        _line2.backgroundColor = mAKT_Color_Background_X;
    }
    return _line2;
}
#pragma mark - click events
//|---------------------------------------------------------------------------------------------------------------------------
- (void)next:(UITextField *)tf {
    self.canAnimate = NO;
    [self.tfUsername resignFirstResponder];
    [self.tfPassword becomeFirstResponder];
    self.canAnimate = YES;
}

- (void)done:(UITextField *)tf {
    [self.tfPassword resignFirstResponder];
}
#pragma mark - notification
//|---------------------------------------------------------------------------------------------------------------------------
- (void)keyboardUp:(NSNotification *)noti {
    if (self.canAnimate == NO) {
        return;
    }
    [UIView animateWithDuration:.25 animations:^{
        self.superview.y = -100;
    }];
}

- (void)keyboardDown:(NSNotification *)noti {
    if (self.canAnimate == NO) {
        return;
    }
    [UIView animateWithDuration:.25 animations:^{
        self.superview.y = 0;
    }];
}
/*
 *       - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 *-------|The following are function implementations that is provided to the external call|
 *       - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 */
#pragma mark - function implementations
//|---------------------------------------------------------------------------------------------------------------------------
+ (void)shakeAnimationWithView:(UIView *)view
{
    CGRect rec = view.frame;
    view.frame = CGRectMake(view.frame.origin.x+20, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:.03f initialSpringVelocity:0.001f options:(UIViewAnimationOptionCurveLinear) animations:^{
        view.frame = rec;
    } completion:^(BOOL finished) {
        nil;
    }];
}
@end
