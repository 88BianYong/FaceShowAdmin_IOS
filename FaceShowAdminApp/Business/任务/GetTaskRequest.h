//
//  GetTaskRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetTaskRequestItem_Task <NSObject>
@end
@interface GetTaskRequestItem_Task : JSONModel
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *interactName;
@property (nonatomic, strong) NSString<Optional> *interactType;
@property (nonatomic, strong) NSString<Optional> *interactId;
@property (nonatomic, strong) NSString<Optional> *stepStatus;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *stepFinished;
@property (nonatomic, strong) NSString<Optional> *interactTypeName;
@property (nonatomic, strong) NSString<Optional> *totalStudentNum;
@property (nonatomic, strong) NSString<Optional> *finishedStudentNum;
@property (nonatomic, strong) NSString<Optional> *percent;
@end

@interface GetTaskRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<GetTaskRequestItem_Task, Optional> *tasks;
@end

@interface GetTaskRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetTaskRequestItem_data<Optional> *data;
@end

@interface GetTaskRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@end
