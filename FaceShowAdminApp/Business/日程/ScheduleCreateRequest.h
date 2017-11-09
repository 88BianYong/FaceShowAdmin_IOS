//
//  ScheduleCreateRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "ScheduleDetailRequest.h"
@interface ScheduleCreateRequestItem_Data : JSONModel
@property (nonatomic, strong) ScheduleDetailRequestItem_Data_Schedules_Elements<Optional> *schedule;
@end

@interface ScheduleCreateRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ScheduleCreateRequestItem_Data<Optional> *data;
@end
@interface ScheduleCreateRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *subject;
@property (nonatomic, strong) NSString<Optional> *imageUrl;
@end
