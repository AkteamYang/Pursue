//
//  PSendMessageObj.m
//  Pursue
//
//  Created by baoyx on 16/2/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PSendMessageObj.h"
#import "PUserObj.h"
#import <Wilddog.h>
static NSString * const kWilddogURL = @"https://pursue.wilddogio.com";
@implementation PSendMessageObj
{
    __block NSMutableArray *keyArr_;
}
+(PSendMessageObj *)shareInstance
{
    static PSendMessageObj *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[PSendMessageObj alloc] init];
    });
    return obj;
}

-(instancetype)init
{
    if (self = [super init]) {
        keyArr_ = [NSMutableArray array];
    }
    return self;
}
+(void)sendMessageWithModel:(PSendMessageObj *)obj success:(void (^)())success failure:(void (^)())failure
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *key = [NSString stringWithFormat:@"%@-%@",timeSp,[PUserObj shareInstance].userId];
    NSString *url = [NSString stringWithFormat:@"%@/sendMessage/%@",kWilddogURL,key];
    Wilddog *ref = [[Wilddog alloc] initWithUrl:url];
    NSDictionary *value = @{@"time":timeSp,
                            @"la":@(obj.la),
                            @"lo":@(obj.lo),
                            @"locationDescription":obj.locationDescription,
                            @"bonus":@(obj.bonus),
                            @"message":obj.message,
                            @"status":@(MessageStatusUnread),
                            @"key":key,
                            @"uuid":[PUserObj shareInstance].userId};
    [ref setValue:value withCompletionBlock:^(NSError *error, Wilddog *ref) {
        if (error) {
            if (failure) {
                failure();
            }
        }else
        {
            if (success) {
                success();
            }
            
        }
    }];
    NSString *replyUrl = [NSString stringWithFormat:@"%@/replyMessage",kWilddogURL];
    [[PSendMessageObj shareInstance] observeWithUrl:replyUrl key:obj.key];
}
+(void)replyMessageWithsendMessageModel:(PSendMessageObj *)obj message:(NSString *)message success:(void (^)())success failure:(void (^)())failure
{
    NSString *sendUrl = [NSString stringWithFormat:@"%@/sendMessage/%@",kWilddogURL,obj.key];
    Wilddog *sendRef = [[Wilddog alloc] initWithUrl:sendUrl];
    NSDictionary *sendValue = @{@"time":obj.time,
                                @"la":@(obj.la),
                                @"lo":@(obj.lo),
                                @"locationDescription":obj.locationDescription,
                                @"bonus":@(obj.bonus),
                                @"message":obj.message,
                                @"status":@(MessageStatusRead),
                                @"key":obj.key,
                                @"uuid":obj.uuid};
    [sendRef updateChildValues:sendValue];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *key = [NSString stringWithFormat:@"%@-%@",timeSp,[PUserObj shareInstance].userId];
    NSString *replyUrl = [NSString stringWithFormat:@"%@/replyMessage/%@",kWilddogURL,obj.key];
    Wilddog *replyRef = [[Wilddog alloc] initWithUrl:replyUrl];
    
    NSDictionary *replyValue = @{@"time":timeSp,
                                 @"sendKey":obj.key,
                                 @"key":key,
                                 @"message":message,
                                 };
    [replyRef setValue:replyValue withCompletionBlock:^(NSError *error, Wilddog *ref) {
        if (error) {
            if (failure) {
                failure();
            }
        }else
        {
            if (success) {
                success();
            }
            
        }
    }];
    sendValue = @{@"time":obj.time,
                  @"la":@(obj.la),
                  @"lo":@(obj.lo),
                  @"locationDescription":obj.locationDescription,
                  @"bonus":@(obj.bonus),
                  @"message":obj.message,
                  @"status":@(MessageStatusReplied),
                  @"key":obj.key,
                  @"uuid":obj.uuid};
    [sendRef updateChildValues:sendValue];
}

