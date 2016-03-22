//
//  PLAAccounView.h
//  Pursue
//
//  Created by YaHaoo on 16/2/23.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLAAccounView : UIView
///< UI items
@property (strong, nonatomic) UITextField *tfUsername;
@property (strong, nonatomic) UITextField *tfPassword;

+ (void)shakeAnimationWithView:(UIView *)view;
@end
