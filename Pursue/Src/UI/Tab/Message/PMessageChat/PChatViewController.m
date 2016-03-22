//
//  PChatViewController.m
//  Pursue
//
//  Created by YaHaoo on 16/2/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PChatViewController.h"
#import "AKTKit.h"
#import "PCInputView.h"
#import "PCTableView.h"

@interface PChatViewController ()
///< UI items
@property (strong, nonatomic) PCInputView *inputView;
@property (strong, nonatomic) PCTableView *tableView;
@end
@implementation PChatViewController
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    // Setup navigation bar style
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    //left barButtonItem
    UIBarButtonItem *itemLeft = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"P_Back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    itemLeft.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = itemLeft;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:mAKT_Color_White,
                                                                      NSFontAttributeName:mAKT_Font_SS
                                                                      }];
    self.title = mAKT_LocalStr(@"猎户座");
    
    // Setup my style
    self.view.backgroundColor = mAKT_Color_Background_XX;
    
    // Add UI items
    _inputView = self.inputView;
    _tableView = self.tableView;
}
#pragma mark - property settings
//|---------------------------------------------------------------------------------------------------------------------------
- (PCInputView *)inputView {
    if (_inputView == nil) {
        _inputView = [PCInputView new];
        [self.view addSubview:_inputView];
        [_inputView aktLayout:^(AKTLayoutAttribute *layout) {
            layout.left.bottom.right.equalToView(self.view);
            layout.height.equalToConstant(50);
        }];
        
        // Setup action
        __weak typeof(self) weakself = self;
        [_inputView setFrameChangeAction:^(CGRect newRect) {
            [UIView animateWithDuration:.25 animations:^{
                weakself.tableView.y = newRect.origin.y+newRect.size.height-weakself.tableView.height;
            }];
        }];
        [_inputView setLocationAction:^{
            [weakself locationAction];
        }];
        [_inputView setSendAction:^(NSString *str) {
            [weakself send:str];
        }];
    }
    return _inputView;
}

- (PCTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [PCTableView new];
        [self.view insertSubview:_tableView atIndex:0];
        [_tableView aktLayout:^(AKTLayoutAttribute *layout) {
            layout.top.equalToConstant(64);
            layout.left.bottom.right.equalToView(self.view);
        }];
        _tableView.backgroundColor = mAKT_Color_White;
    }
    return _tableView;
}
#pragma mark - click events
//|---------------------------------------------------------------------------------------------------------------------------
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locationAction {

}

- (void)send:(NSString *)str {

}

@end
