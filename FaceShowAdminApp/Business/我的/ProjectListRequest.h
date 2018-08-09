//
//  ProjectListRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/8/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol ProjectListRequestItem_managerScopeList <NSObject> @end
@interface ProjectListRequestItem_managerScopeList : JSONModel
@property (nonatomic, strong) NSString<Optional> *managerScopeID;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *platformManagerId;
@property (nonatomic, strong) NSString<Optional> *provinceId;
@property (nonatomic, strong) NSString<Optional> *cityId;
@property (nonatomic, strong) NSString<Optional> *districtId;
@end

@interface ProjectListRequestItem_institutionInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *institutionID;
@property (nonatomic, strong) NSString<Optional> *institutionName;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *institutionLevel;
@property (nonatomic, strong) NSString<Optional> *provinceId;
@property (nonatomic, strong) NSString<Optional> *cityId;
@property (nonatomic, strong) NSString<Optional> *districtId;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSString<Optional> *projectNum;
@property (nonatomic, strong) NSString<Optional> *managerNum;
@property (nonatomic, strong) NSString<Optional> *areaName;
@end

@protocol ProjectListRequestItem_projectScopeList <NSObject> @end
@interface ProjectListRequestItem_projectScopeList : JSONModel
@property (nonatomic, strong) NSString<Optional> *projectScopeID;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *provinceId;
@property (nonatomic, strong) NSString<Optional> *cityId;
@property (nonatomic, strong) NSString<Optional> *districtId;
@end

@protocol ProjectListRequestItem_elements <NSObject> @end
@interface ProjectListRequestItem_elements : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementID;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *projectName;
@property (nonatomic, strong) NSString<Optional> *projectStatus;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *projectLevel;
@property (nonatomic, strong) NSString<Optional> *projectType;
@property (nonatomic, strong) NSString<Optional> *hasAssign;
@property (nonatomic, strong) NSString<Optional> *createUserId;
@property (nonatomic, strong) NSString<Optional> *institutionId;
@property (nonatomic, strong) NSString<Optional> *projectManagerInfos;
@property (nonatomic, strong) NSString<Optional> *projectStatusName;
@property (nonatomic, strong) NSString<Optional> *manager;
@property (nonatomic, strong) NSArray<ProjectListRequestItem_projectScopeList,Optional> *projectScopeList;
@property (nonatomic, strong) NSString<Optional> *clazsNum;
@property (nonatomic, strong) NSString<Optional> *studentNum;
@property (nonatomic, strong) NSString<Optional> *masterNum;
@property (nonatomic, strong) NSString<Optional> *studentAvgScore;
@property (nonatomic, strong) NSString<Optional> *taskFinishedRate;
@property (nonatomic, strong) NSString<Optional> *projectLikedRate;
@property (nonatomic, strong) NSString<Optional> *appUsedNum;
@property (nonatomic, strong) ProjectListRequestItem_institutionInfo<Optional> *institutionInfo;
@end

@interface ProjectListRequestItem_projectPage : JSONModel
@property (nonatomic, strong) NSArray<ProjectListRequestItem_elements,Optional> *elements;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *pageNum;
@property (nonatomic, strong) NSString<Optional> *offset;
@property (nonatomic, strong) NSString<Optional> *totalElements;
@property (nonatomic, strong) NSString<Optional> *lastPageNumber;
@end

@interface ProjectListRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<Optional> *provinceIdScope;
@property (nonatomic, strong) ProjectListRequestItem_projectPage<Optional> *projectPage;
@property (nonatomic, strong) NSArray<Optional> *districtIdScope;
@property (nonatomic, strong) NSArray<Optional> *cityIdScope;
@property (nonatomic, strong) NSArray<ProjectListRequestItem_managerScopeList,Optional> *managerScopeList;
@end

@interface ProjectListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ProjectListRequestItem_data<Optional> *data;
@end


@interface ProjectListRequest : YXGetRequest
@property (nonatomic, strong) NSString *platId;
@property (nonatomic, strong) NSString *offset;
@property (nonatomic, strong) NSString *pageSize;
@end
