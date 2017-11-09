//
//  CourseResourceRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol CourseResourceRequestItem_elements<NSObject>
@end
@interface CourseResourceRequestItem_elements: JSONModel
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *publisherId;
@property (nonatomic, strong) NSString<Optional> *publisherName;
@property (nonatomic, strong) NSString<Optional> *viewNum;
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *downNum;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *resId;
@property (nonatomic, strong) NSString<Optional> *suffix;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *clazzId;
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *createTimeStr;
@property (nonatomic, strong) NSString<Optional> *totalClazsStudentNum;
@property (nonatomic, strong) NSString<Optional> *viewClazsStudentNum;
@end

@protocol CourseResourceRequestItem_callbacks<NSObject>
@end
@interface CourseResourceRequestItem_callbacks: JSONModel
@property (nonatomic, strong) NSString<Optional> *callbackParam;
@property (nonatomic, strong) NSString<Optional> *callbackValue;
@end

@interface CourseResourceRequestItem_resources: JSONModel
@property (nonatomic, strong) NSString<Optional> *totalElements;
@property (nonatomic, strong) NSArray<Optional,CourseResourceRequestItem_elements> *elements;
@property (nonatomic, strong) NSArray<Optional,CourseResourceRequestItem_callbacks> *callbacks;
@end

@interface CourseResourceRequestItem_data: JSONModel
@property (nonatomic, strong) CourseResourceRequestItem_resources<Optional> *resources;
@end

@interface CourseResourceRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) CourseResourceRequestItem_data<Optional> *data;
@end

@interface CourseResourceRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *callbackId;
@property (nonatomic, strong) NSString<Optional> *pageSize; // default 20
@end
