//
//  ScheduleCreateRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScheduleCreateRequest.h"
@implementation ScheduleCreateRequestItem_Data
@end
@implementation ScheduleCreateRequestItem
@end
@implementation ScheduleCreateRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"schedule.new";
    }
    return self;
}
@end
