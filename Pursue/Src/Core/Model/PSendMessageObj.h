//
//  PSendMessageObj.h
//  Pursue
//
//  Created by baoyx on 16/2/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,MessageStatus) {
    MessageStatusUnread = 1, //未读
    MessageStatusRead,  //已读
    MessageStatusReplied, //已回复
};
@class PSendMessageObj;
@protocol  PSendMessageObjDelegate<NSObject>
-(void)receiveReplyMessageWith:(NSString *)message key:(NSString *)key;
-(void)receiveSendMessageWithobj:(PSendMessageObj *)obj;
@end

@interface PSendMessageObj : NSObject
@property (copy,nonatomic) NSString *key;
@property (copy,nonatomic) NSString *time;
@property (assign,nonatomic) float la;
@property (assign,nonatomic) float lo;
@property (copy,nonatomic) NSString *locationDescription;
@property (assign,nonatomic) float bonus; //奖金
@property (copy,nonatomic) NSString *message;
@property (assign,nonatomic) MessageStatus status;
@property (copy,nonatomic) NSString *uuid;
@property (weak,nonatomic) id<PSendMessageObjDelegate>delegate;


+(PSendMessageObj *)shareInstance;
+(void)sendMessageWithModel:(PSendMessageObj *)obj
                    success:(void(^)())success
                    failure:(void(^)())failure;
+(void)replyMessageWithsendMessageModel:(PSendMessageObj *)obj
                                message:(NSString *)message
                                success:(void(^)())success
                                failure:(void(^)())failure;

-(void)initReplyMessageObserveWithSuccess:(void(^)(NSArray<PSendMessageObj *>*obj))success;
-(void)initSendMessageObserveWithSuccess:(void(^)(NSArray<PSendMessageObj *>*obj))success;
@end
