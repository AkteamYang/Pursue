//
//  PLARegistBtn.h
//  Pursue
//
//  Created by YaHaoo on 16/2/23.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLARegistBtn : UIView
@property (strong, nonatomic) UIButton *regist;

///< Actions
@property (strong, nonatomic) void(^loginAction)();
@property (strong, nonatomic) void(^registAction)();
@property (strong, nonatomic) void(^resetAction)();
@end
