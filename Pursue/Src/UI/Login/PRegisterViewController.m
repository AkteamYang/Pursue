//
//  PRegisterViewController.m
//  Pursue
//
//  Created by YaHaoo on 16/2/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PRegisterViewController.h"
#import "PMessageViewController.h"
#import "PLoginAndRegistViewController.h"
#import "AKTKit.h"
#import "PLAAccounView.h"
#import "PUserObj.h"
#import "NotificationImgView.h"
@interface PRegisterViewController ()
///< UI items
@property (strong, nonatomic) PLAAccounView *inputView;
@property (strong, nonatomic) UIButton *regist;
@property (strong, nonatomic) UIImageView *naviBackground;
@property (strong, nonatomic) UILabel *copyright;

///< Data
@property (strong, nonatomic) NSArray *lastFrames;
@end
@implementation PRegisterViewController
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
    // Setup navigation
    //left barButtonItem
    UIBarButtonItem *itemLeft = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"P_Back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    itemLeft.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = itemLeft;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:mAKT_Color_White,
                                                                      NSFontAttributeName:mAKT_Font_SS
                                                                      }];
    self.title = mAKT_LocalStr(@"注册新用户");
    
    // Setup self
    self.view.backgroundColor = mAKT_Color_White;
    
    // Setup UI items
    _inputView = self.inputView;
    _regist = self.regist;
    _naviBackground = self.naviBackground;
    _copyright = self.copyright;
}

- (void)animationToRegisterVc:(PLoginAndRegistViewController *)vc {
    UIView *snapshotInputView = [self.inputView snapshotViewAfterScreenUpdates:NO];
    snapshotInputView.frame = self.inputView.frame;
    [mAKT_APPDELEGATE.window addSubview:snapshotInputView];
    [vc hidden];
    mAKT_APPDELEGATE.window.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:0 animations:^{
        snapshotInputView.frame = [self.lastFrames[0] CGRectValue];
    } completion:^(BOOL finished) {
        [snapshotInputView removeFromSuperview];
        [vc show];
        mAKT_APPDELEGATE.window.userInteractionEnabled = YES;
    }];
}

- (void)showWithLastFrames:(NSArray *)frames {
    self.inputView.hidden = NO;
    self.regist.hidden = NO;
    self.lastFrames = frames;
}
#pragma mark - property settings
//|---------------------------------------------------------------------------------------------------------------------------
- (PLAAccounView *)inputView {
    if (_inputView == nil) {
        _inputView = [PLAAccounView new];
        [self.view addSubview:_inputView];
        [_inputView aktLayout:^(AKTLayoutAttribute *layout) {
            layout.left.right.equalToView(self.view);
            layout.height.equalToConstant(130);
            layout.bottom.equalToConstant(self.view.height/2).offset(-10);
        }];
        _inputView.hidden = YES;
    }
    return _inputView;
}

- (UIButton *)regist {
    if (_regist == nil) {
        _regist = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.view addSubview:_regist];
        [_regist setBackgroundColor:mAKT_COLOR_Color(79, 126, 218, 1)];
        [_regist setTitle:@"注册" forState:(UIControlStateNormal)];
        [_regist.titleLabel setFont:mAKT_Font_SS];
        [_regist setTitleColor:mAKT_Color_Text_X forState:(UIControlStateNormal)];
        [_regist addTarget:self action:@selector(regist:) forControlEvents:(UIControlEventTouchUpInside)];
        [_regist aktLayout:^(AKTLayoutAttribute *layout) {
            layout.centerX.equalToView(self.view);
            layout.top.equalToConstant(self.view.height/2).offset(10);
            layout.width.equalToConstant(self.view.width/2-25-4);
            layout.height.equalToConstant(110/2);
        }];
        _regist.hidden = YES;
    }
    return _regist;
}

- (UIImageView *)naviBackground {
    if (_naviBackground == nil) {
        _naviBackground = [[UIImageView alloc]initWithImage:mAKT_Image(@"P_Navi")];
        [self.view addSubview:_naviBackground];
        [_naviBackground aktLayout:^(AKTLayoutAttribute *layout) {
            layout.top.left.right.equalToView(self.view);
            layout.height.equalToConstant(64);
        }];
        _naviBackground.alpha = 0;
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:0 animations:^{
            _naviBackground.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    return _naviBackground;
}

- (UILabel *)copyright {
    if (_copyright == nil) {
        _copyright = [UILabel new];
        [self.view addSubview:_copyright];
        _copyright.textColor = mAKT_Color_Text_XX;
        _copyright.font = mAKT_Font_SSSSS;
        _copyright.text = @"Pursue. All rights reserved";
        [_copyright setTextAlignment:(NSTextAlignmentCenter)];
        [_copyright aktLayout:^(AKTLayoutAttribute *layout) {
            layout.centerX.equalToView(self.view);
//            layout.height.equalToConstant(50);
            layout.bottom.equalToView(self.view);
        }];
#ifdef DEBUG
        _copyright.backgroundColor = mAKT_COLOR_Color(0, 255, 0, .2);
#endif
    }
    return _copyright;
}
#pragma mark - click events
//|---------------------------------------------------------------------------------------------------------------------------
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    [self animationToRegisterVc:self.navigationController.viewControllers.firstObject];
}

- (void)regist:(UIButton *)btn {
    // UI: ViewController transition when completing register
    // Get snapshot of current view
    UIView *snapshot = [self.view snapshotViewAfterScreenUpdates:NO];
    // Change window's rootViewController
    NSString *email = self.inputView.tfUsername.text;
    NSString *passWord = self.inputView.tfPassword.text;
    // Transsit to new rootViewController
    PMessageViewController *vc = [PMessageViewController new];
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
    mAKT_APPDELEGATE.window.rootViewController = nv;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [mAKT_APPDELEGATE.window addSubview:snapshot];
    [UIView animateWithDuration:.25 animations:^{
        snapshot.alpha = 0;
    } completion:^(BOOL finished) {
        [snapshot removeFromSuperview];
    }];
    
    [PUserObj registerWithEmail:email password:passWord success:^{
        [PUserObj loginWithEmail:email password:passWord success:^{
            UIView *snapshot = [self.view snapshotViewAfterScreenUpdates:NO];
            PMessageViewController *vc = [PMessageViewController new];
            UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
            mAKT_APPDELEGATE.window.rootViewController = nv;
            [self.navigationController popToRootViewControllerAnimated:NO];
            
            [mAKT_APPDELEGATE.window addSubview:snapshot];
            [UIView animateWithDuration:.25 animations:^{
                snapshot.alpha = 0;
            } completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
            }];
        } failure:^(NSString *error) {
            
        }];
    } failure:^(NSString *error) {
        [NotificationImgView notificationWithMessage:error Callback:^{
            
        }];
    }];
    
    

}
@end
