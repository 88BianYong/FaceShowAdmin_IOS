//
//  ProjectDetailRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol ProjectDetailRequestItem_clazs<NSObject>
@end
@interface ProjectDetailRequestItem_clazs:JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *clazsName;
@end

@interface ProjectDetailRequestItem_projectCount:JSONModel
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *projectName;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *clazsNum;
@property (nonatomic, strong) NSString<Optional> *studentNum;
@property (nonatomic, strong) NSString<Optional> *masterNum;
@property (nonatomic, strong) NSString<Optional> *studentAvgScore;
@property (nonatomic, strong) NSString<Optional> *taskFinishedRate;
@property (nonatomic, strong) NSString<Optional> *projectLikedRate;
@end

@interface ProjectDetailRequestItem_data:JSONModel
@property (nonatomic, strong) ProjectDetailRequestItem_projectCount<Optional> *projectCount;
@property (nonatomic, strong) NSArray<ProjectDetailRequestItem_clazs,Optional> *clazses;
@end

@interface ProjectDetailRequestItem:HttpBaseRequestItem
@property (nonatomic, strong) ProjectDetailRequestItem_data<Optional> *data;
@end

@interface ProjectDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString *projectId;
@end
