//
//  ScheduleDeleteRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScheduleDeleteRequest.h"

@implementation ScheduleDeleteRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"schedule.del";
    }
    return self;
}
@end
