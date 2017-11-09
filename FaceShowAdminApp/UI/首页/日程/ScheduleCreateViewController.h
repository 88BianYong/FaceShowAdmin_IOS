//
//  ScheduleCreateViewController.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "ScheduleDetailRequest.h"
@interface ScheduleCreateViewController : BaseViewController
@property (nonatomic, strong) ScheduleDetailRequestItem_Data_Schedules_Elements *element;
@property (nonatomic, copy) void(^reloadDateBlock)(ScheduleDetailRequestItem_Data_Schedules_Elements *item);
@end
