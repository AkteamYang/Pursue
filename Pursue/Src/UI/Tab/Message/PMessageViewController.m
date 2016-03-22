//
//  PMessageViewController.m
//  Pursue
//
//  Created by YaHaoo on 16/2/22.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PMessageViewController.h"
#import "PMessageTableView.h"
#import "PSendMessageObj.h"
#import "PCInputView.h"

static NSString * str = @"";

@interface PMessageViewController()<PSendMessageObjDelegate>
@property (strong, nonatomic) PMessageTableView *tabelView;
@property (strong, nonatomic) PCInputView *inputView;

@end
@implementation PMessageViewController
{
    __block NSMutableArray *dataArr_;
}
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup UI
    dataArr_ = [NSMutableArray array];
    [self initUI];
    [PSendMessageObj shareInstance].delegate = self;
    [[PSendMessageObj shareInstance] initSendMessageObserveWithSuccess:^(NSArray<PSendMessageObj *> *obj) {
        [dataArr_ addObjectsFromArray:obj];
        [_tabelView reloadData:dataArr_];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [mAKT_APPDELEGATE.window endEditing:YES];
    [UIView animateWithDuration:.25 animations:^{
        self.inputView.alpha = 0;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:.25 animations:^{
        self.inputView.alpha = 1;
    }];
}
#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    // Setup navigation bar style
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.navigationController.navigationBar setBackgroundImage:mAKT_Image(@"P_Navi") forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:mAKT_Color_White,
                                                                      NSFontAttributeName:mAKT_Font_SS
                                                                      }];
    self.title = mAKT_LocalStr(@"消息");
    
    // Setup my style
    self.view.backgroundColor = mAKT_Color_White;
    
    // Add UI items
    _tabelView = self.tabelView;
    _inputView = self.inputView;
}
#pragma mark - property settings
//|---------------------------------------------------------------------------------------------------------------------------
- (PMessageTableView *)tabelView {
    if (_tabelView == nil) {
        _tabelView = [PMessageTableView new];
        [self.view insertSubview:_tabelView atIndex:0];
        [_tabelView aktLayout:^(AKTLayoutAttribute *layout) {
            layout.top.equalToConstant(64);
            layout.left.bottom.right.equalToView(self.view);
        }];
        _tabelView.backgroundColor = mAKT_Color_White;
    }
    return _tabelView;
}

- (PCInputView *)inputView {
    if (_inputView == nil) {
        _inputView = [PCInputView new];
        [mAKT_APPDELEGATE.window addSubview:_inputView];
        [_inputView aktLayout:^(AKTLayoutAttribute *layout) {
            layout.left.bottom.right.equalToView(self.view);
            layout.height.equalToConstant(50);
        }];
        [_inputView.send setTitle:@"发送" forState:(UIControlStateNormal)];
        
        // Setup action
        __weak typeof(self) weakself = self;
        [_inputView setFrameChangeAction:^(CGRect newRect) {

            
        }];
        [_inputView setLocationAction:^{

        }];
        [_inputView setSendAction:^(NSString *str) {

        }];
    }
    return _inputView;
}
#pragma mark - universal methods
//|---------------------------------------------------------------------------------------------------------------------------
/*
 *       - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 *-------|The following are function implementations that is provided to the external call|
 *       - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 */
#pragma mark - function implementations
//|---------------------------------------------------------------------------------------------------------------------------
- (void)addNaviback {
    UIImageView *imgv = [[UIImageView alloc]initWithImage:mAKT_Image(@"P_Navi")];
    [self.view addSubview:imgv];
    imgv.backgroundColor = mAKT_COLOR_Color(69, 202, 215, 1);
    [imgv aktLayout:^(AKTLayoutAttribute *layout) {
        layout.width.equalToView(self.view);
        layout.height.equalToConstant(64);
    }];
    imgv.layer.shadowOpacity = .3;
    imgv.layer.shadowOffset = CGSizeMake(0, 0);
    imgv.layer.shadowRadius = 1;
}

#pragma mark PSendMessageObjDelegate
-(void)receiveSendMessageWithobj:(PSendMessageObj *)obj
{
    [dataArr_ addObject:obj];
    [_tabelView reloadData:dataArr_];
}

@end
