//
//  GetCourseListRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetCourseListRequestItem_step <NSObject>
@end
@interface GetCourseListRequestItem_step : JSONModel
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *interactName;
@property (nonatomic, strong) NSString<Optional> *interactType;
@property (nonatomic, strong) NSString<Optional> *interactId;
@property (nonatomic, strong) NSString<Optional> *stepStatus;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *stepFinished;
@property (nonatomic, strong) NSString<Optional> *interactTypeName;
@property (nonatomic, strong) NSString<Optional> *totalStudentNum;
@property (nonatomic, strong) NSString<Optional> *finishedStudentNum;
@end

@protocol GetCourseListRequestItem_LecturerInfo <NSObject>
@end
@interface GetCourseListRequestItem_LecturerInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *lecturerName;
@property (nonatomic, strong) NSString<Optional> *lecturerBriefing;
@property (nonatomic, strong) NSString<Optional> *lecturerAvatar;
@end

@protocol GetCourseListRequestItem_coursesList <NSObject>
@end
@interface GetCourseListRequestItem_coursesList : JSONModel
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *subscriberId;
@property (nonatomic, strong) NSString<Optional> *subscriberType;
@property (nonatomic, strong) NSString<Optional> *courseName;
@property (nonatomic, strong) NSString<Optional> *site;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *courseStatus;
@property (nonatomic, strong) NSString<Optional> *lecturer;
@property (nonatomic, strong) NSArray<GetCourseListRequestItem_LecturerInfo,  Optional> *lecturerInfos;
@property (nonatomic, strong) NSArray<GetCourseListRequestItem_step,  Optional> *steps;
@end

@protocol GetCourseListRequestItem_courses <NSObject>
@end
@interface GetCourseListRequestItem_courses : JSONModel
@property (nonatomic, strong) NSString<Optional> *date;
@property (nonatomic, strong) NSString<Optional> *isToday;
@property (nonatomic, strong) NSArray<Optional,GetCourseListRequestItem_coursesList> *coursesList;
@end

@interface GetCourseListRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<Optional,GetCourseListRequestItem_courses> *courses;
@end

@interface GetCourseListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetCourseListRequestItem_data<Optional> *data;
@end

@interface GetCourseListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@end
