//
//  ScheduleDetailRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScheduleDetailRequest.h"
@implementation ScheduleDetailRequestItem_attachmentInfo
@end

@implementation ScheduleDetailRequestItem_Data_Schedules_Elements
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end
@implementation ScheduleDetailRequestItem_Data_Schedules
@end
@implementation ScheduleDetailRequestItem_Data
@end
@implementation ScheduleDetailRequestItem
@end
@implementation ScheduleDetailRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"schedule.list";
        self.isApp = @"1";
    }
    return self;
}
@end
