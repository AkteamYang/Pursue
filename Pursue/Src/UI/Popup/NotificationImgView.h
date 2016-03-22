//
//  NotificationImgView.h
//  Coolhear 3D
//
//  Created by YaHaoo on 15/12/3.
//  Copyright © 2015年 CoolHear. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Callback)();
@interface NotificationImgView : UIImageView
+ (void)notificationWithMessage:(NSString *)str Callback:(Callback)callback;

@end
