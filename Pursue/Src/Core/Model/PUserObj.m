//
//  PUserObj.m
//  Pursue
//
//  Created by baoyx on 16/2/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PUserObj.h"
#import <Wilddog/Wilddog.h>
static NSString * const kWilddogURL = @"https://pursue.wilddogio.com";
@implementation PUserObj
+(PUserObj *)shareInstance
{
    static PUserObj *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[PUserObj alloc] init];
    });
    return obj;
}

+(void)loginWithEmail:(NSString *)email password:(NSString *)password success:(void (^)())success failure:(void (^)(NSString *error))failure
{
    
    
    if (email == nil || [email isEqualToString:@""] || password == nil || [password isEqualToString:@""]) {
        failure(@"用户名或密码为空");
        return;
    }
    Wilddog *ref = [[Wilddog alloc] initWithUrl:kWilddogURL];
    [ref authUser:email password:password withCompletionBlock:^(NSError *error, WAuthData *authData) {
        if (error) {
            switch (error.code) {
                case WAuthenticationErrorUserDoesNotExist:
                    failure(@"用户名或密码错误");
                    break;
                case WAuthenticationErrorInvalidEmail:
                    failure(@"无效电子邮件");
                    break;
                case WAuthenticationErrorInvalidPassword:
                    failure(@"用户名或密码错误");
                    break;
                default:
                    break;
            }
            
            
        }else
        {
            
            NSString *uuid = [(NSString *)authData.uid componentsSeparatedByString:@":"][1];
#ifdef DEBUG
            NSLog(@"uid = %@",uuid);
#endif
            PUserObj *userObj = [[PUserObj alloc] init];
            userObj.userId = uuid;
            success();
        }
    }];
   
}

+(void)registerWithEmail:(NSString *)email password:(NSString *)password success:(void (^)())success failure:(void (^)(NSString *error))failure
{
    if (email == nil || [email isEqualToString:@""] || password == nil || [password isEqualToString:@""]) {
        failure(@"用户名或密码为空");
        return;
    }
    Wilddog *ref = [[Wilddog alloc] initWithUrl:kWilddogURL];
    [ref createUser:email password:password withCompletionBlock:^(NSError *error) {
        if (error) {
            switch (error.code) {
                case WAuthenticationErrorInvalidEmail:
                    failure(@"无效电子邮件");
                    break;
                case WAuthenticationErrorEmailTaken:
                    failure(@"邮箱已经被注册");
                    break;
                default:
                    break;
            }
        }else
        {
            if (success) {
                success();
            }
        }
    }];
}

@end
