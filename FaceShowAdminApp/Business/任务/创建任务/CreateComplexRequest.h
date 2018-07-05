//
//  CreateComplexRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"
#import "GetTaskRequest.h"
typedef NS_ENUM(NSInteger,CreateComplexType) {
    CreateComplex_Vote,//投票
    CreateComplex_Questionnaire,//问卷
    CreateComplex_Evaluate//评价
};
@interface CreateComplexRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetTaskRequestItem_Task<Optional> *data;
@end

@interface CreateComplexRequest : YXPostRequest
@property (nonatomic, copy) NSString<Optional> *courseId;
@property (nonatomic, copy) NSString<Optional> *clazsId;
@property (nonatomic, copy) NSString<Optional> *questionGroup;
@property (nonatomic, copy) NSString<Optional> *templateId;
@property (nonatomic, assign) CreateComplexType createType;
@end
