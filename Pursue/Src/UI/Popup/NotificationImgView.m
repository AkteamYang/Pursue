//
//  NotificationImgView.m
//  Coolhear 3D
//
//  Created by YaHaoo on 15/12/3.
//  Copyright © 2015年 CoolHear. All rights reserved.
//

#import "NotificationImgView.h"
#import "AKTPublic.h"
#import "Masonry.h"
@implementation NotificationImgView
+ (void)notificationWithMessage:(NSString *)str Callback:(Callback)callback
{
    UIView *lastView = [mAKT_APPDELEGATE.window viewWithTag:2015];
    [lastView removeFromSuperview];
    UIView *container = [[UIView alloc]init];
    container.tag = 2015;
    [mAKT_APPDELEGATE.window addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(container.superview);
        make.centerY.equalTo(@(mAKT_SCREENHEIGHT*.15));
    }];
    container.backgroundColor = mAKT_COLOR_Color(0, 0, 0, .6);
    container.layer.cornerRadius = 4;
    
    UILabel *label = [[UILabel alloc]init];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(container);
        make.width.lessThanOrEqualTo(@(mAKT_SCREENWITTH*2/3));
        make.height.lessThanOrEqualTo(@(mAKT_SCREENWITTH*2/3));
    }];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setNumberOfLines:0];
    [label setLineBreakMode:(NSLineBreakByTruncatingTail)];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    label.text = str;
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top).offset(-10);
        make.bottom.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left).offset(-10);
        make.right.equalTo(label.mas_right).offset(10);
    }];
    container.alpha = 0;
    [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:.5 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        container.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.25 delay:1.5 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
            container.alpha = 0;
        } completion:^(BOOL finished) {
            [container removeFromSuperview];
            if(callback){callback();}
        }];
    }];
}
@end