-(void)initSendMessageObserveWithSuccess:(void (^)(NSArray<PSendMessageObj *> *))success
{
    NSString *url = [NSString stringWithFormat:@"%@/sendMessage",kWilddogURL];
    Wilddog *ref = [[Wilddog alloc] initWithUrl:url];
    [[[ref queryOrderedByChild:@"status"] queryEqualToValue:@(MessageStatusUnread)] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        if (snapshot.childrenCount >0) {
            NSLog(@"keyArr_ = %@",keyArr_);
            NSMutableArray *messages = [NSMutableArray array];
            NSDictionary *dic = (NSDictionary *)snapshot.value;
            NSArray *keys = [dic allKeys];
            for (NSString *key in keys) {
                NSDictionary *message = dic[key];
                if (![message[@"uuid"] isEqualToString:[PUserObj shareInstance].userId]) {
                    if ([keyArr_ count] > 0) {
                        if (![keyArr_ containsObject:message[@"key"]]) {
                            PSendMessageObj *obj = [[PSendMessageObj alloc] init];
                            obj.key = message[@"key"];
                            obj.time = message[@"time"];
                            obj.la = [message[@"la"] floatValue];
                            obj.lo = [message[@"lo"] floatValue];
                            obj.locationDescription = dic[@"locationDescription"];
                            obj.bonus = [message[@"bonus"] floatValue];
                            obj.message = message[@"message"];
                            obj.status = [message[@"status"] integerValue];
                            obj.uuid = message[@"uuid"];
                            [keyArr_ addObject:obj.key];
                            [messages addObject:obj];
                        }
                    }else
                    {
                        PSendMessageObj *obj = [[PSendMessageObj alloc] init];
                        obj.key = message[@"key"];
                        obj.time = message[@"time"];
                        obj.la = [message[@"la"] floatValue];
                        obj.lo = [message[@"lo"] floatValue];
                        obj.locationDescription = message[@"locationDescription"];
                        obj.bonus = [message[@"bonus"] floatValue];
                        obj.message = message[@"message"];
                        obj.status = [message[@"status"] integerValue];
                        obj.uuid = message[@"uuid"];
                        [keyArr_ addObject:obj.key];
                        [messages addObject:obj];
                    }
                    
                }
            }
            success(messages);
        }else
        {
            success(nil);
        }
    }];
    
    [ref observeEventType:WEventTypeChildAdded withBlock:^(WDataSnapshot *snapshot) {
        NSDictionary *dic = (NSDictionary *)snapshot.value;
        if (![dic[@"uuid"] isEqualToString:[PUserObj shareInstance].userId]) {
            if ([keyArr_ count] >0) {
                if (![keyArr_ containsObject:dic[@"key"]]) {
                    PSendMessageObj *obj = [[PSendMessageObj alloc] init];
                    obj.key = dic[@"key"];
                    obj.time = dic[@"time"];
                    obj.la = [dic[@"la"] floatValue];
                    obj.lo = [dic[@"lo"] floatValue];
                    obj.locationDescription = dic[@"locationDescription"];
                    obj.bonus = [dic[@"bonus"] floatValue];
                    obj.message = dic[@"message"];
                    obj.status = [dic[@"status"] integerValue];
                    obj.uuid = dic[@"uuid"];
                     [keyArr_ addObject:obj.key];
                    //代理
                    if (_delegate && [_delegate respondsToSelector:@selector(receiveSendMessageWithobj:)]) {
                        [_delegate receiveSendMessageWithobj:obj];
                    }
                }
                
            }else
            {
                PSendMessageObj *obj = [[PSendMessageObj alloc] init];
                obj.key = dic[@"key"];
                obj.time = dic[@"time"];
                obj.la = [dic[@"la"] floatValue];
                obj.lo = [dic[@"lo"] floatValue];
                obj.locationDescription = dic[@"locationDescription"];
                obj.bonus = [dic[@"bonus"] floatValue];
                obj.message = dic[@"message"];
                obj.status = [dic[@"status"] integerValue];
                obj.uuid = dic[@"uuid"];
                [keyArr_ addObject:obj.key];
                //代理
                if (_delegate && [_delegate respondsToSelector:@selector(receiveSendMessageWithobj:)]) {
                    [_delegate receiveSendMessageWithobj:obj];
                }
            }
        }
    }];
}

-(void)initReplyMessageObserveWithSuccess:(void (^)(NSArray<PSendMessageObj *> *))success
{
    NSString *url = [NSString stringWithFormat:@"%@/sendMessage",kWilddogURL];
    Wilddog *ref = [[Wilddog alloc] initWithUrl:url];
    [[[ref queryOrderedByChild:@"uuid"] queryEqualToValue:[PUserObj shareInstance].userId] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        if (snapshot.childrenCount >0) {
            NSMutableArray *messages = [NSMutableArray array];
            for (NSDictionary *dic in (NSDictionary *)snapshot.value) {
                if ([dic[@"status"] integerValue] == MessageStatusUnread) {
                    PSendMessageObj *obj = [[PSendMessageObj alloc] init];
                    obj.key = dic[@"key"];
                    obj.time = dic[@"time"];
                    obj.la = [dic[@"la"] floatValue];
                    obj.lo = [dic[@"lo"] floatValue];
                    obj.locationDescription = dic[@"locationDescription"];
                    obj.bonus = [dic[@"bonus"] floatValue];
                    obj.message = dic[@"message"];
                    obj.status = [dic[@"status"] integerValue];
                    obj.uuid = dic[@"uuid"];
                    [messages addObject:obj];
                    NSString *replyUrl = [NSString stringWithFormat:@"%@/replyMessage",kWilddogURL];
                    [self observeWithUrl:replyUrl key:obj.key];
                }
            }
            success(messages);
        }else
        {
            success(nil);
        }
    }];
}
-(void)observeWithUrl:(NSString *)url key:(NSString *)key
{
    Wilddog *ref = [[Wilddog alloc] initWithUrl:url];
    [[[ref queryOrderedByChild:@"sendkey"] queryEqualToValue:key] observeEventType:WEventTypeChildAdded withBlock:^(WDataSnapshot *snapshot) {
        if (snapshot.childrenCount > 0) {
            NSDictionary *dic = (NSDictionary *)snapshot.value;
            if ([dic[@"sendkey"] containsString:[NSString stringWithFormat:@"-%@",[PUserObj shareInstance].userId]]) {
                //代理
                if (_delegate && [_delegate respondsToSelector:@selector(receiveReplyMessageWith:key:)]) {
                    [_delegate receiveReplyMessageWith:dic[@"message"] key:dic[@"sendKey"]];
                }
            }
        }
    }];
}

@end
