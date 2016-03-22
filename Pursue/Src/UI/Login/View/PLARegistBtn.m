//
//  PLARegistBtn.m
//  Pursue
//
//  Created by YaHaoo on 16/2/23.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PLARegistBtn.h"
#import "AKTKit.h"

@interface PLARegistBtn ()
@property (strong, nonatomic) UIButton *login;
//@property (strong, nonatomic) UIButton *regist;
@property (strong, nonatomic) UILabel *forgotPassword;
@property (strong, nonatomic) UIButton *resetPassword;
@end
@implementation PLARegistBtn
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
    // Login
    [self.login aktLayout:^(AKTLayoutAttribute *layout) {
        layout.left.equalToView(self).offset(25);
        layout.top.equalToView(self);
        layout.height.equalToView(self).multiple(.5);
        layout.right.equalToConstant(self.width/2).offset(-4);
    }];
    
    // Regist
    [self.regist aktLayout:^(AKTLayoutAttribute *layout) {
        layout.right.equalToView(self).offset(-25);
        layout.top.equalToView(self);
        layout.height.equalToView(self.login);
        layout.left.equalToConstant(self.width/2).offset(4);
    }];
    
    // Forgot
    [self.forgotPassword aktLayout:^(AKTLayoutAttribute *layout) {
        layout.top.equalToConstant(self.height/2);
        layout.bottom.equalToView(self);
        layout.left.equalToView(self.login);
        layout.right.equalToConstant(self.width/2);
    }];
    
    // ResetPassword
    [self.resetPassword aktLayout:^(AKTLayoutAttribute *layout) {
        layout.top.equalToConstant(self.height/2);
        layout.width.equalToConstant(100);
        layout.bottom.equalToView(self);
        layout.right.equalToView(self.regist);
    }];
}
#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    // Setup self
#ifdef DEBUG
    self.backgroundColor = mAKT_COLOR_Color(255, 255, 0, .2);
#endif
    
    // Setup UI items
    _login = self.login;
    _regist = self.regist;
    _forgotPassword = self.forgotPassword;
    _resetPassword = self.resetPassword;
}
#pragma mark - property settings
//|---------------------------------------------------------------------------------------------------------------------------
- (UIButton *)login {
    if (_login == nil) {
        _login = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:_login];
        [_login setBackgroundColor:mAKT_COLOR_Color(43, 203, 228, 1)];
        [_login setTitle:@"登录" forState:(UIControlStateNormal)];
        [_login.titleLabel setFont:mAKT_Font_SS];
        [_login setTitleColor:mAKT_Color_Text_X forState:(UIControlStateNormal)];
        [_login addTarget:self action:@selector(login:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _login;
}

- (UIButton *)regist {
    if (_regist == nil) {
        _regist = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:_regist];
        [_regist setBackgroundColor:mAKT_COLOR_Color(79, 126, 218, 1)];
        [_regist setTitle:@"注册" forState:(UIControlStateNormal)];
        [_regist.titleLabel setFont:mAKT_Font_SS];
        [_regist setTitleColor:mAKT_Color_Text_X forState:(UIControlStateNormal)];
        [_regist addTarget:self action:@selector(regist:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _regist;
}

- (UILabel *)forgotPassword {
    if (_forgotPassword == nil) {
        _forgotPassword = [UILabel new];
        [self addSubview:_forgotPassword];
        _forgotPassword.textColor = mAKT_Color_Text_XX;
        _forgotPassword.font = mAKT_Font_SSSS;
        _forgotPassword.text = @"忘记密码？";
#ifdef DEBUG
        _forgotPassword.backgroundColor = mAKT_COLOR_Color(0, 255, 0, .2);
#endif
    }
    return _forgotPassword;
}

- (UIButton *)resetPassword {
    if (_resetPassword == nil) {
        _resetPassword = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:_resetPassword];
        [_resetPassword.titleLabel setTextAlignment:(NSTextAlignmentRight)];
        [_resetPassword setTitle:@"重设密码" forState:(UIControlStateNormal)];
        [_resetPassword.titleLabel setFont:mAKT_Font_SSSS];
        [_resetPassword setTitleColor:mAKT_COLOR_Color(238, 140, 170, 1) forState:(UIControlStateNormal)];
        [_resetPassword setTitleEdgeInsets:(UIEdgeInsetsMake(0, 30, 0, -15))];
        [_resetPassword addTarget:self action:@selector(resetPassword:) forControlEvents:(UIControlEventTouchUpInside)];
#ifdef DEBUG
        _resetPassword.backgroundColor = mAKT_COLOR_Color(0, 255, 0, .2);
#endif
    }
    return _resetPassword;
}
#pragma mark - click events
//|---------------------------------------------------------------------------------------------------------------------------
- (void)login:(UIButton *)btn {
    if (self.loginAction) {
        self.loginAction();
    }
}

- (void)regist:(UIButton *)btn {
    if (self.registAction) {
        self.registAction();
    }
}

- (void)resetPassword:(UIButton *)btn {
    if (self.resetAction) {
        self.resetAction();
    }
}
@end
