//
//  PLoginAndRegistViewController.m
//  Pursue
//
//  Created by YaHaoo on 16/2/23.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PLoginAndRegistViewController.h"
#import "PRegisterViewController.h"
#import "PMessageViewController.h"
#import "AKTKit.h"
#import "PLAAccounView.h"
#import "PLARegistBtn.h"
#import "PUserObj.h"
#import "NotificationImgView.h"

@interface PLoginAndRegistViewController ()
///< UI items
@property (strong, nonatomic) UIImageView *head;
@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) PLAAccounView *inputView;
@property (strong, nonatomic) PLARegistBtn *regist;
@end
@implementation PLoginAndRegistViewController
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)dealloc
{
    NSLog(@"%@_dealloc",NSStringFromClass(self.class));
}
#pragma mark - super methods
//|---------------------------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    // Setup navigation bar style
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.navigationController.navigationBarHidden = YES;
    
    // Setup self
    self.view.backgroundColor = mAKT_Color_White;
    
    // Setup UI items
    _head = self.head;
    _avatar = self.avatar;
    _inputView = self.inputView;
    _regist = self.regist;
}

- (void)animationToRegisterVc:(PRegisterViewController *)vc {
    UIView *snapshotInputView = [self.inputView snapshotViewAfterScreenUpdates:NO];
    snapshotInputView.frame = self.inputView.frame;
    UIView *snapshotRegister = [self.regist.regist snapshotViewAfterScreenUpdates:NO];
    snapshotRegister.frame = [self.view convertRect:self.regist.regist.frame fromView:self.regist];
    NSArray *currentFrames = @[[NSValue valueWithCGRect:snapshotInputView.frame],[NSValue valueWithCGRect:snapshotRegister.frame]];
    [mAKT_APPDELEGATE.window addSubview:snapshotInputView];
    [mAKT_APPDELEGATE.window addSubview:snapshotRegister];
    mAKT_APPDELEGATE.window.userInteractionEnabled = NO;
    
    // Animation
    [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:0 animations:^{
        [snapshotInputView aktLayout:^(AKTLayoutAttribute *layout) {
            layout.left.right.equalToView(self.view);
            layout.height.equalToConstant(130);
            layout.bottom.equalToConstant(self.view.height/2).offset(-10);
        }];
        [snapshotRegister aktLayout:^(AKTLayoutAttribute *layout) {
            layout.centerX.equalToView(self.view);
            layout.top.equalToConstant(self.view.height/2).offset(10);
            layout.width.equalToConstant(self.view.width/2-25-4);
            layout.height.equalToConstant(110/2);
        }];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.25 animations:^{
            snapshotRegister.alpha = 0;
        } completion:^(BOOL finished) {
            [snapshotRegister removeFromSuperview];
            mAKT_APPDELEGATE.window.userInteractionEnabled = YES;
        }];
        [snapshotInputView removeFromSuperview];
        [vc showWithLastFrames:currentFrames];
    }];
}

- (void)show {
//    self.regist.regist.hidden = NO;
    self.inputView.hidden = NO;
}

- (void)hidden {
//    self.regist.regist.hidden = YES;
    self.inputView.hidden = YES;
}
#pragma mark - property settings
//|---------------------------------------------------------------------------------------------------------------------------
- (UIImageView *)head {
    if (_head == nil) {
        _head = [[UIImageView alloc]initWithImage:mAKT_Image(@"P_Login")];
        [self.view addSubview:_head];
        [_head aktLayout:^(AKTLayoutAttribute *layout) {
            layout.name = @"_head";
//#warning aktlayout bug solved！！
            layout.whRatio.equalToConstant(_head.image.size.width/_head.image.size.height);
            layout.top.left.right.equalToView(self.view);
        }];
        _head.height = self.view.width/(_head.image.size.width/_head.image.size.height);
    }
    return _head;
}

- (UIImageView *)avatar {
    if (_avatar == nil) {
        _avatar = [[UIImageView alloc]initWithImage:mAKT_Image(@"P_Avatar3")];
        [self.head addSubview:_avatar];
        [_avatar aktLayout:^(AKTLayoutAttribute *layout) {
            layout.width.height.equalToConstant(self.view.width*(193/750.0f));
            layout.bottom.equalToConstant(self.head.akt_bottom.floatValue).offset(20);
            layout.centerX.equalToView(self.head);
        }];
        _avatar.layer.cornerRadius = _avatar.width/2;
        _avatar.layer.masksToBounds = YES;
    }
    return _avatar;
}

- (PLAAccounView *)inputView {
    if (_inputView == nil) {
        _inputView = [PLAAccounView new];
        [self.view addSubview:_inputView];
        [_inputView aktLayout:^(AKTLayoutAttribute *layout) {
            layout.left.right.equalToView(self.view);
            layout.height.equalToConstant(130);
            layout.top.equalToConstant(self.head.akt_bottom.floatValue).offset((mAKT_SCREENHEIGHT-505)*.5);
        }];
    }
    return _inputView;
}

- (PLARegistBtn *)regist {
    if (_regist == nil) {
        _regist = [PLARegistBtn new];
        [self.view addSubview:_regist];
        [_regist aktLayout:^(AKTLayoutAttribute *layout) {
            layout.left.right.bottom.equalToView(self.view);
            layout.height.equalToConstant(110);
        }];
        
        // Setup actions
        __weak typeof(self) weakself = self;
        [_regist setLoginAction:^{
            [weakself loginAction];
        }];
        [_regist setRegistAction:^{
            [weakself registAction];
        }];
        [_regist setResetAction:^{
            [weakself resetAction];
        }];
    }
    return _regist;
}
#pragma mark - click events
//|---------------------------------------------------------------------------------------------------------------------------
- (void)loginAction {
    // Check
    if([self.inputView.tfUsername.text isEqualToString:@""] ){
        [PLAAccounView shakeAnimationWithView:self.inputView.tfUsername];
        return;
    }else if ([self.inputView.tfPassword.text isEqualToString:@""]){
        [PLAAccounView shakeAnimationWithView:self.inputView.tfPassword];
        return;
    }
    
    NSString *email = self.inputView.tfUsername.text;
    NSString *password = self.inputView.tfPassword.text;
    
    [PUserObj loginWithEmail:email password:password success:^{
        UIView *snapshot = [self.view snapshotViewAfterScreenUpdates:NO];
        
        PMessageViewController *vc = [PMessageViewController new];
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
        mAKT_APPDELEGATE.window.rootViewController = nv;
        
        [mAKT_APPDELEGATE.window addSubview:snapshot];
        [UIView animateWithDuration:.25 animations:^{
            snapshot.alpha = 0;
        } completion:^(BOOL finished) {
            [snapshot removeFromSuperview];
        }];
    } failure:^(NSString *error) {
        [NotificationImgView notificationWithMessage:error Callback:^{
            
        }];
    }];

    
}

- (void)registAction {
    mAKT_Log(@"register");
    self.inputView.tfUsername.text = self.inputView.tfPassword.text = @"";
    PRegisterViewController *vc = [PRegisterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    [self animationToRegisterVc:vc];
}

- (void)resetAction {
    mAKT_Log(@"reset");
}
#pragma mark - universal methods
//|---------------------------------------------------------------------------------------------------------------------------
@end
