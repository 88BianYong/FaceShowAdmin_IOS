//
//  ClazsGetClazsRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface ClazsGetClazsRequestItem_Data_ClazsStatisticView: JSONModel
@property (nonatomic, strong) NSString<Optional> *courseNum;
@property (nonatomic, strong) NSString<Optional> *taskNum;
@property (nonatomic, strong) NSString<Optional> *studensNum;
@property (nonatomic, strong) NSString<Optional> *masterNum;
@end
@interface ClazsGetClazsRequestItem_Data_ClazsInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *clazsName;
@property (nonatomic, strong) NSString<Optional> *clazsStatus;
@property (nonatomic, strong) NSString<Optional> *clazsType;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *isMaster;
@property (nonatomic, strong) NSString<Optional> *clazsStatusName;
@end
@protocol ClazsGetClazsRequestItem_Data_TodaySignIns
@end
@interface ClazsGetClazsRequestItem_Data_TodaySignIns : JSONModel
@property (nonatomic, strong) NSString<Optional> *signInId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *signinType;
@property (nonatomic, strong) NSString<Optional> *antiCheat;
@property (nonatomic, strong) NSString<Optional> *qrcodeRefreshRate;
@property (nonatomic, strong) NSString<Optional> *signinPosition;
@property (nonatomic, strong) NSString<Optional> *positionRange;
@property (nonatomic, strong) NSString<Optional> *positionSite;
@property (nonatomic, strong) NSString<Optional> *successPrompt;
@property (nonatomic, strong) NSString<Optional> *openStatus;
@property (nonatomic, strong) NSString<Optional> *bizId;
@property (nonatomic, strong) NSString<Optional> *bizSource;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *stepFinished;
@property (nonatomic, strong) NSString<Optional> *stepFinishedTime;
@property (nonatomic, strong) NSString<Optional> *totalUserNum;
@property (nonatomic, strong) NSString<Optional> *signInUserNum;
@property (nonatomic, strong) NSString<Optional> *opentStatusName;
@property (nonatomic, strong) NSString<Optional> *percent;
@end

@interface ClazsGetClazsRequestItem_Data_ProjectInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *projectName;
@property (nonatomic, strong) NSString<Optional> *projectStatus;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *desc;
@end
@protocol ClazsGetClazsRequestItem_Data_TodayCourses_LecturerInfos
@end
@interface ClazsGetClazsRequestItem_Data_TodayCourses_LecturerInfos : JSONModel
@property (nonatomic, strong) NSString<Optional> *lecturerName;
@property (nonatomic, strong) NSString<Optional> *lecturerBriefing;
@property (nonatomic, strong) NSString<Optional> *lecturerAvatar;
@end
@protocol ClazsGetClazsRequestItem_Data_TodayCourses
@end
@interface ClazsGetClazsRequestItem_Data_TodayCourses : JSONModel
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *subscriberId;
@property (nonatomic, strong) NSString<Optional> *subscriberType;
@property (nonatomic, strong) NSString<Optional> *courseName;
@property (nonatomic, strong) NSString<Optional> *site;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *courseStatus;
@property (nonatomic, strong) NSString<Optional> *lecturer;
@property (nonatomic, strong) NSArray<ClazsGetClazsRequestItem_Data_TodayCourses_LecturerInfos, Optional> *lecturerInfos;
@end

@interface ClazsGetClazsRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<ClazsGetClazsRequestItem_Data_TodayCourses,Optional> *todayCourses;
@property (nonatomic, strong) NSArray<ClazsGetClazsRequestItem_Data_TodaySignIns,Optional> *todaySignIns;
@property (nonatomic, strong) ClazsGetClazsRequestItem_Data_ProjectInfo *projectInfo;
@property (nonatomic, strong) ClazsGetClazsRequestItem_Data_ClazsInfo *clazsInfo;
@property (nonatomic, strong) ClazsGetClazsRequestItem_Data_ClazsStatisticView *clazsStatisticView;
@end

@interface ClazsGetClazsRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ClazsGetClazsRequestItem_Data<Optional> *data;
@end
@interface ClazsGetClazsRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;

@end
