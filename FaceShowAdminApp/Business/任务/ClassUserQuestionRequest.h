//
//  ClassUserQuestionRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol ClassUserQuestionRequestItem_elements<NSObject>
@end
@interface ClassUserQuestionRequestItem_elements: JSONModel
@property (nonatomic, strong) NSString<Optional> *unit;
@property (nonatomic, strong) NSString<Optional> *finishedStatus;
@property (nonatomic, strong) NSString<Optional> *finishedTime;
@property (nonatomic, strong) NSString<Optional> *mobilePhone;
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *userId;
@end

@protocol ClassUserQuestionRequestItem_callbacks<NSObject>
@end
@interface ClassUserQuestionRequestItem_callbacks: JSONModel
@property (nonatomic, strong) NSString<Optional> *callbackParam;
@property (nonatomic, strong) NSString<Optional> *callbackValue;
@end

@interface ClassUserQuestionRequestItem_data: JSONModel
@property (nonatomic, strong) NSString<Optional> *totalElements;
@property (nonatomic, strong) NSArray<Optional,ClassUserQuestionRequestItem_elements> *elements;
@property (nonatomic, strong) NSArray<Optional,ClassUserQuestionRequestItem_callbacks> *callbacks;
@end

@interface ClassUserQuestionRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) ClassUserQuestionRequestItem_data<Optional> *data;
@end

@interface ClassUserQuestionRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *status; // 学员完成状态：默认-全部 1-已完成 0-未完成
@property (nonatomic, strong) NSString<Optional> *callbackId;
@property (nonatomic, strong) NSString<Optional> *pageSize; // default 20
@end
