//
//  ResourceManagerRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol ResourceManagerRequestItem_Data_Resources_Elements
@end
@interface ResourceManagerRequestItem_Data_Resources_Elements : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *publisherId;
@property (nonatomic, strong) NSString<Optional> *publisherName;
@property (nonatomic, strong) NSString<Optional> *viewNum;
@property (nonatomic, strong) NSString<Optional> *downNum;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *resId;
@property (nonatomic, strong) NSString<Optional> *suffix;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *clazzId;
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *createTimeStr;
@property (nonatomic, strong) NSString<Optional> *ai;
@property (nonatomic, strong) NSString<Optional> *resNum;
@property (nonatomic, strong) NSString<Optional> *viewNumSum;
@property (nonatomic, strong) NSString<Optional> *downNumSum;
@property (nonatomic, strong) NSString<Optional> *totalClazsStudentNum;
@property (nonatomic, strong) NSString<Optional> *viewClazsStudentNum;
@end

@interface ResourceManagerRequestItem_Data_Resources : JSONModel
@property (nonatomic, strong) NSArray<ResourceManagerRequestItem_Data_Resources_Elements,Optional> *elements;
@property (nonatomic, strong) NSString<Optional> *callbackParam;
@property (nonatomic, strong) NSString<Optional> *callbackValue;
@property (nonatomic, strong) NSString<Optional> *totalElements;
@end

@interface ResourceManagerRequestItem_Data : JSONModel
@property (nonatomic, strong) ResourceManagerRequestItem_Data_Resources<Optional> *resources;
@end

@interface ResourceManagerRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ResourceManagerRequestItem_Data<Optional> *data;
@end

@interface ResourceManagerRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *pageSize;

@end
