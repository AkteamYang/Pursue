//
//  PUserObj.h
//  Pursue
//
//  Created by baoyx on 16/2/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUserObj : NSObject
@property (nonatomic,copy) NSString *userId;
+(PUserObj*)shareInstance;
/**
 *  注册用户
 *
 *  @param email    邮箱
 *  @param password 密码
 *  @param success  注册成功
 *  @param failure  注册失败
 */
+(void)registerWithEmail:(NSString *)email
                password:(NSString *)password
                 success:(void(^)())success
                 failure:(void(^)(NSString *error))failure;
/**
 *  用户登录
 *
 *  @param email    邮箱
 *  @param password 密码
 *  @param success  登录成功
 *  @param failure  登录失败
 */
+(void)loginWithEmail:(NSString *)email
             password:(NSString *)password
              success:(void(^)())success
              failure:(void(^)(NSString *error))failure;
@end
