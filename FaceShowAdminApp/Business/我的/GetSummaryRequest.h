//
//  GetSummaryRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetSummaryRequestItem_projectSatisfiedTop_project:JSONModel
@property (nonatomic, strong) NSString<Optional> *projectName;
@end

@protocol GetSummaryRequestItem_projectSatisfiedTop<NSObject>
@end
@interface GetSummaryRequestItem_projectSatisfiedTop:JSONModel
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *projectType;
@property (nonatomic, strong) NSString<Optional> *projectTypeName;
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *score;
@property (nonatomic, strong) NSString<Optional> *totalCount;
@property (nonatomic, strong) NSString<Optional> *percent;
@property (nonatomic, strong) NSString<Optional> *course;
@property (nonatomic, strong) GetSummaryRequestItem_projectSatisfiedTop_project<Optional> *project;
@end

@protocol GetSummaryRequestItem_onGoingprojectList<NSObject>
@end
@interface GetSummaryRequestItem_onGoingprojectList:JSONModel
@property (nonatomic, strong) NSString<Optional> *projectID;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *projectName;
@property (nonatomic, strong) NSString<Optional> *projectStatus;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *projectStatusName;
@end

@protocol GetSummaryRequestItem_projectStatisticInfo<NSObject>
@end
@interface GetSummaryRequestItem_projectStatisticInfo:JSONModel
@property (nonatomic, strong) NSString<Optional> *projectLevel;
@property (nonatomic, strong) NSString<Optional> *projectLevelName;
@property (nonatomic, strong) NSString<Optional> *projectType;
@property (nonatomic, strong) NSString<Optional> *projectTypeName;
@property (nonatomic, strong) NSString<Optional> *provinceId;
@property (nonatomic, strong) NSString<Optional> *cityId;
@property (nonatomic, strong) NSString<Optional> *districtId;
@property (nonatomic, strong) NSString<Optional> *projectNum;
@end

@interface GetSummaryRequestItem_platformStatisticInfo:JSONModel
@property (nonatomic, strong) NSString<Optional> *projectNum;
@property (nonatomic, strong) NSString<Optional> *studentNum;
@property (nonatomic, strong) NSString<Optional> *teacherNum;
@property (nonatomic, strong) NSString<Optional> *clazsNum;
@property (nonatomic, strong) NSString<Optional> *courseNum;
@property (nonatomic, strong) NSString<Optional> *taskFinishPercent;
@property (nonatomic, strong) NSString<Optional> *signPercent;
@property (nonatomic, strong) NSString<Optional> *projectSatisfiedPercent;
@property (nonatomic, strong) NSString<Optional> *groupByType;
@property (nonatomic, strong) NSArray<GetSummaryRequestItem_projectStatisticInfo,Optional> *projectStatisticInfoListLevel;
@property (nonatomic, strong) NSArray<GetSummaryRequestItem_projectStatisticInfo,Optional> *projectStatisticInfoListType;
@property (nonatomic, strong) NSArray<GetSummaryRequestItem_projectStatisticInfo,Optional> *projectStatisticInfoListArea;
@property (nonatomic, strong) NSArray<GetSummaryRequestItem_onGoingprojectList,Optional> *onGoingprojectList;
@property (nonatomic, strong) NSArray<GetSummaryRequestItem_projectSatisfiedTop,Optional> *projectSatisfiedTop;
@end

@interface GetSummaryRequestItem_data:JSONModel
@property (nonatomic, strong) GetSummaryRequestItem_platformStatisticInfo<Optional> *platformStatisticInfo;
@end

@interface GetSummaryRequestItem:HttpBaseRequestItem
@property (nonatomic, strong) GetSummaryRequestItem_data<Optional> *data;
@end

// http://wiki.yanxiu.com/pages/viewpage.action?pageId=12331510
@interface GetSummaryRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *provinceId;
@property (nonatomic, strong) NSString<Optional> *cityId;
@property (nonatomic, strong) NSString<Optional> *districtId;
@property (nonatomic, strong) NSString<Optional> *groupByType;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@end
