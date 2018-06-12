//
//  CreateComplexRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "GetTaskRequest.h"
@interface CreateComplexRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetTaskRequestItem_Task<Optional> *data;
@end

@interface CreateComplexRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *courseId;
@property (nonatomic, copy) NSString<Optional> *clazsId;
@property (nonatomic, copy) NSString<Optional> *questionGroup;
@end
