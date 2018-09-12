//
//  IMEventHandler.h
//  TestIM
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EventType) {
    EventType_NewTopic = 101,//V1.2.2 禁言也走此事件 免打扰
    EventType_TopicAddMember = 111,
    EventType_TopicRemoveMember = 112,
    EventType_NewMessage = 121
};

@interface IMEventHandler : NSObject
- (void)handleData:(NSData *)data inTopic:(NSString *)topic;
@end
