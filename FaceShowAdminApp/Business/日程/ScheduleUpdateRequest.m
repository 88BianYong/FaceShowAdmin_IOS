//
//  ScheduleUpdateRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScheduleUpdateRequest.h"
@implementation ScheduleUpdateRequestItem_Data
@end
@implementation ScheduleUpdateRequestItem
@end
@implementation ScheduleUpdateRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"schedule.update";
    }
    return self;
}
@end
