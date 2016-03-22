//
//  PCInputView.h
//  Pursue
//
//  Created by YaHaoo on 16/2/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCInputView : UIView
///< UI items
@property (strong, nonatomic) UIButton *send;

///< Action
@property (strong, nonatomic) void(^frameChangeAction)(CGRect frame);
@property (strong, nonatomic) void(^sendAction)(NSString *str);
@property (strong, nonatomic) void(^locationAction)();
@end
