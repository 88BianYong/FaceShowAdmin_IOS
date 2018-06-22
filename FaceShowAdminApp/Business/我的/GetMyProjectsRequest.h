//
//  GetMyProjectsRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetMyProjectsRequestItem_project<NSObject>
@end

@interface GetMyProjectsRequestItem_project: JSONModel
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *projectName;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *clazsNum;
@property (nonatomic, strong) NSString<Optional> *studentNum;
@property (nonatomic, strong) NSString<Optional> *masterNum;
@property (nonatomic, strong) NSString<Optional> *taskFinishedRate;
@end

@interface GetMyProjectsRequestItem_data: JSONModel
@property (nonatomic, strong) NSArray<Optional,GetMyProjectsRequestItem_project> *projectNoStartCountes;
@property (nonatomic, strong) NSArray<Optional,GetMyProjectsRequestItem_project> *projectGoingCountes;
@property (nonatomic, strong) NSArray<Optional,GetMyProjectsRequestItem_project> *projectFinishedCountes;
@end

@interface GetMyProjectsRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) GetMyProjectsRequestItem_data<Optional> *data;
@end

@interface GetMyProjectsRequest : YXGetRequest
@property (nonatomic, strong) NSString *platId;
@end
