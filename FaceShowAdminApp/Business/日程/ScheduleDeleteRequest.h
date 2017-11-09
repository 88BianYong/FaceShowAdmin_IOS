//
//  ScheduleDeleteRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface ScheduleDeleteRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *scheduleId;
@end
