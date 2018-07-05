//
//  ScheduleDetailRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol ScheduleDetailRequestItem_Data_Schedules_Elements @end
@interface ScheduleDetailRequestItem_Data_Schedules_Elements : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *subject;
@property (nonatomic, strong) NSString<Optional> *remark;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *imageUrl;
@end
@interface ScheduleDetailRequestItem_Data_Schedules : JSONModel
@property (nonatomic, strong) NSArray<ScheduleDetailRequestItem_Data_Schedules_Elements,Optional> *elements;
@end
@interface ScheduleDetailRequestItem_Data : JSONModel
@property (nonatomic, strong) ScheduleDetailRequestItem_Data_Schedules<Optional> *schedules;
@end
@interface ScheduleDetailRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ScheduleDetailRequestItem_Data<Optional> *data;
@end
@interface ScheduleDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@end
