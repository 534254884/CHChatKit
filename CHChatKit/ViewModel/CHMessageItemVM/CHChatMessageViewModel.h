//
//  CHMessageViewModel.h
//  CHChatKit
//
//  Created by Chausson on 16/9/21.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "CHChatDefinition.h"

@class CHChatMessageViewModel;
@protocol CHChatMessageViewModelProtocol <NSObject>
@required
- (CHChatMessageType )category;
@end
@interface CHChatMessageViewModel : NSObject

@property (nonatomic ,copy) NSString *icon;
@property (nonatomic ,readonly) NSString *date;
@property (nonatomic ,readonly) NSDate *createDate;
@property (nonatomic ,readonly) NSString *nickName;
@property (nonatomic ,readonly) CHChatMessageType category;
@property (nonatomic ,readonly) CHMessageSendState sendingState;
@property (nonatomic ,readonly , getter= isVisableTime) BOOL visableTime;
@property (nonatomic ,readonly , getter= isOwner) BOOL owner;
@property (nonatomic ,readonly , getter= isVisableNickName) BOOL visableNickName;
@property (nonatomic ,assign) long long receiveId; /* 消息接收人的id 没有的话默认是0 */
@property (nonatomic ,assign) long long senderId; /* 发送消息者的id 没有的话默认是0 */
@property (nonatomic ,assign) long long groupId; /* 群组id 0代表没有群组 */

- (void)sortOutWithTime:(NSString *)time;
/* 处理响应事件  */
- (void)respondsTapAction;
/* 重发消息  */
- (void)resend;

@end
